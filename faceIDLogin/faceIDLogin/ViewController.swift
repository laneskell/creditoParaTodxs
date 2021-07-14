//
//  ViewController.swift
//  faceIDLogin
//
//  Created by Kell Lanes on 07/07/21.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var emailTextFields: UITextField!
    @IBOutlet weak var passwordTextFields: UITextField!
    
    var userdefaults = UserDefaults.standard
    var context = LAContext()
    var err : NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (userdefaults.value(forKey: "email") != nil) &&
            (userdefaults.value(forKey: "pwd") != nil) {
            btnLoginWhitFaceIdExit.isHidden = false
        } else {
            btnLoginWhitFaceIdExit.isHidden = true
        }
        // Do any additional setup after loading the view.
    }

    
    @IBAction func btnLoginTapped(_ sender: Any) {
        if !(emailTextFields.text!.isEmpty) && !(passwordTextFields.text!.isEmpty) {
            userdefaults.set(emailTextFields, forKey: "email")
            userdefaults.set(emailTextFields, forKey: "pwd")
            let vc =  storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            self.present(vc, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func btnLoginWithFaceId(_ sender: Any) {
        let localString = "Autenticação Biométrica"
        if
            context.canEvaluatePolicy(LAPolicy
            .deviceOwnerAuthenticationWithBiometrics, error: &err) {
            if context.biometryType == .faceID {
                print("Face id biometrics")
            }
            else if context.biometryType == .touchID {
                print("Touch id biometrics")
            }
            else {
                print("No Biometrics")
            }
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localString) { (success, error ) in
                if success {
                    let email = self.userdefaults.value(forKey: "email") as! String
                    let pwd = self.userdefaults.value(forKey: "pwd") as! String
                    
                    print("email=\(email) pwd =\(pwd)")
                    
                    let vc =  self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    @IBOutlet weak var btnLoginWhitFaceIdExit: UIButton!
    
    
    

}

