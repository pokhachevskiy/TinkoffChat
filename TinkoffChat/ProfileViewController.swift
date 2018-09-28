//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Даниил on 21.09.2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var addPictureButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(string: "\(#function)")
        
    }
    
    private func layerStyleInstall() {
        let spacing = CGFloat(10)
        
        self.addPictureButton.imageEdgeInsets = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        self.addPictureButton.layer.cornerRadius = self.addPictureButton.frame.size.height/2.0
        
        self.userImage.layer.masksToBounds = true
        self.userImage.layer.cornerRadius = self.addPictureButton.layer.cornerRadius
        
        self.editButton.layer.cornerRadius = self.editButton.frame.size.height/3.0
        self.editButton.layer.borderWidth = CGFloat(1)
        self.editButton.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func addPictureButtonPressed(_ sender: UIButton) {
        println(string: "Выбери изображение профиля")
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        
        let actionSheetAlertController = UIAlertController(title: "Выбор изображения", message:
            "Выберите существующее изображение из галереи или сделайте новое", preferredStyle: .actionSheet )
        
        actionSheetAlertController.addAction(UIAlertAction(title: "Камера", style: .default, handler: { (action: UIAlertAction) in
            // handling camera option
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                println(string: "Camera is not available")
            }
        }))
        
        actionSheetAlertController.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { (action: UIAlertAction) in
            // handling select from gallery option
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheetAlertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        self.present(actionSheetAlertController, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        self.userImage.image = image
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        println(string: "\(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        println(string: "\(#function)")
        self.layerStyleInstall()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        println(string: "\(#function)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        println(string: "\(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        println(string: "\(#function)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        println(string: "\(#function)")
    }
    


}

