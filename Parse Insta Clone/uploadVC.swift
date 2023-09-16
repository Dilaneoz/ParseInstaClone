//
//  SecondViewController.swift
//  Parse Insta Clone
//
//  Created by Atil Samancioglu on 25.09.2018.
//  Copyright © 2018 Atil Samancioglu. All rights reserved.
//

import UIKit
import Parse
// infoplist e ekleme yapılacak
class uploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keyboardRecognizer = UITapGestureRecognizer(target: self, action:#selector(uploadVC.hideKeyboard))
        self.view.addGestureRecognizer(keyboardRecognizer)

        postImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(uploadVC.choosePhoto))
        postImage.addGestureRecognizer(gestureRecognizer)
        
        postButton.isEnabled = false // başta postButton tıklanmaz olsun. sonra resim seçilene kadar diye yazıcaz

    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true) // kullanıcı uygulamayı kullanırken dışarıda bi yere dokunduğunda klavye kapanacak
    }
    
    
    @objc func choosePhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        postImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        postButton.isEnabled = true // resim seçildikten sonra postButton tıklanabilir olsun
        
    }

    @IBAction func postClicked(_ sender: Any) {
        postButton.isEnabled = false // postButton a tıklandıktan sonra postButton yine görünmez/tıklanamaz olsun
        
        let object = PFObject(className: "Posts")
        
        let data = postImage.image?.jpegData(compressionQuality: 0.5)
        let pfImage = PFFile(name: "image", data: data!)
        
        let uuid = UUID().uuidString // her postun kendi id si olucak
        let uuidpost = "\(uuid) \(PFUser.current()!.username!)"
        
        object["postimage"] = pfImage // görseller parse a kaydedilecek hale geldi
        object["postcomment"] = commentText.text
        object["postowner"] = PFUser.current()!.username!
        object["postuuid"] = uuidpost
        
        object.saveInBackground { (success, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                
                self.commentText.text = ""
                self.postImage.image = UIImage(named: "image.png")
                self.tabBarController?.selectedIndex = 0
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newPost"), object: nil) // feedVC a yeni bi resim eklendiğini söylememiz gerekiyor. bunun için NotificationCenter ı kullanırız. bu da bize bi isim ile bildirim yollamamıza izin verir. o bildirimi de gelip feedVC içinde dinleyebiliyoruz. böylece buradan feedVC a mesaj yollayabiliyoruz
                
            }
        }
        
    }
    
}

