//
//  sphere.swift
//  SimpleRayTracing
//
//  Created by Balazs on 14/03/2024.
//

import Foundation

struct Sphere {
    let center: Vec3f
    let radius: Float
    let material: Material
    
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
