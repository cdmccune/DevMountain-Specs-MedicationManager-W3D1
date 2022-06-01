//
//  SurveyViewController.swift
//  MedicationManager
//
//  Created by Curt McCune on 5/31/22.
//

import UIKit


protocol MoodSurveyControllerDelegate: AnyObject {
    func moodButtonTapped( with emoji: String)
}

class SurveyViewController: UIViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reminderFired),
                                               name: NSNotification.Name(rawValue: Strings.medicationReminderID),
                                               object: nil)
    }
    
    @objc private func reminderFired() {
        view.backgroundColor = .systemRed
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view.backgroundColor = .systemCyan
        }
        
    }
    
    weak var delegate: MoodSurveyControllerDelegate?
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func emojiTapped(_ sender: UIButton) {
        guard let emoji = sender.titleLabel?.text else {return}
        delegate?.moodButtonTapped(with: emoji)
        self.dismiss(animated: true, completion: nil)
    }
    

}
