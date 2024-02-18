//
//  HomePageViewController.swift
//  HackFax-AAAAT
//
//  Created by yahia salman on 2/17/24.
//

import UIKit

class HomePageViewController: UIViewController {
    
    
    private let welcomeLabel: UILabel = {
       let welcomeLabel = UILabel()
        welcomeLabel.text = "HELLO YAHIA"
        welcomeLabel.textColor = Constants.mainGreen
        welcomeLabel.font = .systemFont(ofSize: 50)
        return welcomeLabel
    }()
    
    private let welcomeLabel2: UILabel = {
        let welcomeLabel2 = UILabel()
        welcomeLabel2.text = "Let's Workout!"
        welcomeLabel2.textColor = Constants.mainGreen
        welcomeLabel2.font = .systemFont(ofSize: 30)
        return welcomeLabel2
    }()
    
    private let newWorkoutButton: UIButton = {
        let newWorkoutButton = UIButton()
        newWorkoutButton.backgroundColor = Constants.mainGreen
        newWorkoutButton.layer.cornerRadius = 10
//        newWorkoutButton.setImage(UIImage(systemName: "sun.min"), for: .normal)
//        newWorkoutButton.imageView?.contentMode = .
        return newWorkoutButton
    }()
    
    private let newWorkoutImage: UIImageView = {
        let newWorkoutImage = UIImageView(image: UIImage(systemName: "dumbbell.fill"))
        newWorkoutImage.tintColor = .white
        return newWorkoutImage
    }()
    
    private let oldWorkoutButton: UIButton = {
        let newWorkoutButton = UIButton()
        newWorkoutButton.backgroundColor = Constants.mainGreen
        newWorkoutButton.layer.cornerRadius = 10
        return newWorkoutButton
    }()
    
    private let oldWorkoutImage: UIImageView = {
        let oldWorkoutImage = UIImageView(image: UIImage(systemName: "clock.fill"))
        oldWorkoutImage.tintColor = .white
        return oldWorkoutImage
    }()
    
    private let nutritionButton: UIButton = {
        let nutritionButton = UIButton()
        nutritionButton.backgroundColor = Constants.mainGreen
        nutritionButton.layer.cornerRadius = 10
        return nutritionButton
    }()
    
    private let nutritionImage: UIImageView = {
        let nutritionImage = UIImageView(image: UIImage(systemName: "carrot.fill"))
        nutritionImage.tintColor = .white
        return nutritionImage
    }()
    
    private let personalInformationButton: UIButton = {
        let personalInformationButton = UIButton()
        personalInformationButton.backgroundColor = Constants.mainGreen
        personalInformationButton.layer.cornerRadius = 10
        return personalInformationButton
    }()
    
    private let personalImage: UIImageView = {
        let nutritionImage = UIImageView(image: UIImage(systemName: "person.fill"))
        nutritionImage.tintColor = .white
        return nutritionImage
    }()
    
