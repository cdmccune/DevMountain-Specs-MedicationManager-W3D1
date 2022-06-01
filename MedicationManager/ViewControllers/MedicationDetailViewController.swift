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
