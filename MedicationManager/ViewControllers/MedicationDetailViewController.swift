//
//  MedicationDetailViewController.swift
//  MedicationManager
//
//  Created by Curt McCune on 5/30/22.
//

import UIKit

class MedicationDetailViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var innerView: UIView!
    @IBOutlet var outerView: UIView!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var medication: Medication?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Styling
        innerView.layer.cornerRadius = 10
        outerView.layer.cornerRadius = 10
        
        if let medication = medication,
           let timeOfDay = medication.timeOfDay{
            title = Strings.medDetailSegue
            nameTextField.text = medication.name
            datePicker.date = timeOfDay
            
            
            
        } else {
            title = Strings.addMedicationTitle
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reminderFired),
                                               name: NSNotification.Name(rawValue: Strings.medicationReminderID),
                                               object: nil)
    }
    
    @objc private func reminderFired() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemRed
        let titleAttribute = [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 25), NSAttributedString.Key.foregroundColor: UIColor.red]
        appearance.titleTextAttributes = titleAttribute
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            let titleAttribute = [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 25), NSAttributedString.Key.foregroundColor: UIColor.black]
            appearance.titleTextAttributes = titleAttribute
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let name = nameTextField.text,
                !name.isEmpty
        else {return}
        
        let date = datePicker.date
        
        if let medication = medication {
            MedicationController.shared.updateMedication(medication: medication, name: name, timeOfDay: date)
        } else {
            MedicationController.shared.create(name: name, timeOfDay: date)
        }
        navigationController?.popViewController(animated: true)
    }
}
