//
//  main.swift
//  SimpleRayTracing
//
//  Created by Balazs on 09/03/2024.
//

import Foundation

let fieldOfViewAngle:Float = 1.6

struct Vec3f{
    let x: Float
    let y: Float
    let z: Float
    
    func normalize() -> Vec3f {
        let length = sqrtf(x*x + y*y + z*z)
        return Vec3f(x: x/length, y: y/length, z: z/length)
    }
    
    static func + (lhs: Vec3f, rhs: Vec3f) -> Vec3f {
        return Vec3f(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    
    static func - (lhs: Vec3f, rhs: Vec3f) -> Vec3f {
        return Vec3f(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
    
    static func * (lhs: Vec3f, rhs: Vec3f) -> Float {
        return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z
    }
    
    subscript(index: Int) -> Float {
        get {
            switch index {
            case 0: return x
            case 1: return y
            case 2: return z
            default:
                return 0;
            }
        }
    }
}

struct Sphere {
    let center: Vec3f
    let radius: Float
    
    func rayIntersects(startedFrom rayOrigin: Vec3f, towards rayDirection: Vec3f) -> (doesIntersect: Bool, intersectionDistance: Float){
        let raySourceToSphereCenter = center - rayOrigin
        let directionProjection = rayDirection * raySourceToSphereCenter
        let projectionDistanceSquared = (raySourceToSphereCenter * raySourceToSphereCenter)
        - (directionProjection * directionProjection)
        
        if projectionDistanceSquared > radius*radius { return (false, 0.0)}
        
        let inSphereIntersectionDistance = sqrtf(radius*radius - projectionDistanceSquared)
        let intersectionDistance1 = directionProjection - inSphereIntersectionDistance
        let intersectionDistance2 = directionProjection + inSphereIntersectionDistance
        
        if intersectionDistance1 < 0{
            if intersectionDistance2 < 0 {
                return (false, 0.0)
            }
            return (true, intersectionDistance2)
        }
        return (true, intersectionDistance1)
    }
}

func castRay(startedFrom rayOrigin: Vec3f, towards rayDirection: Vec3f, on sphere: Sphere) -> Vec3f{
    if !sphere.rayIntersects(startedFrom: rayOrigin, towards: rayDirection).doesIntersect{
        return Vec3f(x: 0.2, y: 0.7, z: 0.8)
    }
    
    return Vec3f(x: 0.4, y: 0.4, z: 0.3)
}

func render() -> Void{
    let file = "testfile.ppm"
    let width = 1024
    let height = 768
    
    var buffer = Array<Vec3f>(repeating: Vec3f(x: 0.0, y: 0.0, z: 0.0), count: width*height)
    for j in 0..<height{
        for i in 0..<width {
            let x =  (2.0*(Float(i)+0.5) / Float(width) -  1) * tanf(fieldOfViewAngle/2.0)*Float(width)/Float(height)
            let y = -(2.0*(Float(j)+0.5) / Float(height) - 1) * tanf(fieldOfViewAngle/2.0)
            let dir = Vec3f(x: x, y: y, z: -1).normalize()
            buffer[i + j*width] = castRay(startedFrom: Vec3f(x: 0, y: 0, z: 0), towards: dir, on: Sphere(center: Vec3f(x: -3, y: 0, z: -16), radius: 2))
        }
    }
    
    var data = Data()
    
    data.append(contentsOf: "P6\n".utf8)
    data.append(contentsOf: "\(width) \(height)\n255\n".utf8)
    
    for i in 0..<width*height {
        for j in 0..<3 {
            data.append(contentsOf: [UInt8(Float(255)*buffer[i][j])])
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


render()

