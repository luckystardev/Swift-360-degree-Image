//
//  SettingsController.swift
//  iOS Example
//


import UIKit
import Image360

class SettingsController: UIViewController {

    @IBOutlet var inertiaSegmentedControl: UISegmentedControl!
    @IBOutlet var pictureSegmentedControl: UISegmentedControl!
    @IBOutlet var isOrientationViewHiddenSwitch: UISwitch!

    @IBOutlet var saveButton: UIBarButtonItem!

    var inertia: Inertia = .none
    var pictureIndex: Int = 0
    var isOrientationViewHidden: Bool = false

    private var initInertia: Inertia!
    private var initPictureIndex: Int!
    private var initIsOrientationViewHidden: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()

        switch inertia {
        case .none:
            inertiaSegmentedControl.selectedSegmentIndex = 0
        case .short:
            inertiaSegmentedControl.selectedSegmentIndex = 1
        case .long:
            inertiaSegmentedControl.selectedSegmentIndex = 2
        }
        isOrientationViewHiddenSwitch.isOn = isOrientationViewHidden

        initInertia = inertia
        initPictureIndex = pictureIndex
        initIsOrientationViewHidden = isOrientationViewHidden
        pictureSegmentedControl.selectedSegmentIndex = pictureIndex
    }

    @IBAction func inertiaSegmentChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: inertia = .none
        case 1: inertia = .short
        case 2: inertia = .long
        default:
            assertionFailure("Unexpected selected segment index")
        }
        saveButton.isEnabled = valuesChanged
    }

    @IBAction func pictureSegmentChanged(sender: UISegmentedControl) {
        pictureIndex = sender.selectedSegmentIndex
        saveButton.isEnabled = valuesChanged
    }
    
    @IBAction func isOrientationViewHiddenSwitched(sender: UISwitch) {
        isOrientationViewHidden = sender.isOn
        saveButton.isEnabled = valuesChanged
    }

    private var valuesChanged: Bool {
        if inertia != initInertia {
            return true
        } else if pictureIndex != initPictureIndex {
            return true
        } else if initIsOrientationViewHidden != isOrientationViewHidden {
            return true
        } else {
            return false
        }
    }
}
