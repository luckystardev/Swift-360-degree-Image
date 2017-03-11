//
//  Inertia.swift
//  Image360
//


import Foundation

/// ## Inertia
/// possible values:
/// - **none** Inertia is disabled. **Image360View** just freezes after each pan gesture.
/// - **short** Inertia is enabled. **Image360View** continue to rotate in short range after each pan gesture.
/// - **long** Inertia is enabled. **Image360View** continue to rotate in long range after each pan gesture.
public enum Inertia {
    /// Inertia is disabled. **Image360View** just freezes after each pan gesture.
    case none
    /// Inertia is enabled. **Image360View** continue to rotate in short range after each pan gesture.
    case short
    /// Inertia is enabled. **Image360View** continue to rotate in long range after each pan gesture.
    case long
}
