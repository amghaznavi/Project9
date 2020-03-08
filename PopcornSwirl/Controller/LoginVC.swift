//
//  LoginVC.swift
//  PopcornSwirl
//
//  Created by Am GHAZNAVI on 29/01/2020.
//  Copyright © 2020 Am GHAZNAVI. All rights reserved.
//

import UIKit
import Firebase

class LoginVC : UIViewController {
    
    @IBOutlet weak var EmailView: UIView!
    @IBOutlet weak var PasswordView: UIView!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        EmailView.roundCorner()
        PasswordView.roundCorner()
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = EmailTextField.text, let password = PasswordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                    let alert = UIAlertController(title: "", message: e.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: Constants.cancel, style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    self.performSegue(withIdentifier: Constants.loginSegue, sender: self)
                }
            }
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
