//
//  FirstViewController.swift
//  Parse Insta Clone
//
//  Created by Atil Samancioglu on 25.09.2018.
//  Copyright © 2018 Atil Samancioglu. All rights reserved.
//

import UIKit
import Parse

// daha önce yaptığımız insta clone uygulamasının üzerine yazıyoruz burada. tek fark firebase ile değil parse ile yapıcaz

// parse aslında eskiden firebase gibi facebook tarafından işletilen bir projeydi. yine bunun içinde server satması, backand kodlarının kullanılması ve devamlı geliştirilmesi gibi hizmetler vardı aynı şuan firebase de olduğu gibi. fakat bu proje kapandı ve parse tamamen açık kaynak olarak bize sunuldu. o yüzden parse ın bütün kodlarını istediğimiz gibi kullanabiliriz

// burada önceki projeden farklı olarak parse bizim için bi server/sunucu sağlamayacak. biz kendimiz bi sunucu bulucaz ve ona kaydolucaz

// hoca parse entegrasyonunu videolarda anlatıyor

// internette datalarımızı kaydedip ordan çekebileceğimiz bir sunucuya ihtiyacımız var. parse ta firebase deki gibi hazır bi sunucumuz yok o yüzden kendimiz bulmamız lazım. bikaç seçenek var. parse open source olunca birçok şirket parse ile ilgili kodları kendi sunucularına entegre edip parse server ı hizmeti vermeye başladı. hoca bu bölümde daha kolay olduğu için back4app i gösteriyor. bi sonraki push notification projesinde amazon u kullanıcak

// appdelegate ta sunucuya bağlanmak için gerekli olan değişiklikler yapılıyor

class feedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var postOwnerArray = [String]()
    var postCommentArray = [String]()
    var postUUIDArray = [String]()
    var postImageArray = [PFFile]() // direkt dosyayı çekicez

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(feedVC.getData), name: NSNotification.Name("newPost"), object: nil) // uploadVC daki mesaj buraya yollandı. parse tan dataları çek diyoruz
    }
   
    
    @objc func getData() { // verileri indiricez
        
        let query = PFQuery(className: "Posts")
        query.addDescendingOrder("createdAt") // parse ta verileri createdAt e(tarih) göre sıraladık böylece uygulamada da verileri tarihe göre sıralayacak. artık en son eklenen en başta gözüküyor
        
        query.findObjectsInBackground { (objects, error) in // findObjectsInBackground objects i bu şekilde alıyoruz
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else { // aynı verileri birden fazla kez görüyorsak array leri temizlemediğimiz anlamına gelir. for loop a girmeden bunları temizlersek böyle bi sorun kalmaz
                self.postOwnerArray.removeAll(keepingCapacity: false)
                self.postImageArray.removeAll(keepingCapacity: false)
                self.postUUIDArray.removeAll(keepingCapacity: false)
                self.postCommentArray.removeAll(keepingCapacity: false)
                
                // bu objeleri bi loop a sokmamız lazım ki loop tan çıkartıp tek tek objelerin hepsini array lerin içine koyalım
                if objects!.count > 0 { // objelerin içinde bişi geldiyse
                    for object in objects! {
                        self.postOwnerArray.append(object.object(forKey: "postowner") as! String)
                        self.postCommentArray.append(object.object(forKey: "postcomment") as! String)
                        self.postUUIDArray.append(object.object(forKey: "postuuid") as! String)
                        self.postImageArray.append(object.object(forKey: "postimage") as! PFFile)
                    }
                }
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postOwnerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! feedCell
        
        cell.userNameLabel.text = postOwnerArray[indexPath.row]
        cell.postCommentText.text = postCommentArray[indexPath.row]
        cell.postUUIDLabel.text = postUUIDArray[indexPath.row]
        
        postImageArray[indexPath.row].getDataInBackground { (data, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                cell.postImage.image = UIImage(data: data!)
            }
        }
        
        
        return cell
    }


    @IBAction func logOutClicked(_ sender: Any) {
        PFUser.logOutInBackground { (error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                UserDefaults.standard.removeObject(forKey: "username") // artık tabBarController başlangıç sayfası olmayacak
                UserDefaults.standard.synchronize()
                
                let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signIn") as! signInVC
                
                let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                
                delegate.window?.rootViewController = signIn
                
                delegate.rememberUser()
                
            }
        }
        
    }
}

