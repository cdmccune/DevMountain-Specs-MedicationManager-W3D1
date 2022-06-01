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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var medication: Medication?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        view.backgroundColor = .systemRed
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view.backgroundColor = .systemCyan
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let name = nameTextField.text,
                !name.isEmpty
        else {return}
        
        var date = datePicker.date
        
        if let medication = medication {
            MedicationController.shared.updateMedication(medication: medication, name: name, timeOfDay: date)
        } else {
            MedicationController.shared.create(name: name, timeOfDay: date)
        }
        navigationController?.popViewController(animated: true)
    }
}
