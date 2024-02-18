//
//  ExerciseHistoryViewController.swift
//  HackFax-AAAAT
//
//  Created by yahia salman on 2/18/24.
//

import UIKit

import UIKit

struct ExerciseEntry: Decodable, Encodable {
    let date: String
    let exerciseName: String
    let completeReps: Int
    let partialReps: Int
    
    enum CodingKeys: String, CodingKey {
        case date
        case exerciseName = "exercise_name"
        case completeReps = "complete_reps"
        case partialReps = "partial_reps"
    }
}

class ExerciseHistoryViewController: UITableViewController {

    var exerciseEntries = [String: [ExerciseEntry]]() // Dictionary to store exercise entries grouped by date

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Exercise History"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = false
        // Fetch exercise data from MongoDB and populate exerciseEntries dictionary
        fetchExerciseData()
    }

    // Fetch exercise data from MongoDB
    func fetchExerciseData() {
        guard let url = URL(string: "\(Constants.baseURL)/get_exercise_data") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching exercise data:", error?.localizedDescription ?? "Unknown error")
                return
            }

            do {
                let exerciseData = try JSONDecoder().decode([ExerciseEntry].self, from: data)
                self?.processExerciseData(exerciseData)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } catch {
                print("Error decoding exercise data:", error.localizedDescription)
            }
        }.resume()
    }

    
    // Process fetched exercise data and populate the exerciseEntries dictionary
    func processExerciseData(_ exerciseData: [ExerciseEntry]) {
        for entry in exerciseData {
            if exerciseEntries[entry.date] != nil {
                exerciseEntries[entry.date]?.append(entry)
            } else {
                exerciseEntries[entry.date] = [entry]
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return exerciseEntries.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dates = Array(exerciseEntries.keys)
        let date = dates[section]
        return exerciseEntries[date]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let dates = Array(exerciseEntries.keys)
        let date = dates[indexPath.section]
        if let entries = exerciseEntries[date] {
            let entry = entries[indexPath.row]
            // Configure the cell with exercise data
            cell.textLabel?.text = "\(entry.exerciseName) - \(entry.completeReps)/\(entry.partialReps) reps completed"
//            cell.detailTextLabel?.text = "Complete reps: \(entry.completeReps), Partial reps: \(entry.partialReps)"
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dates = Array(exerciseEntries.keys)
        return dates[section]
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let dates = Array(exerciseEntries.keys)
            let date = dates[indexPath.section]
            if var entries = exerciseEntries[date] {
                let entryToDelete = entries.remove(at: indexPath.row)
                exerciseEntries[date] = entries
                // Call function to delete entry from MongoDB
                print(entryToDelete)
                deleteExerciseEntry(entryToDelete)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    // Function to delete exercise entry from MongoDB
    func deleteExerciseEntry(_ entry: ExerciseEntry) {
        guard let url = URL(string: "\(Constants.baseURL)/delete_exercise_entry") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create a dictionary with required fields
        let entryData: [String: Any] = [
            "date": entry.date,
            "exercise_name": entry.exerciseName,
            "complete_reps": entry.completeReps,
            "partial_reps": entry.partialReps
        ]
        
        // Debugging: Print the contents of entryData
        print("Entry data:", entryData)
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: entryData)
            request.httpBody = jsonData
        } catch {
            print("Error encoding exercise entry data:", error.localizedDescription)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                print("No HTTP response received")
                return
            }
            
            if let error = error {
                print("Error deleting exercise entry:", error.localizedDescription)
                return
            }
            
            if httpResponse.statusCode == 200 {
                print("Exercise entry deleted successfully")
            } else {
                print("Failed to delete exercise entry. Status code: \(httpResponse.statusCode)")
                if let responseData = data, let responseString = String(data: responseData, encoding: .utf8) {
                    print("Response data:", responseString)
                }
            }
        }.resume()
    }


}

