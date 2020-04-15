//
//  ViewController.swift
//  DexScanner
//
//  Created by Janson Hendryli on 10/04/20.
//  Copyright © 2020 Janson Hendryli. All rights reserved.
//

import UIKit
import SwiftUI
import CameraManager

class ViewController: UIViewController {

    @IBOutlet weak var imagePreview: UIView!
    
    let cameraManager: CameraManager = CameraManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Ask the user for camera permission.
        cameraManager.askUserForCameraPermission({ permissionGranted in
            if permissionGranted {
                // Permission is granted, so use the imagePreview layer as the camera view.
                self.connectCameraToView()
            } else {
                // Show alerts informing that the user can open Settings to manually
                // allow camera access permission.
                self.showCameraAccessErrorAlert()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Hide the navigation bar for this view. We want the camera to show fullscreen.
        navigationController?.isNavigationBarHidden = true
        
        // Don't forget to resume the camera capture session.
        cameraManager.resumeCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar again before moving to another view.
        navigationController?.isNavigationBarHidden = false
        
        // And stop the camera capture session.
        cameraManager.stopCaptureSession()
    }

    // MARK: - Button Pressed Functions

    @IBAction func shootButtonPressed(_ sender: UIButton) {
        cameraManager.capturePictureWithCompletion({ result in
            switch result {
                case .success(let content):
                    self.doClassification(content)
                
                case .failure:
                    self.showCameraCaptureErrorAlert()
            }
        })
    }

    @IBAction func openDexButtonPressed(_ sender: UIButton) {
        // Navigate to SwiftUI view by setting the rootView of a UIHostingController
        let pokedexView = PokedexView()
        
        // Experimental. Use a collection view layout for the Pokédex. Still error.
        // Uncomment the code below and comment the pokedexView above.
        // let pokedexView = PokedexCollectionView()
        
        let hostVC = UIHostingController(rootView: pokedexView)
        navigationController?.pushViewController(hostVC, animated: true)
    }

    // MARK: - Main Functions

    private func connectCameraToView() {
        if cameraManager.currentCameraStatus() == .ready {
            // Don't want to save the camera picture directly to Photos library
            cameraManager.writeFilesToPhoneLibrary = false
            
            // Add the camera view to imagePreview.
            self.cameraManager.addPreviewLayerToView(self.imagePreview)
            
            // If error occurs, then show some alert.
            cameraManager.showErrorBlock = { (erTitle, erMessage) in
                let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (alertAction) -> Void in  }))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    private func doClassification(_ content: CaptureContent) {
        // Show loading spinner.
        var spinner = Spinner()
        spinner.showSpinner(onView: self.view)

        // Save the captured picture to `image` variable.
        let image = content.asImage;

        // TODO: Pokémon classification
        let classificationModel = PokemonMLModel()
        DispatchQueue.main.async {
            classificationModel.updateClassifications(for: image!)
            print(classificationModel.classificationLabel ?? "NIL")

            spinner.removeSpinner()
        }
    }

    // MARK: - Error Alert Functions

    private func showCameraAccessErrorAlert() {
        let alert = UIAlertController(
            title: "Permission denied",
            message: "Camera access denied. Open Settings to give access to camera.",
            preferredStyle: .alert)

        // This action will open the Settings menu so the user hopefully enable the permission there.
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    self.connectCameraToView()
                })
            }
        }
        alert.addAction(settingsAction)

        // And add the cancel action for the alert
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(cancelAction)

        // Show the alert
        self.present(alert, animated: true)
    }

    private func showCameraCaptureErrorAlert() {
        let alert = UIAlertController(
            title: "Error",
            message: "Camera failure.",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
}
