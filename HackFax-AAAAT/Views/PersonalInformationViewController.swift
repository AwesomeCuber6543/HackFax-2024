//
//  PersonalInformationViewController.swift
//  HackFax-AAAAT
//
//  Created by yahia salman on 2/18/24.
//

import UIKit

class PersonalInformationViewController: UIViewController {
    
    
    private var weight: Float = 0.0
    private var height: Int = 0
    private var BMI: Float = 0
    private var BMIRange: String = ""
    
    
    // Labels for displaying personal information
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.text = "Height:"
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.text = "Weight:"
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private let bmiLabel: UILabel = {
        let label = UILabel()
        label.text = "BMI:"
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private let bmiRangeLabel: UILabel = {
        let label = UILabel()
        label.text = "BMI Range:"
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    // Labels for displaying actual values
    private let heightValueLabel: UILabel = {
        let label = UILabel()
        label.text = "72 in" // Example value
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    private let weightValueLabel: UILabel = {
        let label = UILabel()
        label.text = "202.4 lbs" // Example value
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    private let bmiValueLabel: UILabel = {
        let label = UILabel()
        label.text = "24.2" // Example value
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    private let bmiRangeValueLabel: UILabel = {
        let label = UILabel()
        label.text = "Normal" // Example value
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Personal Information"
        self.view.backgroundColor = .white
        self.setupUI()
    }
    
    private func setupUI() {
        // Add labels to the view
        let labels = [heightLabel, weightLabel, bmiLabel, bmiRangeLabel]
        let valueLabels = [heightValueLabel, weightValueLabel, bmiValueLabel, bmiRangeValueLabel]
        
        for (index, label) in labels.enumerated() {
            self.view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(100 + index * 60)),
                label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
                label.widthAnchor.constraint(equalToConstant: 100),
                label.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
        
        for (index, label) in valueLabels.enumerated() {
            self.view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(100 + index * 60)),
                label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
                label.widthAnchor.constraint(equalToConstant: 150),
                label.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
    }

}