    private let totalCaloriesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "YAHIA"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let termsTextView: UITextView = {
        
        let attributedString = NSMutableAttributedString(string: "Check out our Terms & Conditions and Privacy Policy")
        
        attributedString.addAttribute(.link, value: "terms://termsAndConditions", range: (attributedString.string as NSString).range(of: "Terms & Conditions"))
        
        attributedString.addAttribute(.link, value: "privacy://privacyPolicy", range: (attributedString.string as NSString).range(of: "Privacy Policy"))
        
        let tv = UITextView()
        
        tv.linkTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.mainGreen]
        tv.backgroundColor = .clear
        tv.attributedText = attributedString
        tv.textColor = .black
        tv.isSelectable = true
        tv.isEditable = false
        tv.delaysContentTouches = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupUI()
        self.newWorkoutButton.addTarget(self, action: #selector(didTapAddNewWorkout), for: .touchUpInside)
        self.personalInformationButton.addTarget(self, action: #selector(didTapPersonalInformation), for: .touchUpInside)
        self.nutritionButton.addTarget(self, action: #selector(didTapNutrition), for: .touchUpInside)
        self.oldWorkoutButton.addTarget(self, action: #selector(didTapWorkoutHistory), for: .touchUpInside)
        self.termsTextView.delegate = self
//
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(didTapBack))
    }
    
    
    private func setupUI(){
        
        self.view.addSubview(newWorkoutButton)
        self.view.addSubview(welcomeLabel)
        self.view.addSubview(oldWorkoutButton)
        self.view.addSubview(nutritionButton)
        self.view.addSubview(personalInformationButton)
        self.view.addSubview(newWorkoutImage)
        self.view.addSubview(oldWorkoutImage)
        self.view.addSubview(personalImage)
        self.view.addSubview(nutritionImage)
        self.view.addSubview(totalCaloriesLabel)
        self.view.addSubview(termsTextView)
        self.view.addSubview(welcomeLabel2)
        
        
        newWorkoutButton.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        oldWorkoutButton.translatesAutoresizingMaskIntoConstraints = false
        nutritionButton.translatesAutoresizingMaskIntoConstraints = false
        personalInformationButton.translatesAutoresizingMaskIntoConstraints = false
        newWorkoutImage.translatesAutoresizingMaskIntoConstraints = false
        oldWorkoutImage.translatesAutoresizingMaskIntoConstraints = false
        nutritionImage.translatesAutoresizingMaskIntoConstraints = false
        personalImage.translatesAutoresizingMaskIntoConstraints = false
        totalCaloriesLabel.translatesAutoresizingMaskIntoConstraints = false
        termsTextView.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.welcomeLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 130),
//            self.welcomeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
//            self.welcomeLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.welcomeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.welcomeLabel.heightAnchor.constraint(equalToConstant: 50),
            
            self.welcomeLabel2.topAnchor.constraint(equalTo: self.welcomeLabel.bottomAnchor, constant: 20),
            self.welcomeLabel2.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.welcomeLabel2.heightAnchor.constraint(equalToConstant: 50),
        
            self.newWorkoutButton.topAnchor.constraint(equalTo: self.welcomeLabel.topAnchor, constant: 170),
            self.newWorkoutButton.widthAnchor.constraint(equalToConstant: 170),
            self.newWorkoutButton.heightAnchor.constraint(equalToConstant: 170),
            self.newWorkoutButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),

            self.oldWorkoutButton.topAnchor.constraint(equalTo: self.welcomeLabel.topAnchor, constant: 170),
            self.oldWorkoutButton.widthAnchor.constraint(equalToConstant: 170),
            self.oldWorkoutButton.heightAnchor.constraint(equalToConstant: 170),
            self.oldWorkoutButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
            
            self.nutritionButton.topAnchor.constraint(equalTo: self.newWorkoutButton.bottomAnchor, constant: 30),
            self.nutritionButton.widthAnchor.constraint(equalToConstant: 170),
            self.nutritionButton.heightAnchor.constraint(equalToConstant: 170),
            self.nutritionButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
            
            self.personalInformationButton.topAnchor.constraint(equalTo: self.oldWorkoutButton.bottomAnchor, constant: 30),
            self.personalInformationButton.widthAnchor.constraint(equalToConstant: 170),
            self.personalInformationButton.heightAnchor.constraint(equalToConstant: 170),
            self.personalInformationButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
            
            self.newWorkoutImage.centerXAnchor.constraint(equalTo: self.newWorkoutButton.centerXAnchor),
            self.newWorkoutImage.centerYAnchor.constraint(equalTo: self.newWorkoutButton.centerYAnchor),
            self.newWorkoutImage.widthAnchor.constraint(equalToConstant: 150),
            self.newWorkoutImage.heightAnchor.constraint(equalToConstant: 100),
            
            self.oldWorkoutImage.centerXAnchor.constraint(equalTo: self.oldWorkoutButton.centerXAnchor),
            self.oldWorkoutImage.centerYAnchor.constraint(equalTo: self.oldWorkoutButton.centerYAnchor),
            self.oldWorkoutImage.widthAnchor.constraint(equalToConstant: 100),
            self.oldWorkoutImage.heightAnchor.constraint(equalToConstant: 100),
            
            self.personalImage.centerXAnchor.constraint(equalTo: self.personalInformationButton.centerXAnchor),
            self.personalImage.centerYAnchor.constraint(equalTo: self.personalInformationButton.centerYAnchor),
            self.personalImage.widthAnchor.constraint(equalToConstant: 100),
            self.personalImage.heightAnchor.constraint(equalToConstant: 100),
            
            self.nutritionImage.centerXAnchor.constraint(equalTo: self.nutritionButton.centerXAnchor),
//            self.nutritionImage.centerYAnchor.constraint(equalTo: self.nutritionButton.centerYAnchor),
            self.nutritionImage.widthAnchor.constraint(equalToConstant: 100),
            self.nutritionImage.heightAnchor.constraint(equalToConstant: 100),
            self.nutritionImage.topAnchor.constraint(equalTo: self.nutritionButton.topAnchor, constant: 20),
            
            
            totalCaloriesLabel.centerXAnchor.constraint(equalTo: nutritionButton.centerXAnchor),
//            totalCaloriesLabel.topAnchor.constraint(equalTo: nutritionImage.bottomAnchor, constant: 10),
//            totalCaloriesLabel.leadingAnchor.constraint(equalTo: nutritionButton.leadingAnchor, constant: 5),
//            totalCaloriesLabel.trailingAnchor.constraint(equalTo: nutritionButton.trailingAnchor, constant: -5)
//            totalCaloriesLabel.centerYAnchor.constraint(equalTo: nutritionButton.centerYAnchor)
            totalCaloriesLabel.bottomAnchor.constraint(equalTo: nutritionButton.bottomAnchor, constant: -20),
            
            self.termsTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40),
            self.termsTextView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
            
            
            
        
        
        
        
        
        ])
        
        
        
    }
    
    @objc func didTapAddNewWorkout(){
//        let vc = SelectWorkoutViewController()
//        vc.modalPresentationStyle = .fullScreen // You can adjust the presentation style as needed
//        present(vc, animated: true, completion: nil)
        
        let vc = SelectWorkoutViewController()
//        let navigationController = UINavigationController(rootViewController: vc)
//        navigationController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func didTapPersonalInformation() {
        let vc = PersonalInformationViewController()
//        let navigationController = UINavigationController(rootViewController: vc)
//        navigationController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapNutrition() {
        let vc = NutritionViewController()
        vc.delegate = self
//        let navigationController = UINavigationController(rootViewController: vc)
//        navigationController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapWorkoutHistory() {
        let vc = ExerciseHistoryViewController()
//        let navigationController = UINavigationController(rootViewController: vc)
//        navigationController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapBack() {
        self.dismiss(animated: true, completion: nil)
    }



}

extension HomePageViewController: NutritionViewControllerDelegate {
    func didUpdateTotalCalories(_ totalCalories: Int) {
        totalCaloriesLabel.text = "Calories: \(totalCalories)"
    }
}

extension HomePageViewController: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if URL.scheme == "terms" {
            self.showWebViewerController(with: "https://policies.google.com/terms?hl=en")
        } else if URL.scheme == "privacy" {
            self.showWebViewerController(with: "https://policies.google.com/privacy?hl=en")
        }
        
        
        return true
    }
    
    private func showWebViewerController(with urlString: String) {
        let vc = WebViewerController(with: urlString)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.delegate = nil
        textView.selectedTextRange = nil
        textView.delegate = self
    }
}



