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
    var imageView: Image360View {
        set {
            self.view = newValue
        }
        get {
            guard let image360View = self.view as? Image360View else {
                fatalError("View of Image360GLController is not a Image360View")
            }
            return image360View
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Image360GLController init?(coder:) isn't implemented")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.imageView = Image360View(frame: CGRect(x: 0, y: 0, width: 512, height: 512))
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        imageView.draw(rect)
    }
}
