//
//  ViewController.swift
//  FlowersExpert
//
//  Created by Gil Marom on 28/07/2022.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var flowerImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    let classifier = Classifier()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }

}

//MARK: - UIImagePickerControllerDelegate
    
    extension ViewController: UIImagePickerControllerDelegate {
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let userPickedImage = info[.originalImage] as? UIImage {
                flowerImageView.image = userPickedImage
                
                guard let convertedCIImage = CIImage(image: userPickedImage) else {
                    fatalError("Could not convert UIImage into CIImage")
                }
                
                classifier.detect(image: convertedCIImage)
                
                let detectedFlower = classifier.result
                
                self.navigationItem.title = detectedFlower
                
            }
            
            imagePicker.dismiss(animated: true)
            
        }
        
    }
