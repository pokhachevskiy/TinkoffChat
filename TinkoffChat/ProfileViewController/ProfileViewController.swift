//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Даниил on 21.09.2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import UIKit
class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var coreDataButton: UIButton!
    @IBOutlet weak var addPictureButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var operationButton: UIButton!
    @IBOutlet weak var gcdButton: UIButton!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var editingMode: Bool = false {
        didSet{
            self.setEditingState(editing: editingMode)
        }
    }
    
    private var profile: Profile?
    private var saveChanges: ( () -> Void )?
    
    var dataManager: DataManagerProtocol? = CoreDataManager()
    
    private var dataWasChanged: Bool {
        get{
            return self.profile?.nameChanged ?? false || self.profile?.infoChanged ?? false || self.profile?.imageChanged ?? false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editingMode = false
        self.loadFromFile()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.view.frame.origin.y = -keyboardHeight + 66
            print("keyboard height is:" , keyboardHeight)
        }
    }
    
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    
    
    private func setEnabledState(enabled: Bool) {
        self.gcdButton.isEnabled = enabled
        self.coreDataButton.isEnabled = enabled
        self.operationButton.isEnabled = enabled
    }
    
    
    @IBAction func editButtonPressed(_ sender: Any) {
        self.editingMode = true
        self.setEnabledState(enabled: false)
    }
    @IBAction func tapDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func loadFromFile() {
        self.dataManager?.loadData(completion: { (profile) in
            if let unwrappedProfile = profile {
                self.profile = unwrappedProfile
            }
            
            self.userImage.image = profile?.image ?? UIImage.init(named: "placeholder-user")
            self.nameLabel.text = profile?.name ?? "Введите имя"
            self.infoLabel.text = profile?.info ?? "Расскажите о себе"
            
            
            self.profile = Profile(name: self.nameLabel.text, info: self.infoLabel.text, image: self.userImage.image)
            
        })
    }
    
    private func setEditingState(editing: Bool) {
        if(editing) {
            self.nameTextField.text = profile?.name ?? nameLabel.text ?? "Введите имя"
            self.infoTextField.text = profile?.info ?? infoLabel.text ?? "Расскажите о себе"
        }
        self.addPictureButton.isHidden = !editing
        
        self.editButton.isHidden = editing
        self.gcdButton.isHidden = !editing
        self.operationButton.isHidden = !editing
        self.coreDataButton.isHidden = !editing
        
        self.nameLabel.isHidden = editing
        self.nameTextField.isHidden = !editing
        
        self.infoTextField.isHidden = !editing
        self.infoLabel.isHidden = editing
        
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
        
        self.activityIndicator.hidesWhenStopped = true
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    private func showSuccessAlert() {
        let alertController = UIAlertController(title: "Changes saved!", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showErrorAlert() {
        let alertController = UIAlertController(title: "Error", message: "could not save data", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Retry", style: .default) { action in
            self.saveChanges?();
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.userImage.image = image
            
            if let savedImage = self.profile?.image {
                let newImage = image.jpegData(compressionQuality: 100)!
                let oldImage = savedImage.jpegData(compressionQuality: 100)!
                self.profile?.imageChanged = !newImage.elementsEqual(oldImage)
            } else {
                self.profile?.imageChanged = true
            }
            
            self.setEnabledState(enabled: self.dataWasChanged)
        } else {
            print("Error picking image")
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func textFieldEdited(_ sender: UITextField) {
        switch sender {
        case nameTextField:
            print("name changed ")
            if let newName = sender.text {
                self.profile?.nameChanged = (newName != (self.profile?.name ?? ""))
                self.setEnabledState(enabled: self.dataWasChanged)
            }
        case infoTextField:
            print("info changed ")
            if let newInfo = sender.text {
                self.profile?.infoChanged = (newInfo != (self.profile?.info ?? ""))
                self.setEnabledState(enabled: self.dataWasChanged)
            }
        default:
            print("default")
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        self.nameTextField.resignFirstResponder()
        self.infoTextField.resignFirstResponder()
        
        self.saveChanges = {
            
            self.activityIndicator.startAnimating()
            self.setEnabledState(enabled: false)
            
            self.profile?.name = self.nameTextField.text
            self.profile?.info = self.infoTextField.text
            self.profile?.image = self.userImage.image
            
            let titleOfButton = sender.titleLabel?.text
            
            if titleOfButton == "Operation" {
                self.dataManager = OperationDataManager()
            } else if titleOfButton == "GCD "{
                self.dataManager = GCDDataManager()
            } else {
                self.dataManager = CoreDataManager()
            }
            
            
            self.dataManager?.saveData(profile: self.profile!, completion: { (saveSucceeded : Bool) in
                
                self.activityIndicator.stopAnimating()
                
                if saveSucceeded {
                    self.showSuccessAlert()
                    self.loadFromFile()
                } else {
                    self.showErrorAlert()
                }
                
                self.setEnabledState(enabled: true)
                self.editingMode = !saveSucceeded
            })
        }
        
        self.saveChanges?();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layerStyleInstall()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    


}

