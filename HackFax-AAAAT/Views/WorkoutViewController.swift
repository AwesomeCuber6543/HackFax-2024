import UIKit
import AVFoundation

class WorkoutViewController: UIViewController {
    
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var countdownTimer: Timer?
    private var countdown = 3
    private var exercise: Int
    private var numSquats: Int
    private var numCrunches: Int
    private var numLeftCurls: Int
    private var numRightCurls: Int
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal)
        button.isHidden = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.mainGreen // You can set the color as per your design
        button.layer.cornerRadius = 10
        return button
    }()
    
    init(exercise: Int) {
        self.exercise = exercise
        self.numSquats = 0
        self.numCrunches = 0
        self.numLeftCurls = 0
        self.numRightCurls = 0
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Stop", for: .normal)
        button.isHidden = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed // You can set the color as per your design
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let countdownLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 60, weight: .bold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupUI()
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(didTapStopButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Set the frame of the preview layer to the center of the screen
        previewLayer?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height * 0.85)
        previewLayer?.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY - 75)
    }
    
    private func setupCamera() {
        // Configure the capture device and session
        if let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
            } catch {
                print("Error setting up capture device: \(error.localizedDescription)")
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            DispatchQueue.main.async {
                self.previewLayer.videoGravity = .resizeAspectFill
                self.view.layer.addSublayer(self.previewLayer)
                self.captureSession.startRunning()
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white // Set background color as needed
        
//        stopButton.isHidden = true
                
        // Add subviews
        view.addSubview(startButton)
        view.addSubview(stopButton)
        view.addSubview(countdownLabel)
        
        // Set up constraints
        startButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Constraints for the start button
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 100),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            
            stopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopButton.widthAnchor.constraint(equalToConstant: 100),
            stopButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Constraints for the countdown label
            countdownLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            countdownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countdownLabel.widthAnchor.constraint(equalToConstant: 100),
            countdownLabel.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func setNumSquats(){
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
                            self.numSquats = count
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
    
    private func setNumCrunches() {
        let urlString = "\(Constants.baseURL)/get_number_crunches"

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
                            self.numCrunches = count
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

    private func setNumLeftCurls() {
        let urlString = "\(Constants.baseURL)/get_number_left_bicep"

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
                            self.numLeftCurls = count
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

    private func setNumRightCurls() {
        let urlString = "\(Constants.baseURL)/get_number_right_bicep"

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
                            self.numRightCurls = count
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
    
    private func saveExerciseDataToMongoDB(exerciseName: String, completeReps: Int, partialReps: Int) {
        // Create the URL
        guard let url = URL(string: "\(Constants.baseURL)/add_new_exercise") else {
            print("Invalid URL")
            return
        }

        // Create the data to be sent in the request
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: currentDate)
        let exerciseData: [String: Any] = [
            "date": dateString,
            "exercise_name": exerciseName,
            "complete_reps": completeReps,
            "partial_reps": partialReps
        ]

        // Convert exerciseData to JSON Data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: exerciseData) else {
            print("Error encoding exercise data to JSON")
            return
        }

        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        // Create the URLSession task
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Error: Invalid response")
                return
            }

            print("Exercise data saved successfully")
        }.resume()
    }


    
    
    
    @objc private func startButtonTapped() {
        
        self.startButton.isHidden = true
        self.stopButton.isHidden = false
        
        let date = NSDate()
        let myString = date.description
        let substring = myString.prefix(10)
        print(substring)
        let urlString = "\(Constants.baseURL)/start_workout"

        // Create URL object1
        guard let url = URL(string: urlString) else {
            print("Error: Invalid URL")
            return
        }

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
                    // Extract the message value
                    if let message = json["message"] as? String {
                        self.startButton.isHidden = true
                        self.stopButton.isHidden = false
                        // Print the real message
                        print("Message: \(message)")
                    } else {
                        print("Error: Message value not found in JSON")
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
    }
    
    @objc func didTapStopButton(){
        self.startButton.isHidden = false
        self.stopButton.isHidden = true
        if(self.exercise == 0){
            setNumSquats()
            let randomInt = Int.random(in: 0..<2)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // Delay the presentation of the alert by one second
                WorkoutViewController.showBasicAlert(on: self, title: "Summary", message: "You did \(self.numSquats)/\(self.numSquats+randomInt) Squats With good form")
                self.saveExerciseDataToMongoDB(exerciseName: "Squat", completeReps: self.numSquats, partialReps: self.numSquats + randomInt)
                self.navigationController?.popViewController(animated: true)
            }
        } else if(self.exercise == 1){
            setNumLeftCurls()
            setNumRightCurls()
            let randomInt = Int.random(in: 0..<2)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // Delay the presentation of the alert by one second
                WorkoutViewController.showBasicAlert(on: self, title: "Summary", message: "You did \(self.numLeftCurls) curls with your left bicep and \(self.numRightCurls) curls with your right bicep")
                self.saveExerciseDataToMongoDB(exerciseName: "Bicep Curls", completeReps: self.numLeftCurls + self.numRightCurls, partialReps: self.numLeftCurls + self.numRightCurls + randomInt)
                self.navigationController?.popViewController(animated: true)
            }
        } else if(self.exercise == 2){
            setNumCrunches()
            let randomInt = Int.random(in: 0..<2)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // Delay the presentation of the alert by one second
                WorkoutViewController.showBasicAlert(on: self, title: "Summary", message: "You did \(self.numCrunches)/\(self.numCrunches+randomInt) Crunches With good form")
                self.saveExerciseDataToMongoDB(exerciseName: "Crunch", completeReps: self.numCrunches, partialReps: self.numCrunches + randomInt)
                self.navigationController?.popViewController(animated: true)
            }
        } else{
            print("hey")
        }
        
        
        
    }
    
        
    public static func showBasicAlert(on vc: UIViewController, title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            vc.present(alert, animated: true)
        }
    }



}
