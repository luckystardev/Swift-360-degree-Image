//
//  GestureController.swift
//  Image360
//

import Foundation

/// ## GestureController
/// Gesture controller is responsible for `Image360View` rotation & scaling control via gestures.
final class GestureController: NSObject, Controller {
    /// `Image360View` which is under control of `GestureController`.
    weak var imageView: Image360View? {
        didSet {
            imageView?.touchesHandler = self
            if isEnabled {
                registerGestureRecognizers()
            } else {
                removeGestureRecognizers()
            }
        }
    }
    
    override init() {
        isEnabled = true
        super.init()
    }
    
    // MARK: Inertia
    private let inertiaInterval: TimeInterval = 0.020
    
    private var inertiaRatio: Float?
    
    /// Inertia of pan gestures. In case inertia is enabled then
    /// `imageView` continue to rotate after pan gestures for some time.
    /// Range of value: 0...1
    var inertia: Float = 0.1 {
        willSet {
            inertiaTimer?.invalidate()
            inertiaTimer = nil
            inertiaTimerCount = 0
        }
    }
    
    fileprivate var inertiaTimerCount: UInt = 0
    fileprivate var inertiaTimer: Timer?
    
    /// If this flag is `true` then `ImageView360`-orientation could be controled with gestures.
    var isEnabled: Bool {
        didSet {
            guard oldValue != isEnabled else {
                return
            }
            if isEnabled {
                registerGestureRecognizers()
            } else {
                removeGestureRecognizers()
            }
        }
    }
    
    // Gesture recognizers.
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var pinchGestureRecognizer: UIPinchGestureRecognizer?
    
    fileprivate var isPanning = false
    private var panPrev: CGPoint?
    private var panLastDiffX: CGFloat?
    private var panLastDiffY: CGFloat?
    
    /// Creates gesture recognazer instances.
    private func registerGestureRecognizers() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(recognizer:)))
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.delegate = self
        imageView?.addGestureRecognizer(panGestureRecognizer)
        self.panGestureRecognizer = panGestureRecognizer
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureHandler(recognizer:)))
        pinchGestureRecognizer.delegate = self
        imageView?.addGestureRecognizer(pinchGestureRecognizer)
        self.pinchGestureRecognizer = pinchGestureRecognizer
    }
    
    /// Remove gesture recognazer instances.
    private func removeGestureRecognizers() {
        if let panGestureRecognizer = panGestureRecognizer {
            imageView?.removeGestureRecognizer(panGestureRecognizer)
        }
        if let pinchGestureRecognizer = pinchGestureRecognizer {
            imageView?.removeGestureRecognizer(pinchGestureRecognizer)
        }
        panGestureRecognizer = nil
        pinchGestureRecognizer = nil
    }
    
    /// Pinch operation compatibility handler
    /// - parameter recognizer: Recognizer object for gesture operations
    @objc func pinchGestureHandler(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .began:
            prevScale = 1.0
        default:
            ()
        }
        scale(ratio: recognizer.scale)
    }
    
    /// Pan operation compatibility handler
    /// - parameter recognizer: Recognizer object for gesture operations
    @objc func panGestureHandler(recognizer: UIPanGestureRecognizer) {
        let cur = recognizer.translation(in: imageView)
        
        switch recognizer.state {
        case .ended:
            inertiaTimer?.invalidate()
            inertiaTimerCount = 0
            
            if inertia > 0.05 {
                inertiaTimer = Timer.scheduledTimer(timeInterval: inertiaInterval,
                                                    target: self,
                                                    selector: #selector(inertiaTimerHandler(timer:)),
                                                    userInfo: nil,
                                                    repeats: true)
            }
        default:
            if isPanning {
                panLastDiffX = cur.x - panPrev!.x
                panLastDiffY = cur.y - panPrev!.y
                
                panPrev = cur
                rotate(diffx: -Float(panLastDiffX!) / divideRotateX,
                       diffy: Float(panLastDiffY!) / divideRotateY)
            } else {
                isPanning = true
                panPrev = cur
            }
        }
    }
    
    /// Timer setting method
    /// - parameter timer: Setting target timer
    @objc func inertiaTimerHandler(timer: Timer) {
        var diffX: Float = 0
        var diffY: Float = 0
        
        if inertiaTimerCount == 0 {
            inertiaRatio = inertia * 10.0
        } else if inertiaTimerCount > 150 {
            inertiaTimer?.invalidate()
            inertiaTimer = nil
            inertiaTimerCount = 0
        } else {
            diffX = Float(panLastDiffX!) * (1.0 / Float(inertiaTimerCount)) * inertiaRatio!
            diffY = Float(panLastDiffY!) * (1.0 / Float(inertiaTimerCount)) * inertiaRatio!
            
            rotate(diffx: -diffX / divideRotateX,
                   diffy: diffY / divideRotateY)
        }
        
        inertiaTimerCount += 1
    }
    
    // MARK: Scaling & rotation
    private var prevScale: CGFloat = 1.0
    /// Parameter for maximum width control
    private let scaleRatioTickExpansion: Float = 1.05
    /// Parameter for minimum width control
    private let scaleRatioTickReduction: Float = 0.95
    
    /// Zoom in/Zoom out method
    /// - parameter ratio: Zoom in/zoom out ratio
    private func scale(ratio: CGFloat) {
        if let imageView = imageView {
            if ratio < prevScale {
                imageView.setCameraFovDegree(newValue: imageView.cameraFovDegree * scaleRatioTickExpansion)
            } else {
                imageView.setCameraFovDegree(newValue: imageView.cameraFovDegree * scaleRatioTickReduction)
            }
        }
        prevScale = ratio
    }
    
    /// Parameter for amount of rotation control (X axis)
    private let divideRotateX: Float = 500.0
    /// Parameter for amount of rotation control (Y axis)
    private let divideRotateY: Float = 500.0
    
    /// Rotation method
    /// - parameter diffx: Rotation amount (y axis)
    /// - parameter diffy: Rotation amount (xy plane)
    private func rotate(diffx: Float, diffy: Float) {
        if let imageView = imageView {
            imageView.setRotationAngleXZ(newValue: imageView.rotationAngleXZ + diffx)
            imageView.setRotationAngleY(newValue: imageView.rotationAngleY + diffy)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension GestureController: UIGestureRecognizerDelegate {
    // UIGestureRecognizerDelegate.gestureRecognizer(_:shouldRecognizeSimultaneouslyWith:) handler.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

// MARK: - Image360ViewTouchesHandler
extension GestureController: Image360ViewTouchesHandler {
    func image360View(_ view: Image360View, touchesBegan touches: Set<UITouch>, with event: UIEvent?) {
        inertiaTimer?.invalidate()
        inertiaTimer = nil
        inertiaTimerCount = 0
        
        isPanning = false
    }
    
    func image360View(_ view: Image360View, touchesMoved touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func image360View(_ view: Image360View, touchesEnded touches: Set<UITouch>, with event: UIEvent?) {
    }
}
