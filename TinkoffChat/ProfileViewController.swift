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
        print(editButton.frame) // frame пока не известен, т.к. view на экране еще не появилась
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        print(editButton.frame) editButton явялется nil, т.к. в этом методе еще не подгружены outlet'ы
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
        
        let actionSheetAlertController = UIAlertController(title: "Выбор изображения", message:
            "Выберите существующее изображение из галереи или сделайте новое", preferredStyle: .actionSheet )
        
        actionSheetAlertController.addAction(UIAlertAction(title: "Камера", style: .default, handler: { [weak self] _ in
            // handling camera option
            if let strongSelf = self {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    imagePickerController.delegate = strongSelf
                    imagePickerController.sourceType = .camera
                    strongSelf.present(imagePickerController, animated: true, completion: nil)
                } else {
                    println(string: "Camera is not available")
                }
            }
        }))
        
        actionSheetAlertController.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { [weak self] _ in
            // handling select from gallery option
            if let strongSelf = self {
                imagePickerController.delegate = strongSelf
                imagePickerController.sourceType = .photoLibrary
                strongSelf.present(imagePickerController, animated: true, completion: nil)
            }
        }))
        
        actionSheetAlertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        self.present(actionSheetAlertController, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            userImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        println(string: "\(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        println(string: "\(#function)")
        print(editButton.frame) // frame уже известен, т.к. view уже появилась на экране
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

