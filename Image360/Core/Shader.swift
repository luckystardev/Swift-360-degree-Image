//
//  Shader.swift
//  Image360
//


import Foundation

class Shader {
    let sourceCode: String

    init?(filename: String) {
        let components = filename.components(separatedBy: ".")
        guard components.count == 2 else {
            return nil
        }
        guard let url = Bundle(for: Shader.self).url(forResource: components[0],
                                                     withExtension: components[1]) else {
                                                        return nil
        }
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        guard let sourceCode = String(data: data, encoding: String.Encoding.utf8) else {
            return nil
        }
        self.sourceCode = sourceCode
    }

    static let vertexShader = Shader(filename: "VertexShader.glsl")!
    static let fragmentShader = Shader(filename: "FragmentShader.glsl")!
}
