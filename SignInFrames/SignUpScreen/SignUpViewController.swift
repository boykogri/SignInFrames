//
//  ViewController.swift
//  SignInFrames
//
//  Created by Григорий Бойко on 13.09.2021.
//

import UIKit

class SignUpViewController: UIViewController {
    
    
    override func loadView() {
        let signUpView = SignUpView(frame: UIScreen.main.bounds)
        signUpView.delegate = self
        view = signUpView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        addKeyboardLisnteners()
        
    }

}
extension SignUpViewController: SignUpDelegate{
    func signUp(email: String, password: String, phone: String) {
        let variable = Variable(email: email, password: password, phone: phone)
        showAlert(alertText: "Отправляем запрос к серверу", alertMessage: "email - \(email)\npassword - \(password),\nphone - \(phone)")
    }
    
    
}
