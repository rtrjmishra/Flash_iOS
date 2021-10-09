//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Rituraj Mishra on 08/10/2021.
//  Copyright © 2021 Rituraj Mishra. All rights reserved.
//

import UIKit
import CLTypingLabel


class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        titleLabel.text = K.appName
    }
    
    

}
