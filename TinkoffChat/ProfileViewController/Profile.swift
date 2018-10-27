//
//  Profile.swift
//  TinkoffChat
//
//  Created by Daniil on 21/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

class Profile {
    
    var name: String?
    var info: String?
    var image: UIImage?
    
    var nameChanged: Bool = false
    var infoChanged: Bool = false
    var imageChanged: Bool = false
    
    init() {}
    
    init(name: String?, info: String?, image: UIImage?) {
        self.name = name
        self.info = info
        self.image = image
    }
    
}



class ProfileHandler {
    
    private let nameFileName = "name"
    private let infoFileName = "info"
    private let imageFileName = "userImage.jpg"
    
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    func saveData(profile: Profile) -> Bool {
        do {
            if profile.nameChanged, let unwrappedName = profile.name {
                UserDefaults.standard.setValue(unwrappedName, forKey: self.nameFileName)
            }
            
            if profile.infoChanged, let unwrappedinfo = profile.info {
                UserDefaults.standard.setValue(unwrappedinfo, forKey: self.infoFileName)
            }
            
            if profile.imageChanged, let unwrappedImage = profile.image {
                let imageData = unwrappedImage.jpegData(compressionQuality: 100);
                try imageData?.write(to: filePath.appendingPathComponent(self.imageFileName), options: .atomic);
            }
            return true
        } catch {
            return false
        }
    }
    
    
    func loadData() -> Profile? {
        let profile: Profile = Profile()
        profile.name = UserDefaults.standard.string(forKey: self.nameFileName)
        profile.info = UserDefaults.standard.string(forKey: self.infoFileName)
        profile.image = UIImage(contentsOfFile: filePath.appendingPathComponent(self.imageFileName).path)
        return profile
    }
    
}



