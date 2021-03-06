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
    @IBOutlet var sortMedsButton: UIButton!
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Styling
        sortMedsButton.layer.cornerRadius = 10
        
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
                
        // This will alter the navigation bar title appearance
        let titleAttribute = [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 25), NSAttributedString.Key.foregroundColor: UIColor.black] //alter to fit your needs
        appearance.titleTextAttributes = titleAttribute

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        
        title = "Your Medications"
        
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
    
    @IBAction func sortMedsButtonTapped(_ sender: Any) {
        MedicationController.shared.sortMeds()
        tableView.reloadData()
    }
    
    
    @IBAction func surveyButtonTapped(_ sender: Any) {
        guard let moodSurveyViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Strings.surveyViewControllerID) as? SurveyViewController else {return}
        moodSurveyViewController.delegate = self
        navigationController?.present(moodSurveyViewController, animated: true, completion: nil)
    }
    
    @objc private func reminderFired() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemRed
        let titleAttribute = [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 25), NSAttributedString.Key.foregroundColor: UIColor.black]
        appearance.titleTextAttributes = titleAttribute
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            let titleAttribute = [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 25), NSAttributedString.Key.foregroundColor: UIColor.black]
            appearance.titleTextAttributes = titleAttribute
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            
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
