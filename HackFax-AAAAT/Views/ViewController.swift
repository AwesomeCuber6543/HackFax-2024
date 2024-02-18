//
//  ViewController.swift
//  HackFax-AAAAT
//
//  Created by yahia salman on 2/16/24.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    private let usernameLabel = CustomTextField(fieldType: .username)
    private let passwordLabel = CustomTextField(fieldType: .password)
    private let loginButton = CustomButton(title: "Log In",hasBackground: true ,fontsize: .med, buttonColor: UIColor(red: 32/255, green: 97/255, blue: 0/255, alpha: 1), titleColor: .white)
    
    
    
    private let repsLogo: UIImageView = {
       let repsLogo = UIImageView(image: UIImage(named: "RepsTemp"))
        return repsLogo
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupUI()
        
        self.loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        
    }
    
    func setupUI(){
        
        self.view.addSubview(usernameLabel)
        self.view.addSubview(passwordLabel)
        self.view.addSubview(loginButton)
        self.view.addSubview(repsLogo)
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        repsLogo.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.activate([
            
            self.repsLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.repsLogo.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150),
            self.repsLogo.widthAnchor.constraint(equalToConstant: 300),
            self.repsLogo.heightAnchor.constraint(equalToConstant: 145),
            
            self.usernameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.usernameLabel.topAnchor.constraint(equalTo: self.repsLogo.bottomAnchor, constant: 50),
            self.usernameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.usernameLabel.heightAnchor.constraint(equalToConstant: 45),
            
            
            self.passwordLabel.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor, constant: 10),
            self.passwordLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.passwordLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.passwordLabel.heightAnchor.constraint(equalToConstant: 45),
            
            self.loginButton.topAnchor.constraint(equalTo: self.passwordLabel.bottomAnchor, constant: 10),
            self.loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.loginButton.heightAnchor.constraint(equalToConstant: 60),
        
        
        
        ])
        
        
        
        
        
    }
    
    @objc func checkAuthentication() {
        
        let urlString = "\(Constants.baseURL)/get_number_squats"

        // Create URL object
        if let url = URL(string: urlString) {
            // Create URLSession
            let session = URLSession(configuration: .default)
            
            // Create a data task
            let task = session.dataTask(with: url) { (data, response, error) in
                // Check for errors
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                // Check if response contains data
                guard let responseData = data else {
                    print("Error: Did not receive data")
                    return
                }
                
                do {
                    // Parse JSON data
                    if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                        // Extract the count value
                        if let count = json["count"] as? Int {
                            // Use the count value as needed
                            print("Count: \(count)")
                            // Here you can store the count value in a variable or perform any other actions
                        } else {
                            print("Error: Count value not found in JSON")
                        }
                    } else {
                        print("Error: Unable to parse JSON data")
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
            
            // Start the data task
            task.resume()
        } else {
            print("Error: Invalid URL")
        }
        
    }
    
    @objc func didTapLogin(){
//        let vc = HomePageViewController()
//        vc.modalPresentationStyle = .fullScreen // You can adjust the presentation style as needed
        
        
        let navigationController = UINavigationController(rootViewController: HomePageViewController())
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
        
    }


}

