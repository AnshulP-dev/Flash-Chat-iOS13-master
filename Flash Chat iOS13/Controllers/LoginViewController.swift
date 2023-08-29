//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Anshul parashar on 27/07/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
	@IBAction func loginPressed(_ sender: UIButton) {
		if let email = emailTextfield.text, let password = passwordTextfield.text {
			Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
				guard let strongSelf = self else { return }
				if let error = error {
					print(error.localizedDescription)
				} else {
					strongSelf.performSegue(withIdentifier: Constants.loginSegue, sender: strongSelf)
				}
			}
		}
	}
    
}
