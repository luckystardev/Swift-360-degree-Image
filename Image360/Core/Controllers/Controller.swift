//
//  Controller.swift
//  Image360
//

import Foundation

/// ## Controller
/// Instances of protocol `Image360.Controller` should be able to
/// control content scale & rotation of `Image360View`. For example, controllers
/// which rotate view by gestures or by device motions.
public protocol Controller {
    /// `Image360View` instance which is under control of `Controller`
    var imageView: Image360View? {get set}
    /// A Boolean value indicating whether the controller is enabled.
    var isEnabled: Bool {get set}
    /// Inertia of controller reactions.
    var inertia: Float {get set}
}
