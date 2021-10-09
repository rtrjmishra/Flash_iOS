//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Rituraj Mishra on 08/10/2021.
//  Copyright © 2021 Rituraj Mishra. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton)
    {
        if let email = emailTextfield.text , let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email , password: password){ authResult , error in
                if let e = error{
                    print(e.localizedDescription)
                }else{
                    //NAVIGATE TO CHATVC
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }
        
    }
    
}
