//
//  Classifier.swift
//  FlowersExpert
//
//  Created by Gil Marom on 29/07/2022.
//

import UIKit
import CoreML
import Vision

class Classifier {
    
    var result: String = ""
    
    func detect(image: CIImage) {
        
        let modelConfiguration = MLModelConfiguration()
        
        guard let model = try? VNCoreMLModel(for: FlowerClassifier(configuration: modelConfiguration).model) else {
            fatalError("Loading CoreML model failed.")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let classification = request.results?.first as? VNClassificationObservation else {
                fatalError("Model failed to process image")
            }
            
            self.result = classification.identifier.capitalized
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
    }
    
}
