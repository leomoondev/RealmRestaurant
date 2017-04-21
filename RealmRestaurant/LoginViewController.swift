//
//  ViewController.swift
//  RealmRestaurant
//
//  Created by Hyung Jip Moon on 2017-04-16.
//  Copyright © 2017 leomoon. All rights reserved.
//

import UIKit
import Realm
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
    
    private var _registering: Bool = false

    /* User default keys for saving form data */
    private static let serverURLKey = "RealmLoginServerURLKey"
    private static let emailKey     = "RealmLoginEmailKey"
    private static let passwordKey  = "RealmLoginPasswordKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addHuman()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     Upon successful login/registration, this callback block will be called,
     providing the user account object that was returned by the server.
     */
    public var loginSuccessfulHandler: ((RLMSyncUser) -> Void)?

    private static let serverURLTEMP = "192.168.1.3"
    /* Login/Register Credentials */
    public var serverURL: String?       { didSet { validateFormItems() } }
    public var serverPort = 9080        { didSet { validateFormItems() } }
    public var username: String?        { didSet { validateFormItems() } }
    public var password: String?        { didSet { validateFormItems() } }
    public var confirmPassword: String? { didSet { validateFormItems() } }
    public var rememberLogin: Bool = true
    
    /**
     Manages whether the view controller is currently logging in an existing user,
     or registering a new user for the first time
     */
    public var isRegistering: Bool {
        set {
            setRegistering(newValue, animated: false)
        }
        get { return _registering }
    }

    func setRegistering(_ registering: Bool, animated: Bool) {
        guard _registering != registering else {
            return
        }
        
        _registering = registering
        
        
        // Insert/Delete the 'confirm password' field
        if _registering {
            
        }
        else {
            
        }
        // Update the accessory views
        setRegistering(_registering, animated: animated)
        
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
        
        performLogin()
    }
    
    @IBAction func goToSignUpButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToSignupVC", sender: self)

    }
  
    public var isSubmitButtonEnabled: Bool = false {
        didSet {
            updateSubmitButton()
        }
    }
    
    private func validateFormItems() {
        var formIsValid = true
        
        if serverURL == nil || (serverURL?.isEmpty)! {
            formIsValid = false
        }
        
        if !(0...65535 ~= serverPort) {
            formIsValid = false
        }
        
        if username == nil || username!.isEmpty {
            formIsValid = false
        }
        
        if password == nil || password!.isEmpty {
            formIsValid = false
        }
        
        if isRegistering && password != confirmPassword {
            formIsValid = false
        }
        
        isSubmitButtonEnabled = formIsValid
    }
    private func performLogin() {
        //footerView.isSubmitting = true
        
        saveLoginCredentials()
        
        var authScheme = "http"
        var scheme: String?
        var formattedURL = LoginViewController.serverURLTEMP
        if let schemeRange = formattedURL.range(of: "://") {
            scheme = formattedURL.substring(to: schemeRange.lowerBound)
            if scheme == "realms" || scheme == "https" {
                serverPort = 9443
                authScheme = "https"
            }
            formattedURL = formattedURL.substring(from: schemeRange.upperBound)
        }
        
        let credentials = RLMSyncCredentials(username: emailTextField.text!, password: passwordTextField.text!, register: isRegistering)
        RLMSyncUser.__logIn(with: credentials, authServerURL: URL(string: "\(authScheme)://\("172.17.53.28"):\(serverPort)")!, timeout: 30, onCompletion: { (user, error) in
            DispatchQueue.main.async {
                //self.footerView.isSubmitting = false
                
                if let error = error {
                    let alertController = UIAlertController(title: "Unable to Sign In", message: error.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                print("111111")
                self.loginSuccessfulHandler?(user!)
                print("222222")
                self.performSegue(withIdentifier: "goToMainFromLogin", sender: self)
                
                
            }
        })
        
        self.presentedViewController?.dismiss(animated: true, completion: {
            
            
            self.dismiss(animated: true, completion: nil)
            
        })
        
    }
    
    private func saveLoginCredentials() {
        let userDefaults = UserDefaults.standard
        
        if rememberLogin {
            userDefaults.set(serverURL, forKey: LoginViewController.serverURLKey)
            userDefaults.set(username, forKey: LoginViewController.emailKey)
            userDefaults.set(password, forKey: LoginViewController.passwordKey)
        }
        else {
            userDefaults.set(nil, forKey: LoginViewController.serverURLKey)
            userDefaults.set(nil, forKey: LoginViewController.emailKey)
            userDefaults.set(nil, forKey: LoginViewController.passwordKey)
        }
        
        userDefaults.synchronize()
    }
    
    private func updateSubmitButton() {
        
        //signupButton.isEnabled = isSubmitButtonEnabled
        
    }

    

}

