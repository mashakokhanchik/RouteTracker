//
//  MainViewController.swift
//  RouteTracker
//
//  Created by Мария Коханчик on 09.11.2021.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    var onMap: ((String) -> Void)?
    var onSingOut: (() -> Void)?
    var onTakePicture: (() -> Void)?
    
    // MARK: - Actions
    
    @IBAction func showMap(_ sender: Any) {
        onMap?("testing")
    }
    
    @IBAction func singOut(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        onSingOut?()
    }
    
    @IBAction func takePicture(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
}

extension MainViewController: UINavigationControllerDelegate, UIImagePickerController {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let newAvatar = extractImage(from: info) {
            saveAvatar(image: newAvatar)
        }
        picker.dismiss(animated: true)
    }
    
    private func extractImage(from info: [String: Any]) -> UIImage? {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            return image
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            return image
        } else { return nil }
    }
    
}

// MARK: - Upload and save avatar

extension MainViewController {
    
    // MARK: - Methods
    
    func loadAvatar() -> UIImage? {
        do {
            guard let login = UserDefaults.standard.string(forKey: "user"),
                  let user = RealmService.shared.get(User.self, with: login)
            else { return nil }
        } return UIImage(data: User.self)
        
        catch let error as NSError {
            print(error)
            return nil
        }
    }
    
    func saveAvatar(image: UIImage) {
        do {
            guard let login = UserDefaults.standard.string(forKey: "user"),
                  let user = RealmService.shared.save(User.self),
                  let imageData = image else { return }
            
        } return image
        
        catch let error as NSError {
            print(error)
        }
    }
    
}
