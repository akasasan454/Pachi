//
//  FirstViewController.swift
//  Pachi
//
//  Created by アイスタンダード on 2018/06/01.
//  Copyright © 2018年 Takafumi Ogaito. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FirstViewController: UIViewController{

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
        password.isSecureTextEntry = true
    }
    
    @IBAction func signUpButton() {
        guard let email = email.text else { return }
        guard let password = password.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error == nil{
                Auth.auth().currentUser?.sendEmailVerification { (error) in
                    if error == nil {
                        self.dismiss(animated: true)
                    }else {
                        self.aleat(title: "エラー", message: "このメールアドレスは既に使われています",btn: "OK")
                    }
                }
          }
          else{
            self.aleat(title: "エラー", message: "エラーです",btn: "OK")
          }
        }
    }
    
    @IBAction func loginButton() {
        guard let email = email.text else { return }
        guard let password = password.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil{
               let tbc = self.storyboard?.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
               self.present(tbc, animated: true)
            }
            else{
                self.aleat(title: "ログインエラー", message: "メールアドレスまたはパスワードが間違っています",btn: "OK")
            }
        }
    }
  
    func aleat(title:String,message:String,btn:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let button = UIAlertAction(title: btn, style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(button)
        present(alert, animated: true)
    }

}

extension FirstViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
