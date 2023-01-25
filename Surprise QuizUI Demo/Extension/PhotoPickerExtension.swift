//
//  PhotoPickerExtension.swift
//  Surprise QuizUI Demo
//
//  Created by Guru Mahan on 21/01/23.
//

import Foundation
 import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable{
  
   // @State var avatarImage: UIImage?
    @Environment (\.presentationMode) var presentationMode
    @State var pickerImage = false
    var sourceTYPE: UIImagePickerController.SourceType = .photoLibrary
    var avatarImage: ((UIImage) -> Void)?
    func makeUIViewController(context: Context) ->  UIImagePickerController {
        let picker = UIImagePickerController()
        
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        picker.sourceType = sourceTYPE
        return picker
    }
   
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(photoPicker: self)
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate,UIImagePickerControllerDelegate{
       
        var photoPicker: PhotoPicker
        
        init(photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }
        
   
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let img = info[.originalImage] as? UIImage{
                guard let data = img.jpegData(compressionQuality: 0.1),
                     let compressedImage = UIImage(data: data) else {
                    return

                }
              //  photoPicker.avatarImage =
                photoPicker.avatarImage?(compressedImage)
            }else{
                
            }
            picker.dismiss(animated: true)
        }
    }
}
