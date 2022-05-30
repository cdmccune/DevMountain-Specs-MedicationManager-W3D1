//
//  MedicationTableViewCell.swift
//  MedicationManager
//
//  Created by Curt McCune on 5/30/22.
//

import UIKit

class MedicationTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var wasTakenButton: UIButton!
    
    
    @IBAction func wasTakenButtonTapped(_ sender: Any) {
        print("Was Taken Button Tapped")
    }
    
    func configure(with medication: Medication) {
        nameLabel.text = medication.name
        timeLabel.text = DateFormatter.medicationTime.string(from: medication.timeOfDay ?? Date())
    }

}
