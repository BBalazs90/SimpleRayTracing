//
//  main.swift
//  SimpleRayTracing
//
//  Created by Balazs on 09/03/2024.
//

import Foundation

struct Vec3f{
    let X: Float
    let Y: Float
    let Z: Float
}

func render() -> Void{
    let file = "testfile.ppm"
    let width = 1024
    let height = 768
    
    var data = Data()
    
    data.append(contentsOf: "P6\n".utf8)
    data.append(contentsOf: "\(width) \(height)\n255\n".utf8)
    
    for i in 0..<width*height {
        for j in 0..<3 {
            if j == 1 {
                data.append(contentsOf: [255])
            }
            else {
                data.append(contentsOf: [0])
            }
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

