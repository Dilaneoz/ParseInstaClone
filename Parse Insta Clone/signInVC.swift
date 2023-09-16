//
//  signInVC.swift
//  Parse Insta Clone
//
//  Created by Atil Samancioglu on 25.09.2018.
//  Copyright © 2018 Atil Samancioglu. All rights reserved.
//

import UIKit
import Parse

class signInVC: UIViewController {

    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        let parseObject = PFObject(className: "Fruits") // back4app te bir fruits class ı oluşturduk
        parseObject["name"] = "Banana" // fruits in altında name objesi var
        parseObject["calories"] = 150 // ve calories objesi. tarihler otomatik oluşturuluyor
        parseObject.saveInBackground { (success, error) in // saveEventually dersek offline moddayken bile, internet gelince kaydetmeye çalışır. saveInBackground dersek uygulama arka planında diğer işlemleri meşgul etmeden yapıyor ve bize hemen sonucu veriyor, yani kaydettim ya da kaydedemedim diyor. biz de bu sonucu alıp kullanıcıya gösterebiliriz
            if error != nil {
                print(error?.localizedDescription)
            } else {
                print("saved")
            }
        }
 
        // yukarıda parseObject oluşturup bunu aldığımız gibi, PFQuery oluşturup yukarıda kaydettiklerimizi geri çağırabiliyoruz
        let query = PFQuery(className: "Fruits") // Fruits sınıfını çek
        //query.whereKey("calories", greaterThan: 120) // kalorisi 120den fazla olanları çek
        query.whereKey("name", equalTo: "Apple") // adı apple olanları çek
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                print(objects)
            }
        }
        */
        
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        
        if userNameText.text != "" && passwordText.text != "" {
            
            PFUser.logInWithUsername(inBackground: userNameText.text!, password: passwordText.text!) { (user, error) in
                
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                } else {
                
                    //remember user function
                    UserDefaults.standard.set(self.userNameText.text!, forKey: "username")
                    UserDefaults.standard.synchronize()
                    
                    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberUser()
                
                }
                
            }
           
            
        } else {
            let alert = UIAlertController(title: "Error", message: "username/password needed", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
        }

    }
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if userNameText.text != "" && passwordText.text != "" { // kullanıcı textfield ı boş bırakmadıysa
            
            let user = PFUser() // kullanıcıyı oluşturduk
            user.username = userNameText.text! // bu değerleri alarak kullanıcımızı oluşturucaz
            user.password = passwordText.text!
            
            user.signUpInBackground { (success, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    
                    //remember user function
                    UserDefaults.standard.set(self.userNameText.text!, forKey: "username") //  username i UserDefaults a kaydettik. buradan sonra appDelegate ta UserDefaults ta username diye bişi kaydedilmiş mi kontrol edicez. bunu kullanıcı oluşturulduysa onu ikinci sayfadan başlatmak için yapıyoruz. eğer kaydedildiyse kullanıcı giriş yapmış demektir. sonra logout fonksiyonu yazıp bu değeri sileriz
                    UserDefaults.standard.synchronize()
                    
                    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberUser()
                    
                }
            }
        
        } else {
            let alert = UIAlertController(title: "Error", message: "username/password needed", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
        }
        
        
        
        
        
    }
    
}
