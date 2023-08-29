//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Anshul parashar on 27/07/23.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		titleLabel.text = Constants.appName
    }
}
