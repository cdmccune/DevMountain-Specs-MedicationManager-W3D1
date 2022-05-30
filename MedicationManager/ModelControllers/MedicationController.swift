//
//  MedicationController.swift
//  MedicationManager
//
//  Created by Curt McCune on 5/30/22.
//

import Foundation
import CoreData

class MedicationController {
    
    static let shared = MedicationController()
    
    private init() {}
    
    private lazy var fetchRequest: NSFetchRequest<Medication> = {
        let request = NSFetchRequest<Medication>(entityName: "Medication")
        request.predicate = NSPredicate(value:true)
        return request
    }()
    
    var medications: [Medication] = []
    
    //Crud
    
    func create(name: String, timeOfDay: Date) {
        let medication = Medication(name: name, timeOfDay: timeOfDay)
        medications.append(medication)
        CoreDataStack.saveContext()
    }
    
    func fetchMedications() {
        
        let medications = (try? CoreDataStack.context.fetch(self.fetchRequest)) ?? []
        self.medications = medications
    }
    
    func updateMedication(medication: Medication, name:String, timeOfDay:Date) {
        medication.name = name
        medication.timeOfDay = timeOfDay
        CoreDataStack.saveContext()
    }
    
    func deleteMedication() {
        
    }
}
