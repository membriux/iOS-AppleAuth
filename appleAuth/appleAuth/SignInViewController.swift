//
//  SignInViewControllerV2.swift
//  bread
//
//  Created by Memo on 3/10/21.
//

import UIKit
import AuthenticationServices

class SignInViewController: UIViewController {
    
    @IBOutlet weak var appleButtonView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppleButtonUI()
    }

    
    // Sign in button functionality
    @objc
    func didTapAppleButton() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
    }
    
    
}

/* –––––  Apple Signin Functionality –––––*/
extension SignInViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    // Successful authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appCredentials = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userId = appCredentials.user
            let fullName = appCredentials.fullName!
            let email = appCredentials.email!
            
            print("\nUser id: \(userId) \nFull name: \(fullName) \n Email: \(email)")
            self.userNameLabel.text = userId
        }
        
//        switch authorization.credential {
//            case let credentials as ASAuthorizationAppleIDCredential:
//                print("\nSigned in Succesfully!\n", credentials)
//
//            default: break
//        }
    }
    
    // Error in authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("\nError authorizing:\n", error.localizedDescription)
    }
    
    // Authorization ViewController
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
 
}


/* –––––  UI Setup –––––*/
extension SignInViewController {
    
    func setupAppleButtonUI() {
        
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        
        appleButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)
        appleButtonView.addSubview(appleButton)
        
        NSLayoutConstraint.activate([
            appleButton.topAnchor.constraint(equalTo: self.appleButtonView.centerYAnchor, constant: 0.0),
            appleButton.leadingAnchor.constraint(equalTo: self.appleButtonView.leadingAnchor, constant: 0.0),
            appleButton.trailingAnchor.constraint(equalTo: self.appleButtonView.trailingAnchor, constant: 0.0),
            appleButton.bottomAnchor.constraint(equalTo: self.appleButtonView.bottomAnchor, constant: 0.0),
            ])
    }
}

