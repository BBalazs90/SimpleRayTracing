//
//  vec3f.swift
//  SimpleRayTracing
//
//  Created by Balazs on 14/03/2024.
//

import Foundation

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
    
    static func * (lhs: Float, rhs: Vec3f) -> Vec3f {
        return Vec3f(x: lhs * rhs.x, y: lhs * rhs.y, z: lhs * rhs.z)
    }
    
    static func * (lhs: Vec3f, rhs: Float) -> Vec3f {
        return Vec3f(x: rhs * lhs.x, y: rhs * lhs.y, z: rhs * lhs.z)
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
