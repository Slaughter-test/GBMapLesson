//
//  LoginViewController.swift
//  GBMapLesson
//
//  Created by Юрий Егоров on 17.11.2021.
//

import Foundation
import UIKit

final class LoginViewController: UIViewController {
  
    //MARK: - Variables
    
    var loginButton: UIButton!
    var registerButton: UIButton!
    var loginInput: UITextField!
    var passwordInput: UITextField!
    var router: ViewControllerRouterInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        router = ViewControllerRouter(viewController: self)
    }
    
    //MARK: - Actions
    
    @objc
    func login(_ sender: Any) {
        var exist = false
        let loginText = loginInput?.text
        let passwordText = passwordInput?.text
        if loginText != nil && loginText != Optional("") {
            exist = RealmService.shared.userCredentialsExists(login: loginText!)
        } else {
            showIncorrectLogin()
            return
        }
        if exist == true {
            if passwordText != nil && passwordText != "" {
                let status = RealmService.shared.authorization(login: loginText!, password: passwordText!)
                if status {
                    router.navigateToViewController(value: 2)
                } else {
                    showIncorrectLogin()
                    return
                }
            }
        } else {
            showIncorrectLogin()
            return
        }

    }
    
    @objc func register(_ sender: Any) {
        let alert = UIAlertController(title: "Регистрация", message: "Введите данные для регистрации", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { textfield in
            textfield.placeholder = "login"
        }
        alert.addTextField { textfield in
            textfield.placeholder = "password"
            textfield.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "Register", style: .default, handler: { [weak alert] (_) in
            let user = User()
            guard let login = alert?.textFields![0].text, let password = alert?.textFields![1].text else { return }
            user._login = login
            user.password = password
            RealmService.shared.saveObject(user)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Private functions
    
    private func setupViews() {
        
        loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.backgroundColor = .clear
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.gray.cgColor
        loginButton.translatesAutoresizingMaskIntoConstraints = true
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        registerButton = UIButton()
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.black, for: .normal)
        registerButton.backgroundColor = .clear
        registerButton.layer.cornerRadius = 5
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.gray.cgColor
        registerButton.translatesAutoresizingMaskIntoConstraints = true
        registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        loginInput = UITextField()
        loginInput.placeholder = "Введите логин"
        loginInput.textColor = .blue
        loginInput.borderStyle = UITextField.BorderStyle.roundedRect
        loginInput.translatesAutoresizingMaskIntoConstraints = true
        
        passwordInput = UITextField()
        passwordInput.placeholder = "Введите пароль"
        passwordInput.textColor = .blue
        passwordInput.borderStyle = UITextField.BorderStyle.roundedRect
        passwordInput.isSecureTextEntry = true
        passwordInput.translatesAutoresizingMaskIntoConstraints = true
        
        
        view.addSubview(loginButton, anchors: [.leading(100), .height(40), .trailing(-100), .bottom(-350)])
        view.addSubview(registerButton, anchors: [.leading(100), .height(40), .trailing(-100), .bottom(-250)])
        view.addSubview(loginInput, anchors: [.leading(50), .height(40), .trailing(-50), .top(250)])
        view.addSubview(passwordInput, anchors: [.leading(50), .height(40), .trailing(-50), .top(350)])
    }
    
    private func showIncorrectLogin() {
        let alert = UIAlertController(title: "Ошибка авторизации", message: "Введены некорректные данные", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ну ладна", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
