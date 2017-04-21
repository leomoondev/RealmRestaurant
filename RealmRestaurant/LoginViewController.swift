//
//  ViewController.swift
//  RealmRestaurant
//
//  Created by Hyung Jip Moon on 2017-04-16.
//  Copyright © 2017 leomoon. All rights reserved.
//

import UIKit
import RealmSwift
//import Foundation
//
//    #if os(OSX)
//    let syncHost = "127.0.0.1"
//    #else
//    let syncHost = localIPAddress
//    #endif
//    
//    let syncRealmPath = "realmtasks"
//    let defaultListName = "My Tasks"
//    let defaultListID = "80EB1620-165B-4600-A1B1-D97032FDD9A0"
//    
//    let syncServerURL = URL(string: "realm://\(syncHost):9080/~/\(syncRealmPath)")
//    let syncAuthURL = URL(string: "http://\(syncHost):9080")!
//    
//    let appID = Bundle.main.bundleIdentifier!


class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addHuman()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func addHuman() {
        let mike = Human()
        mike.name = "Mike"
        mike.age = 13
        mike.race = "Indian"
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(mike)
            print("Added \(mike.name) to Realm")
        }
    }
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        
    }
    
    @IBAction func goToSignUpButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToSignupVC", sender: self)

    }
  
    
    
    //    func doAuth() {
//        
//        //Create Account
//        let signUpCredentials = SyncCredentials.usernamePassword(username: "username", password: "password", register: true)
//        
//        SyncUser.logIn(with: signUpCredentials, server: serverURL) { user, error in
//            if user == nil {
//                //Error
//            }else{
//                //Success
//            }
//        }
//        
//        //Log in
//        let logInCredentials = SyncCredentials.usernamePassword(username: "username", password: "password")
//        
//        SyncUser.logIn(with: logInCredentials, server: serverURL) { user, error in
//            if user == nil {
//                //Error
//            }else{
//                //Success
//            }
//        }
//        
//    }
}

