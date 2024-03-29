//
//  main.swift
//  SimpleRayTracing
//
//  Created by Balazs on 09/03/2024.
//

import Foundation

let fieldOfViewAngle:Float = 1.6

struct Material {
    let albedo: Vec2f
    let diffuseColor: Vec3f
    let specularExponent: Float
}

func reflect(from lightSourceDir: Vec3f, at surfaceNormal: Vec3f) -> Vec3f{
    lightSourceDir - (2.0*surfaceNormal)*(lightSourceDir*surfaceNormal)
}

func sceneIntersect(startedFrom rayOrigin: Vec3f, towards rayDirection: Vec3f, with spheres: [Sphere]) -> (doesIntersect: Bool, rayHitCoord: Vec3f?, surfaceNormal: Vec3f?, material: Material?){
    
    var spheresDistance = Float.infinity
    var rayHitCoord: Vec3f?
    var surfaceNormal: Vec3f?
    var material: Material?
    
    for sphere in spheres {
        let (doesIntersect, distance) = sphere.rayIntersects(startedFrom: rayOrigin, towards: rayDirection)
        if doesIntersect && distance < spheresDistance {
            spheresDistance = distance
            rayHitCoord = rayOrigin + (distance * rayDirection)
            surfaceNormal = (rayHitCoord! - sphere.center).normalize()
            material = sphere.material
        }
    }
    return (spheresDistance < 1000, rayHitCoord, surfaceNormal, material)
}

func castRay(startedFrom rayOrigin: Vec3f, towards rayDirection: Vec3f, on spheres: [Sphere], with lights: [Light]) -> Vec3f{
    let intersectCalcResult = sceneIntersect(startedFrom: rayOrigin, towards: rayDirection, with: spheres)
    if !intersectCalcResult.doesIntersect{
        return Vec3f(x: 0.2, y: 0.7, z: 0.8)
    }
    
    var diffuseLightIntensity: Float = 0
    var specularLightIntensity: Float = 0
    
    for light in lights {
        let lightDir = (light.position - intersectCalcResult.rayHitCoord!).normalize()
        let lightDistance = (light.position - intersectCalcResult.rayHitCoord!).length
        
        let shadowOrig = lightDir*intersectCalcResult.surfaceNormal! < 0
        ? intersectCalcResult.rayHitCoord! - 1e-3 * intersectCalcResult.surfaceNormal!
        : intersectCalcResult.rayHitCoord! + 1e-3 * intersectCalcResult.surfaceNormal!
        
        let shadowCalcResult = sceneIntersect(startedFrom: shadowOrig, towards: lightDir, with: spheres)
        if shadowCalcResult.doesIntersect
            && (shadowCalcResult.rayHitCoord! - shadowCalcResult.surfaceNormal!).length < lightDistance { continue }
        
        diffuseLightIntensity += light.intensity * max(0, lightDir*intersectCalcResult.surfaceNormal!)
        specularLightIntensity += powf(max(0, -1*reflect(from: -1*lightDir, at: intersectCalcResult.surfaceNormal!)*rayDirection), intersectCalcResult.material!.specularExponent)*light.intensity
    }
    
    return diffuseLightIntensity 
    * intersectCalcResult.material!.diffuseColor
    * intersectCalcResult.material!.albedo[0]
    + Vec3f(x: 1, y: 1, z: 1)
    * specularLightIntensity
    * intersectCalcResult.material!.albedo[1]
}

func render(with spheres: [Sphere], and lights: [Light]) -> Void{
    let file = "testfile.ppm"
    let width = 1920
    let height = 1080
    
    
    var buffer = Array<Vec3f>(repeating: Vec3f(x: 0.0, y: 0.0, z: 0.0), count: width*height)
    for j in 0..<height{
        for i in 0..<width {
            let x =  (2.0*(Float(i)+0.5) / Float(width) -  1) * tanf(fieldOfViewAngle/2.0)*Float(width)/Float(height)
            let y = -(2.0*(Float(j)+0.5) / Float(height) - 1) * tanf(fieldOfViewAngle/2.0)
            let dir = Vec3f(x: x, y: y, z: -1).normalize()
            buffer[i + j*width] = castRay(startedFrom: Vec3f(x: 0, y: 0, z: 0), towards: dir, on: spheres, with: lights)
        }
    }
    
    var data = Data()
    
    data.append(contentsOf: "P6\n".utf8)
    data.append(contentsOf: "\(width) \(height)\n255\n".utf8)
    
    for i in 0..<width*height {
        for j in 0..<3 {
            data.append(contentsOf: [UInt8(min(255, Float(255)*buffer[i][j]))])
        }
    }
    
    if let dir = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first {
        let fileUrl = dir.appending(path: file)
        
        do {
            try data.write(to: fileUrl)
        }
        catch {
            // Swallow just now
        }
    }
}

let ivory = Material(albedo: Vec2f(x: 0.6, y: 0.9), diffuseColor: Vec3f(x: 0.4, y: 0.4, z: 0.3), specularExponent: 50)
let redRubber = Material(albedo: Vec2f(x: 0.9, y: 0.1), diffuseColor: Vec3f(x: 0.3, y: 0.1, z: 0.1), specularExponent: 10)
let spheres = [Sphere(center: Vec3f(x: -3, y: 0, z: -16), radius: 2, material: ivory),
               Sphere(center: Vec3f(x: -1, y: -1.5, z: -12), radius: 2, material: redRubber),
               Sphere(center: Vec3f(x: 1.5, y: -0.5, z: -18), radius: 3, material: redRubber),
               Sphere(center: Vec3f(x: 7, y: 5, z: -18), radius: 4, material: ivory)]

let lights = [Light(position: Vec3f(x: -20, y: 20, z: 50), intensity: 2),
              Light(position: Vec3f(x: -20, y: 0, z: 1), intensity: 1)]

render(with: spheres, and: lights)

