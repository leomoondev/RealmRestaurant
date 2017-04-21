//
//  SignupViewController.swift
//  RealmRestaurant
//
//  Created by Hyung Jip Moon on 2017-04-16.
//  Copyright © 2017 leomoon. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GoToMainScreenDelegate {
    

    
    /* User default keys for saving form data */
    private static let serverURLKey = "RealmLoginServerURLKey"
    private static let emailKey     = "RealmLoginEmailKey"
    private static let passwordKey  = "RealmLoginPasswordKey"
    /* State tracking */
    private var _registering: Bool = false

    private static let serverURLTEMP = "192.168.1.3"
    /* Login/Register Credentials */
    public var serverURL: String?       { didSet { validateFormItems() } }
    public var serverPort = 9080        { didSet { validateFormItems() } }
    public var username: String?        { didSet { validateFormItems() } }
    public var password: String?        { didSet { validateFormItems() } }
    public var confirmPassword: String? { didSet { validateFormItems() } }
    public var rememberLogin: Bool = true
    
    let picker = UIImagePickerController()
    @IBOutlet weak var myImageView: UIImageView!

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        picker.delegate = self

        setUpCommonViews()

    }
    
    func retrieveNotifier(notifier: Int) {
        
        if notifier == 1 {
            
            performSegue(withIdentifier: "goToMainScreen", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
    
    /**
     Upon successful login/registration, this callback block will be called,
     providing the user account object that was returned by the server.
     */
    public var loginSuccessfulHandler: ((RLMSyncUser) -> Void)?
    
    /**
     For cases where apps will be connecting to a pre-established server URL,
     this option can be used to hide the 'server address' field
     */
    public var isServerURLFieldHidden: Bool = false {
        didSet {
            //tableView.reloadData()
        }
    }
    
    @IBAction func addProfilePhoto(_ sender: Any) {
        
        picker.allowsEditing = false
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: nil)
    
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // use the image
        myImageView.contentMode = .scaleAspectFit //3
        myImageView.image = chosenImage //4
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        self.setRegistering(!self.isRegistering, animated: true)
        self.submitLogin()
    
    }
    
    public var isSubmitButtonEnabled: Bool = false {
        didSet {
            updateSubmitButton()
        }
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

    
    private func setUpCommonViews() {

        setUpTableView()
        
    }
    
    private func setUpTableView() {

        let infoDictionary = Bundle.main.infoDictionary!
        if let displayName = infoDictionary["CFBundleDisplayName"] {
            //headerView.appName = displayName as? String
        }
        else if let displayName = infoDictionary[kCFBundleNameKey as String] {
            //headerView.appName = displayName as? String
        }

    }
    
    //MARK: - Form Submission
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
    
    
    private func submitLogin() {
        //footerView.isSubmitting = true
        
        saveLoginCredentials()
        
        var authScheme = "http"
        var scheme: String?
        var formattedURL = SignupViewController.serverURLTEMP
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
                self.performSegue(withIdentifier: "goToMainScreen", sender: self)

                
            }
        })
        
        self.presentedViewController?.dismiss(animated: true, completion: {
            
            
            self.dismiss(animated: true, completion: nil)
            
        })

    }
    
    private func saveLoginCredentials() {
        let userDefaults = UserDefaults.standard
        
        if rememberLogin {
            userDefaults.set(serverURL, forKey: SignupViewController.serverURLKey)
            userDefaults.set(username, forKey: SignupViewController.emailKey)
            userDefaults.set(password, forKey: SignupViewController.passwordKey)
        }
        else {
            userDefaults.set(nil, forKey: SignupViewController.serverURLKey)
            userDefaults.set(nil, forKey: SignupViewController.emailKey)
            userDefaults.set(nil, forKey: SignupViewController.passwordKey)
        }
        
        userDefaults.synchronize()
    }
    
    private func updateSubmitButton() {
        
        signupButton.isEnabled = isSubmitButtonEnabled
        
    }


}
