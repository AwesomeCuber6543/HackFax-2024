//
//  SummaryViewController.swift
//  HackFax-AAAAT
//
//  Created by yahia salman on 2/18/24.
//

import UIKit

class SummaryViewController: UIViewController {
    
    private var exercise: Int
    
    
    private let congratsLabel:UILabel = {
        let label = UILabel()
        label.text = "Congratulations on finishing your exercise!"
        return label
    }()
    
    
    init(exercise: Int) {
        self.exercise = exercise
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setupUI(){
        
        
        
        
    }
    

}
