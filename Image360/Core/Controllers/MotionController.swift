//
//  MotionController.swift
//  Image360
//

import UIKit
import CoreMotion

/// ## MotionController
/// Motion controller is responsible for `Image360View` rotation control via device motions.
final class MotionController: Controller {
    /// `Image360View` which is under control of `MotionController`.
    weak var imageView: Image360View?
    /// Inertia of motions. Is ignored at the moment.
    var inertia: Float = 0.0
    
    /// Default `MotionController` constructor.
    init() {
        isEnabled = motionManager.isDeviceMotionAvailable
        if isEnabled {
            enableDeviceMotionControl()
        }
    }
    
    /// MARK: Motion Management
    private var motionManager = CMMotionManager()
    
    private func enableDeviceMotionControl() {
        motionManager.deviceMotionUpdateInterval = 0.02
        let queue = OperationQueue()
        motionManager.startDeviceMotionUpdates(to: queue, withHandler: deviceDidMove)
    }
    
    private func disableDeviceMotionControl() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    /// If this flag is `true` then `Image360View`-orientation could be controled with device motions.
    var isEnabled: Bool {
        didSet {
            if isEnabled && !motionManager.isDeviceMotionAvailable {
                NSLog("Image360: Device motion is not available on this device")
                isEnabled = false
            } else if oldValue != isEnabled {
                isEnabled ? enableDeviceMotionControl() : disableDeviceMotionControl()
            }
        }
    }
    
    private var _lastAttitude: CMAttitude?
    private var _lastOrientation: UIInterfaceOrientation?
    
    /// Device Motion Updates Handler
    /// - parameter data: New data of device motion.
    /// - parameter error: Error catched by device.
    private func deviceDidMove(data: CMDeviceMotion?, error: Error?) {
        guard let data = data else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            let currentOrientation = UIApplication.shared.statusBarOrientation
            guard let lastAttitude = self?._lastAttitude, let lastOrientation = self?._lastOrientation, currentOrientation == lastOrientation else {
                self?._lastAttitude = data.attitude
                self?._lastOrientation = currentOrientation
                return
            }
            self?._lastAttitude = data.attitude.copy() as? CMAttitude
            
            data.attitude.multiply(byInverseOf: lastAttitude)
            
            let diffXZ: Float
            let diffY: Float
            
            switch lastOrientation {
            case .portrait:
                diffXZ = -Float(data.attitude.roll)
                diffY = Float(data.attitude.pitch)
            case .portraitUpsideDown:
                diffXZ = Float(data.attitude.roll)
                diffY = -Float(data.attitude.pitch)
            case .landscapeLeft:
                diffXZ = Float(data.attitude.pitch)
                diffY = Float(data.attitude.roll)
            case .landscapeRight:
                diffXZ = -Float(data.attitude.pitch)
                diffY = -Float(data.attitude.roll)
            default:
                return
            }
            self?.rotate(diffx: diffXZ, diffy: diffY)
        }
    }
    
    /// Rotation method
    /// - parameter diffx: Rotation amount (y axis)
    /// - parameter diffy: Rotation amount (xy plane)
    private func rotate(diffx: Float, diffy: Float) {
        guard let imageView = imageView else {
            return
        }
        imageView.setRotationAngleXZ(newValue: imageView.rotationAngleXZ + diffx)
        imageView.setRotationAngleY(newValue: imageView.rotationAngleY + diffy)
    }
}
