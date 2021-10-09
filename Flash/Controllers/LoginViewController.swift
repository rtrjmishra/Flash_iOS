//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Rituraj Mishra on 08/10/2021.
//  Copyright © 2021 Rituraj Mishra. All rights reserved.
//
//111@2.com

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    

    @IBAction func loginPressed(_ sender: UIButton)
    {
        if let email = emailTextfield.text , let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email , password: password){ authResult , error in
                if let e = error{
                    print(e)
                }else{
                    //NAVIGATE TO CHATVC
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
    }
    
}
