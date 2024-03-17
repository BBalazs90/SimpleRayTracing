//
//  vec2f.swift
//  SimpleRayTracing
//
//  Created by Balazs on 16/03/2024.
//

import Foundation

struct Vec2f{
    let x: Float
    let y: Float
    
    func normalize() -> Vec2f {
        let length = sqrtf(x*x + y*y)
        return Vec2f(x: x/length, y: y/length)
    }
    
    static func + (lhs: Vec2f, rhs: Vec2f) -> Vec2f {
        return Vec2f(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func - (lhs: Vec2f, rhs: Vec2f) -> Vec2f {
        return Vec2f(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func * (lhs: Vec2f, rhs: Vec2f) -> Float {
        return lhs.x * rhs.x + lhs.y * rhs.y
    }
    
    static func * (lhs: Float, rhs: Vec2f) -> Vec2f {
        return Vec2f(x: lhs * rhs.x, y: lhs * rhs.y)
    }
    
    subscript(index: Int) -> Float {
        get {
            switch index {
            case 0: return x
            case 1: return y
            default:
                return 0;
            }
        }
    }
}
