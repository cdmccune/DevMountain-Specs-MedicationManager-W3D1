//
//  MedicationListViewController.swift
//  MedicationManager
//
//  Created by Curt McCune on 5/30/22.
//

import UIKit

class MedicationListViewController: UIViewController  {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var moodSurveyButton: UIButton!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reminderFired),
                                               name: NSNotification.Name(rawValue: Strings.medicationReminderID),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reminderTakenAction),
                                               name: NSNotification.Name(rawValue: Strings.medicationReminderTakenButtonTapped),
                                               object: nil)
        
        MedicationController.shared.fetchMedications()
        guard let survey = MoodSurveyController.shared.fetchTodaysSurveys() else {return}
        
        moodSurveyButton.setTitle(survey.mentalState, for: .normal)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBAction func surveyButtonTapped(_ sender: Any) {
        guard let moodSurveyViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Strings.surveyViewControllerID) as? SurveyViewController else {return}
        moodSurveyViewController.delegate = self
        navigationController?.present(moodSurveyViewController, animated: true, completion: nil)
    }
    
    @objc private func reminderFired() {
        tableView.backgroundColor = .systemRed
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.tableView.backgroundColor = .systemBackground
        }
    }
        
    @objc private func reminderTakenAction() {
        tableView.reloadData()
    }
    
        
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == Strings.medDetailSegue,
               let indexPath = tableView.indexPathForSelectedRow,
               let destination = segue.destination as? MedicationDetailViewController {
                let medication = MedicationController.shared.sections[indexPath.section][indexPath.row]
                destination.medication = medication
            }
        }
    }
    
    extension MedicationListViewController:UITableViewDataSource {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return MedicationController.shared.sections.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return MedicationController.shared.sections[section].count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Strings.medicationCellID, for: indexPath) as? MedicationTableViewCell else {return UITableViewCell()}
            
            let medication = MedicationController.shared.sections[indexPath.section][indexPath.row]
            
            cell.delegate = self
            cell.configure(with: medication)
            return cell
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            if section == 0 {
                return "Not Taken"
            } else if section == 1 {
                return "Taken"
            } else {
                return nil
            }
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let medication = MedicationController.shared.sections[indexPath.section][indexPath.row]
                MedicationController.shared.deleteMedication(medication)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        
    }
    
    extension MedicationListViewController: UITableViewDelegate {}
    
    extension MedicationListViewController: MedicationTableViewCellDelegate {
        func medicationWasTakenButtonTapped(medication:Medication, wasTaken:Bool) {
            MedicationController.shared.markMedicationTaken(medication: medication, wasTaken: wasTaken)
            tableView.reloadData()
        }
    }
    
    extension MedicationListViewController:MoodSurveyControllerDelegate {
        func moodButtonTapped(with emoji: String) {
            MoodSurveyController.shared.didTapMoodEmoji(emoji)
            moodSurveyButton.setTitle(emoji, for: .normal)
        }
    }
