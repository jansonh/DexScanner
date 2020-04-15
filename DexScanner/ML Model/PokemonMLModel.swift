//
//  MLModel.swift
//  DexScanner
//
//  Created by Janson Hendryli on 15/04/20.
//  Copyright © 2020 Janson Hendryli. All rights reserved.
//

import UIKit
import CoreML
import Vision
import ImageIO

class PokemonMLModel {
    internal var classificationLabel: String?

    private lazy var classificationRequest: VNCoreMLRequest = {
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
            fatalError("Cannot load ML model.")
        }

        let request = VNCoreMLRequest(model: model) { [weak self] (request, error) in
            self?.processClassification(for: request, error: error)
        }
        request.imageCropAndScaleOption = .centerCrop

        return request
    }()

    private func processClassification(for request: VNRequest, error: Error?) {
        guard let results = request.results else {
            self.classificationLabel = "Unable to classify image.\n\(error!.localizedDescription)"
            return
        }

        // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
        let classifications = results as! [VNClassificationObservation]

        if classifications.isEmpty {
            self.classificationLabel = "Nothing recognized."
        } else {
            // Display top classifications ranked by confidence in the UI.
            let topClassifications = classifications.prefix(2)

            let descriptions = topClassifications.map { classification in
                // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
            }

            self.classificationLabel = "Classification:\n" + descriptions.joined(separator: "\n")
        }
    }

    internal func updateClassifications(for image: UIImage) {
        self.classificationLabel = nil

        guard let ciImage = CIImage(image: image) else {
            fatalError("Unable to create \(CIImage.self) from \(image).")
        }

        let handler = VNImageRequestHandler(ciImage: ciImage)

        do {
            try handler.perform([self.classificationRequest])
        } catch {
            /*
             This handler catches general image processing errors. The `classificationRequest`'s
             completion handler `processClassifications(_:error:)` catches errors specific
             to processing that request.
             */
            fatalError("Failed to perform classification.\n\(error.localizedDescription)")
        }
    }
}
