//
//  Sphere.swift
//  Image360
//

import Foundation
import GLKit

class Sphere {
    let vertexArray: [[GLfloat]]
    let texCoordsArray: [[GLfloat]]
    let mDivide: Int

    /// Inits a new sphere.
    /// Sphere is created at the specified radius centered on the origin. Sphere and corresponding texture coordinates are created by creating a divide/2 band in the longitudinal direction and dividing the band by the divide number.
    /// - parameter radius: Radius.
    /// - parameter divide: Polygon partition parameter.
    /// - parameter rotate: Rotation angle (radian) in horizontal direction (yaw).
    init(radius: Double, divide: Int, rotate: Double) {
        mDivide = divide

        var altitude: Double = 0
        var altitudeDelta: Double = 0
        var azimuth: Double = 0
        
        let sectorSize = Double.pi * 2 / Double(divide)
        
        vertexArray = (0 ..< divide / 2).map { partIndex in
            altitude      = Double.pi / 2 - Double(partIndex) * sectorSize
            altitudeDelta = Double.pi / 2 - Double(partIndex + 1) * sectorSize
            
            var vertices  = [GLfloat](repeating: 0, count: (divide + 1) * 6)
            
            for subPartIndex in 0 ... divide / 2 {
                azimuth = rotate - Double(subPartIndex) * sectorSize
                
                // 1st point
                vertices[subPartIndex * 6 + 0] = GLfloat(radius * cos(altitudeDelta) * cos(azimuth))
                vertices[subPartIndex * 6 + 1] = GLfloat(radius * sin(altitudeDelta))
                vertices[subPartIndex * 6 + 2] = GLfloat(radius * cos(altitudeDelta) * sin(azimuth))
                
                // 2nd point
                vertices[subPartIndex * 6 + 3] = GLfloat(radius * cos(altitude) * cos(azimuth))
                vertices[subPartIndex * 6 + 4] = GLfloat(radius * sin(altitude))
                vertices[subPartIndex * 6 + 5] = GLfloat(radius * cos(altitude) * sin(azimuth))
            }
            return vertices
        }
        texCoordsArray =  (0 ..< divide / 2).map { partIndex in
            var texCoords = [GLfloat](repeating: 0, count: (divide + 1) * 4)

            for subPartIndex in 0 ... divide / 2 {
                // 1st point
                texCoords[subPartIndex * 4 + 0] =  (1.0 - (GLfloat(subPartIndex * 2) / GLfloat(divide)))
                texCoords[subPartIndex * 4 + 1] =  (2 * GLfloat(partIndex + 1) / GLfloat(divide))

                // 2nd point
                texCoords[subPartIndex * 4 + 2] =  (1.0 - (GLfloat(subPartIndex * 2) / GLfloat(divide)))
                texCoords[subPartIndex * 4 + 3] =  (2 * GLfloat(partIndex) / GLfloat(divide))
            }
            return texCoords
        }
    }
}
