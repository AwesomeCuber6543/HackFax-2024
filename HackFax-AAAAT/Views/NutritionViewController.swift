//
//  NutritionViewController.swift
//  HackFax-AAAAT
//
//  Created by yahia salman on 2/18/24.
//

import UIKit

protocol NutritionViewControllerDelegate: AnyObject {
    func didUpdateTotalCalories(_ totalCalories: Int)
}

class NutritionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    weak var delegate: NutritionViewControllerDelegate?
    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isScrollEnabled = true
//        tableView.allowsSelection = true
//        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var nutritionData = [[String: Any]]()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Food Name"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        textField.returnKeyType = .done
        return textField
    }()
    
    private let caloriesTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Calories"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.returnKeyType = .done
        return textField
    }()
    
    private let fatTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Fat (g)"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.returnKeyType = .done
        return textField
    }()
    
    private let carbsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Carbs (g)"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.returnKeyType = .done
        return textField
    }()
    
    private let proteinTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Protein (g)"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nutrition"
        view.backgroundColor = .white
        setupUI()
        fetchNutritionData()
        fetchTotalCalories()
        self.hideKeyboardWhenTappedAround()
        
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [nameTextField ,caloriesTextField, fatTextField, carbsTextField, proteinTextField, submitButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        
        self.view.addSubview(stackView)
        self.view.addSubview(tableView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10)
        ])
        self.view.sendSubviewToBack(stackView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    private func fetchNutritionData() {
        guard let url = URL(string: "\(Constants.baseURL)/get_all_nutrition_data") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                self?.nutritionData = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    // MARK: - Action Methods
    
    @objc private func submitButtonTapped() {
        guard let name = nameTextField.text,
              let calories = caloriesTextField.text,
              let fat = fatTextField.text,
              let carbs = carbsTextField.text,
              let protein = proteinTextField.text else {
            print("Please fill in all fields.")
            return
        }

        let url = URL(string: "\(Constants.baseURL)/add_nutrition_data")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "name": name,
            "calories": calories,
            "fat": fat,
            "carbs": carbs,
            "protein": protein
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let _ = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                print("Nutrition data added successfully")
                
                self.fetchNutritionData()
                self.fetchTotalCalories()
                
                DispatchQueue.main.async{
                    self.clearTextFields()
                }
            }

            task.resume()
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
        }
    }
    
    private func clearTextFields() {
        nameTextField.text = ""
        caloriesTextField.text = ""
        fatTextField.text = ""
        carbsTextField.text = ""
        proteinTextField.text = ""
    }
    
    private func fetchTotalCalories() {
        guard let url = URL(string: "\(Constants.baseURL)/total_calories") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching total calories:", error?.localizedDescription ?? "Unknown error")
                return
            }

            do {
                // Decode the JSON data
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let totalCalories = json?["total_calories"] as? Int {
                    DispatchQueue.main.async {
                        // Pass the total calories to the delegate
                        self?.delegate?.didUpdateTotalCalories(totalCalories)
                    }
                } else {
                    print("Error: Unable to parse total calories from JSON")
                }
            } catch {
                print("Error decoding JSON:", error.localizedDescription)
            }
        }.resume()
    }


    func updateTotalCalories(_ totalCalories: Int) {
        // Notify delegate about the update
        self.delegate?.didUpdateTotalCalories(totalCalories)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nutritionData.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let foodName = nutritionData[indexPath.row]["name"] as? String ?? ""
        let calories = nutritionData[indexPath.row]["calories"] as? String ?? ""
        let fat = nutritionData[indexPath.row]["fat"] as? String ?? ""
        let carbs = nutritionData[indexPath.row]["carbs"] as? String ?? ""
        let protein = nutritionData[indexPath.row]["protein"] as? String ?? ""
//        print(foodName)
        cell.textLabel?.text = "\(foodName) - Calories: \(calories), Fat: \(fat), Carbs: \(carbs), Protein: \(protein)"
        return cell
    }
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
