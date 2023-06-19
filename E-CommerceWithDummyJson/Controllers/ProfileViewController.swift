//
//  ProfileViewController.swift
//  E-CommerceWithDummyJson
//
//  Created by rafiul hasan on 9/6/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: outlets
    @IBOutlet weak var takenImageView: UIImageView!
    @IBOutlet weak var cameraButtonView: UIButton!
    
    //MARK: variables
    let imagePicker = UIImagePickerController()
    var isCameraAvailable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        takenImageView.layer.cornerRadius = takenImageView.frame.width / 2
        // Do any additional setup after loading the view.
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            isCameraAvailable = true
        }
    }

    @IBAction func openCameraButton(sender: AnyObject) {
        popup()
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func popup() {
        let alertController = UIAlertController(title: "Select Source", message: "Would you like to use your camera or your photo library?", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true)
        }
        
        let library = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = false
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { _ in
            self.dismiss(animated: true)
        }
        
        if isCameraAvailable == true {
            alertController.addAction(camera)
        }
        alertController.addAction(library)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            takenImageView.contentMode = .scaleAspectFill
            takenImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
