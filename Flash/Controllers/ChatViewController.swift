//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Rituraj Mishra on 08/10/2021.
//  Copyright © 2021 Rituraj Mishra. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        navigationItem.hidesBackButton = true
        loadMessages()
    }
    
    
    func loadMessages(){
        
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener{ (querySnapshot, error) in
            self.messages = []
            if let e = error{
                print("Issue in loading messages: %@",e)
            }else{
                if let docs = querySnapshot?.documents{
                    for d in docs{
                      let data = d.data()
                        if let msender = data[K.FStore.senderField] as? String, let mbody = data[K.FStore.bodyField] as? String{
                            let newMessage = Message(sender: msender, body: mbody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton)
    {
        if let messageBody = messageTextfield.text ,let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error{
                    print("Issue in saving data firestore:%@",e)
                }else{
                    DispatchQueue.main.async {
                    self.messageTextfield.text = ""
                    }
                }
            }
        }
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem)
    {
        do{
            try
                Auth.auth().signOut()
            navigationController?.popToRootViewController( animated: true)
            }catch let signOutError as NSError{
                print("Error signing out: %@",signOutError)
            }
        }
}

extension ChatViewController: UITableViewDataSource //Responsible for populating table view
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier,for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        //Message from current user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        //Message from other user
        else{
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
}
