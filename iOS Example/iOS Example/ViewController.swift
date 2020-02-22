//
//  ViewController.swift
//  iOS Example
//

import UIKit
import Image360

private let picture1URL = Bundle.main.url(forResource: "picture1", withExtension: "jpg")!
private let picture2URL = Bundle.main.url(forResource: "picture2", withExtension: "jpg")!

class ViewController: UIViewController {

    @IBOutlet var angleXZSlider: UISlider!
    @IBOutlet var angleYSlider: UISlider!
    @IBOutlet var fovSlider: UISlider!

    private var image360Controller: Image360Controller!

    @IBOutlet var pictureSegmentedControl: UISegmentedControl!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "image360":
                if let destination = segue.destination as? Image360Controller {
                    self.image360Controller = destination
                    self.image360Controller.imageView.observer = self
                }
            case "settings":
                if let destination = segue.destination as? SettingsController {
                    destination.inertia = image360Controller.inertia
                    destination.pictureIndex = pictureSegmentedControl.selectedSegmentIndex
                    destination.isOrientationViewHidden = image360Controller.isOrientationViewHidden
                    destination.isDeviceMotionControlEnabled = image360Controller.isDeviceMotionControlEnabled
                    destination.isGestureControlEnabled = image360Controller.isGestureControlEnabled
                }
            default:
                ()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if pictureSegmentedControl.selectedSegmentIndex < 0 {
            pictureSegmentedControl.selectedSegmentIndex = 0
            segmentChanged(sender: pictureSegmentedControl)
        }
    }

    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        guard let settingsController = segue.source as? SettingsController else {
            assertionFailure("Unexpected controller's type")
            return
        }
        image360Controller.inertia = settingsController.inertia
        pictureSegmentedControl.selectedSegmentIndex = settingsController.pictureIndex
        image360Controller.isOrientationViewHidden = settingsController.isOrientationViewHidden
        image360Controller.isDeviceMotionControlEnabled = settingsController.isDeviceMotionControlEnabled
        image360Controller.isGestureControlEnabled = settingsController.isGestureControlEnabled
        segmentChanged(sender: pictureSegmentedControl)
    }

    @IBAction func segmentChanged(sender: UISegmentedControl) {
        let pictureURL: URL
        switch sender.selectedSegmentIndex {
        case 0:
            pictureURL = picture1URL
        case 1:
            pictureURL = picture2URL
        default:
            assertionFailure("Unexpected selected segment index")
            return
        }

        do {
            let data = try Data(contentsOf: pictureURL)
            if let image = UIImage(data: data) {
                self.image360Controller.image = image
            } else {
                NSLog("ViewController.segmentChanged - data is not an image")
            }
        } catch  {

        }
    }

    @IBAction func angleXZSliderChanged(sender: UISlider) {
        image360Controller.imageView.observer = nil
        let imageView = image360Controller.imageView
        let newRotationAngleXZ = (imageView.rotationAngleXZMax - imageView.rotationAngleXZMin) * sender.value + imageView.rotationAngleXZMin
        image360Controller.imageView.setRotationAngleXZ(newValue: newRotationAngleXZ)
        image360Controller.imageView.observer = self
    }

    @IBAction func angleYSliderChanged(sender: UISlider) {
        image360Controller.imageView.observer = nil
        let imageView = image360Controller.imageView
        let newRotationAngleY = (imageView.rotationAngleYMax - imageView.rotationAngleYMin) * sender.value + imageView.rotationAngleYMin
        image360Controller.imageView.setRotationAngleY(newValue: newRotationAngleY)
        image360Controller.imageView.observer = self
    }

    @IBAction func fovSliderChanged(sender: UISlider) {
        image360Controller.imageView.observer = nil
        let imageView = image360Controller.imageView
        let newFOV = (imageView.cameraFOVDegreeMax - imageView.cameraFOVDegreeMin) * sender.value + imageView.cameraFOVDegreeMin
        image360Controller.imageView.setCameraFovDegree(newValue: newFOV)
        image360Controller.imageView.observer = self
    }
}

// MARK: - Image360ViewObserver
extension ViewController: Image360ViewObserver {
    func image360View(_ view: Image360View, didChangeFOV cameraFov: Float) {

    }

    func image360View(_ view: Image360View, didRotateOverY rotationAngleY: Float) {
        angleYSlider.value = (rotationAngleY - view.rotationAngleYMin) / (view.rotationAngleYMax - view.rotationAngleYMin)
    }

    func image360View(_ view: Image360View, didRotateOverXZ rotationAngleXZ: Float) {
        angleXZSlider.value = (rotationAngleXZ - view.rotationAngleXZMin) / (view.rotationAngleXZMax - view.rotationAngleXZMin)
    }
}
