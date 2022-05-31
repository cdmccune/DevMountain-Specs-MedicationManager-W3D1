//
//  MedicationTableViewCell.swift
//  MedicationManager
//
//  Created by Curt McCune on 5/30/22.
//

import UIKit

protocol MedicationTableViewCellDelegate: AnyObject {
    func medicationWasTakenButtonTapped(medication:Medication, wasTaken:Bool)
}

class MedicationTableViewCell: UITableViewCell {

    weak var delegate: MedicationTableViewCellDelegate?
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var wasTakenButton: UIButton!
    
    private var medication: Medication?
    private var wasTakenToday: Bool = false
    
    @IBAction func wasTakenButtonTapped(_ sender: Any) {
        guard let medication = medication else {
            return
        }
        wasTakenToday.toggle()
        delegate?.medicationWasTakenButtonTapped(medication: medication, wasTaken: wasTakenToday )
    }
    
    func configure(with medication: Medication) {
        self.medication = medication
        wasTakenToday = medication.wasTakenToday()
        
        
        
        nameLabel.text = medication.name
        timeLabel.text = DateFormatter.medicationTime.string(from: medication.timeOfDay ?? Date())
        let image = wasTakenToday ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        wasTakenButton.setImage(image, for: .normal)
    }

}
