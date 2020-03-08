//
//  RegisterVC.swift
//  PopcornSwirl
//
//  Created by Am GHAZNAVI on 29/01/2020.
//  Copyright © 2020 Am GHAZNAVI. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC : UIViewController {
    
    @IBOutlet weak var EmailView: UIView!
    @IBOutlet weak var PasswordView: UIView!
    @IBOutlet weak var EmailTextfield: UITextField!
    @IBOutlet weak var PasswordTextfield: UITextField!
    @IBOutlet weak var CancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        EmailView.roundCorner()
        PasswordView.roundCorner()
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = EmailTextfield.text, let password = PasswordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                    let alert = UIAlertController(title: "", message: e.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: Constants.cancel, style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    self.performSegue(withIdentifier: Constants.registerSegue, sender: self)
                }
            }
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

}

