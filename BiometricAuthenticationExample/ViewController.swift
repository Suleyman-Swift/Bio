//
//  AppDelegate.swift
//  Face ID
//
//  Created by Süleyman Ekici on 10.08.2018.
//  Copyright © 2018 Süleyman Ekici. All rights reserved.
//

import UIKit
import BiometricAuthentication

class ViewController: UIViewController {

 
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
  
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        view.endEditing(true)
        showLoginSucessAlert()
    }
    
    @IBAction func biometricAuthenticationClicked(_ sender: Any) {
        
       
        BioMetricAuthenticator.authenticateWithBioMetrics(reason: "", success: {
            
          
            self.showLoginSucessAlert()
            
        }, failure: { [weak self] (error) in
        
            if error == .canceledByUser || error == .canceledBySystem {
                return
            }
            else if error == .biometryNotAvailable {
                self?.showErrorAlert(message: error.message())
            }
            else if error == .fallback {
                self?.txtUsername.becomeFirstResponder()
            }
            else if error == .biometryNotEnrolled {
                self?.showGotoSettingsAlert(message: error.message())
            }
            else if error == .biometryLockedout {
                self?.showPasscodeAuthentication(message: error.message())
            }
            else {
                self?.showErrorAlert(message: error.message())
            }
        })
    }
    
    func showPasscodeAuthentication(message: String) {
        
        BioMetricAuthenticator.authenticateWithPasscode(reason: message, success: {
            self.showLoginSucessAlert()
            
        }) { (error) in
            print(error.message())
        }
    }
}
extension ViewController {
    
    func showAlert(title: String, message: String) {
        
        let okAction = AlertAction(title: OKTitle)
        let alertController = getAlertViewController(type: .alert, with: title, message: message, actions: [okAction], showCancel: false) { (button) in
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func showLoginSucessAlert() {
        showAlert(title: "Tebrikler", message: "Giriş Başarılı")
    }
    
    func showErrorAlert(message: String) {
        showAlert(title: "Hata", message: message)
    }
    
    func showGotoSettingsAlert(message: String) {
        let settingsAction = AlertAction(title: "Ayarlara Git")
        
        let alertController = getAlertViewController(type: .alert, with: "Hata", message: message, actions: [settingsAction], showCancel: true, actionHandler: { (buttonText) in
            if buttonText == CancelTitle { return }
            let url = URL(string: "App-Prefs:root=TOUCHID_PASSCODE")
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
            
        })
        present(alertController, animated: true, completion: nil)
    }
}
