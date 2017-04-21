//
//  MainScreenViewController.swift
//  RealmRestaurant
//
//  Created by Hyung Jip Moon on 2017-04-18.
//  Copyright © 2017 leomoon. All rights reserved.
//

import Foundation
import UIKit

protocol GoToMainScreenDelegate:class {
    
    func retrieveNotifier(notifier:Int)
    
}

class MainScreenViewController : UITabBarController {
    
    weak var goToMainScreenDelegate:GoToMainScreenDelegate?


    override func viewDidLoad() {
        
        super.viewDidLoad()
        goToMainScreen()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func goToMainScreen()
    {
        self.presentedViewController?.dismiss(animated: true, completion: {
            
            
            self.dismiss(animated: true, completion: nil)
            
            self.goToMainScreenDelegate?.retrieveNotifier(notifier: 1)
            
        })
        
    }
}

