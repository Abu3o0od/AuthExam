//
//  ViewController.swift
//  AuthExample
//
//  Created by Rayyan on 11/02/2025.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    // Define a key for storing the biometric state
    let biometricStateKey = "com.yourapp.biometricState"
    
    @IBOutlet weak var Button: UIButton!
    @IBAction func Clicked(_ sender: Any) {
        authenticateUser()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // Biometric authentication is available
            
            // Evaluate the policy
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to access the app") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Authentication succeeded
                        print("Bravo")
                        
                        // Handle biometric state after successful auth
                        self.handleBiometricState(context: context)
                        
                    } else {
                        // Authentication failed
                        print("Error")
                    }
                }
            }
        } else {
            // Biometric authentication is not available
            if error != nil {
                print("Your phone does not support biometric authentication.")
            }
        }
    }
    
    func handleBiometricState(context: LAContext) {
        // Get the current biometric state
        guard let currentBiometricState = context.evaluatedPolicyDomainState else {
            print("No biometric state available")
            return
        }
        
        // Retrieve the saved biometric state
        if let savedBiometricState = UserDefaults.standard.data(forKey: biometricStateKey) {
            // Compare the current state with the saved state
            if currentBiometricState != savedBiometricState {
                print("Biometric data has changed!")
                print("YOU CHANGED YOUR FACE ID ! PLEASE LOGIN MANUALLY")
                UserDefaults.standard.set(currentBiometricState, forKey: biometricStateKey)
            } else {
                print("Biometric data has not changed.")
            }
        } else {
            // Save the current state if it's the first time
            UserDefaults.standard.set(currentBiometricState, forKey: biometricStateKey)
            print("Storing biometric state for the first time.")
        }
    }
}
