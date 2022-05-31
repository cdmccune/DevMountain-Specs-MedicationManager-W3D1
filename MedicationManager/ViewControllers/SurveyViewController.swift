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
