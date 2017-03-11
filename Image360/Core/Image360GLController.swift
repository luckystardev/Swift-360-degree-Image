//
//  Image360GLController.swift
//  Image360
//



import UIKit
import GLKit

/// ## Image360GLController
/// This controller presentes a special OpenGL view to dysplay 360° panoramic image.
class Image360GLController: GLKViewController {
    /// Image 360 view which actually dysplays 360° panoramic image.
    var imageView: Image360View
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Image360GLController init?(coder:) isn't implemented")
    }
    
    init(imageView: Image360View) {
        self.imageView = imageView
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = imageView
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        imageView.draw(rect)
    }
}
