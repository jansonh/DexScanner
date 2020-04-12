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
    
    var image: UIImage?
    var vSpinner : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask user permission to use camera. If the permission is not granted,
        // the app cannot take picture from camera, but the offline Pokédex should
        // still work perfectly.
        cameraManager.askUserForCameraPermission({ permissionGranted in
            if permissionGranted {
                // Permission is granted, so use the imagePreview layer as the camera view.
                self.connectCameraToView()
            } else {
                // Show alerts informing that the user can open Settings to manually
                // allow camera access permission.
                let alert = UIAlertController(
                    title: "Permission denied",
                    message: "Camera access denied. Manually change the permission from your Settings.",
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

    @IBAction func shootButtonPressed(_ sender: UIButton) {
        cameraManager.capturePictureWithCompletion({ result in
            switch result {
                case .success(let content):
                    // Save the captured picture to `image` variable.
                    self.image = content.asImage;
                    
                    // Show loading spinner.
                    self.showSpinner(onView: self.view)
                    
                    // TODO: Pokémon classification
                    
                    // TODO: Delete this for deployment
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                        self.removeSpinner()
                    }
                
                case .failure:
                    // Something fails. Show the error alert.
                    let alert = UIAlertController(
                        title: "Error",
                        message: "Camera manager failure occurs. The app cannot capture the picture.",
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
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
    
    func connectCameraToView() {
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
    
    // Show spinner when processing the image!
    func showSpinner(onView: UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    // When processing is done, remove the spinner.
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}

