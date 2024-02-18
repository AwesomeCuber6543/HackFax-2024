//
//  SelectWorkoutViewController.swift
//  HackFax-AAAAT
//
//  Created by yahia salman on 2/17/24.
//

import UIKit

class SelectWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let options = ["Squats", "Bicep Curls", "Crunches", "Pushups"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select an Exercise"
        setupTableView()
    }
    
    func setupTableView() {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        view.addSubview(tableView)
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Select Workout"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Help", style: .plain, target: self, action: #selector(helpButtonTapped))
    }
    
    @objc func helpButtonTapped() {
        // Handle help button tap action
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = .systemFont(ofSize: 30, weight: .semibold)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = WorkoutViewController(exercise: indexPath.row)
        self.navigationController?.pushViewController(vc, animated: true)
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
