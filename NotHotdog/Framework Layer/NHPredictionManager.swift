//
//  NHPredictionManager.swift
//  NotHotdog
//
//  Created by Oded Golden on 20/10/2017.
//  Copyright © 2017 Oded Golden. All rights reserved.
//

import UIKit
import CoreML
import Vision

class NHPredictionManager: NSObject {
    
    let vowels: [Character] = ["a", "e", "i", "o", "u"]

    func predictImage(image: CIImage, completion : @escaping (String) -> ())
    {
        // Load the ML model through its generated class
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {
            fatalError("can't load Resnet50 ML model")
        }
        
        // Create a Vision request with completion handler
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first else {
                    fatalError("unexpected result type from VNCoreMLRequest")
            }
            
            // Update UI on main queue
            let article = (self?.vowels.contains(topResult.identifier.first!))! ? "an" : "a"
            let labelString = "\(Int(topResult.confidence * 100))% it's \(article) \(topResult.identifier)"
            completion(labelString)
        }
        // Run the Core ML Resnet50 classifier on global dispatch queue
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }

}
