//
//  ViewController.swift
//  FlowersExpert
//
//  Created by Gil Marom on 28/07/2022.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var flowerImageView: UIImageView!
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    let classifier = Classifier()
    
    var wikipediaManager = WikipediaManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        wikipediaManager.delegate = self
        
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
                
                wikipediaManager.fetchWikiInfo(flowerName: detectedFlower)
                
                self.navigationItem.title = detectedFlower
                
            }
            
            imagePicker.dismiss(animated: true)
            
        }
        
    }


//MARK: - WikipediaManagerDelegate

extension ViewController: WikipediaManagerDelegate {
    
    func wikiInfoDidUpdate(_ wikipediaManager: WikipediaManager, wikiInfo: WikiModel) {
        
        DispatchQueue.main.async {
            self.summaryLabel.text = wikiInfo.summary
        }
        print(wikiInfo.imageURL)
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }

}
