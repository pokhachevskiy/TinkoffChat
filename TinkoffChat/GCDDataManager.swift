//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Даниил on 19/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import UIKit
import Foundation

class GCDDataManager : DataManagerProtocol{
    let queue = DispatchQueue.global(qos: .userInteractive)
    private var fileURL: URL = URL(fileURLWithPath: "")
    
    init(fileURL: URL) {
        queue.async(flags: .barrier) {
            self.fileURL = fileURL
        }
    }
    func saveImageToFile(imageData: Data, completion: @escaping (_ success: Bool) -> ()){
        var success = true;
        queue.async(flags: .barrier) {
            do {
                _ = try imageData.write(to: self.fileURL)
            } catch let error {
                success = false;
                print(error)
            }
            DispatchQueue.main.async {
                completion(success)
            }
        }
        
        
    }
    func loadImageFromFile(completion: @escaping (_ result: Data?) -> ()) {
        var result : Data?
        queue.sync {
            result = try? Data(contentsOf: self.fileURL)
        }
        DispatchQueue.main.async {
            completion(result)
        }
        
    }
}
