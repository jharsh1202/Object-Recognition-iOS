//
//  ViewController.swift
//  ObjectRecognitionXC12
//
//  Created by Harshit Jain on 17/06/21.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage]
        if let pickedImage  = image as? UIImage {
            imageView.image = pickedImage
            guard let ciimage = CIImage(image: pickedImage) else {
                fatalError("Couldn't Convert to CIImage")
            }
            detect(ciimage: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func detect(ciimage: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3(configuration: .init()).model) else {
            fatalError(" error: loading coreML model failed")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("request failed CoreML")
            }
            print(results)
        }
        let handler = VNImageRequestHandler(ciImage: ciimage)
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }


}

