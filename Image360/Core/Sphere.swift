//
//  Sphere.swift
//  Image360
//


import Foundation
import GLKit

class Sphere {
    private(set) var vertexArray: [[GLfloat]]
    private(set) var texCoordsArray: [[GLfloat]]
    private(set) var mDivide: Int


    /// Inits a new sphere.
    /// Sphere is created at the specified radius centered on the origin. Sphere and corresponding texture coordinates are created by creating a divide/2 band in the longitudinal direction and dividing the band by the divide number.
    /// - parameter radius: Radius.
    /// - parameter divide: Polygon partition parameter.
    /// - parameter rotate: Rotation angle (radian) in horizontal direction (yaw).
    init(radius: GLfloat, divide: Int, rotate: Double) {
        vertexArray = [[GLfloat]]()
        texCoordsArray = [[GLfloat]]()
        mDivide = divide

        var altitude: Double = 0
        var altitudeDelta: Double = 0
        var azimuth: Double = 0

        for index in 0 ..< mDivide/2 {

            altitude      = M_PI_2 - Double(index)   * (M_PI * 2 / Double(mDivide))
            altitudeDelta = M_PI_2 - Double(index + 1) * (M_PI * 2 / Double(mDivide))

            var vertices  = [GLfloat](repeating: 0, count: (mDivide + 1) * 6)
            var texCoords = [GLfloat](repeating: 0, count: (mDivide + 1) * 4)

            for j in 0 ... mDivide / 2 {

                azimuth = rotate - Double(j) * (2 * M_PI / Double(mDivide))

                // 1st point
                vertices[j * 6 + 0] = (radius * cos(GLfloat(altitudeDelta)) * cos(GLfloat(azimuth))) // TODO: Types hell
                vertices[j * 6 + 1] = (radius * sin(GLfloat(altitudeDelta)))
                vertices[j * 6 + 2] = (radius * cos(GLfloat(altitudeDelta)) * sin(GLfloat(azimuth)))

                texCoords[j * 4 + 0] =  (1.0 - (2.0 * GLfloat(j) / GLfloat(mDivide)))
                texCoords[j * 4 + 1] =  (2 * (GLfloat(index) + 1) / GLfloat(mDivide))

                // 2nd point
                vertices[j * 6 + 3] = (radius * cos(GLfloat(altitude)) * cos(GLfloat(azimuth)))
                vertices[j * 6 + 4] = (radius * sin(GLfloat(altitude)))
                vertices[j * 6 + 5] = (radius * cos(GLfloat(altitude)) * sin(GLfloat(azimuth)))

                texCoords[j * 4 + 2] =  (1.0 - (2.0 * GLfloat(j) / GLfloat(mDivide)))
                texCoords[j * 4 + 3] =  (2 * GLfloat(index) / GLfloat(mDivide))
            }

            vertexArray.append(vertices)
            texCoordsArray.append(texCoords) // TODO: map!
        }
    }
}
