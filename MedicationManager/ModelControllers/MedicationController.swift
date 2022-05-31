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
    
    var sections: [[Medication]] {[notTakenMeds,takenMeds]}
    private var notTakenMeds: [Medication] = []
    private var takenMeds: [Medication] = []
    
    //Crud
    
    func create(name: String, timeOfDay: Date) {
        let medication = Medication(name: name, timeOfDay: timeOfDay)
        notTakenMeds.append(medication)
        CoreDataStack.saveContext()
    }
    
    func fetchMedications() {
        
        let medications = (try? CoreDataStack.context.fetch(self.fetchRequest)) ?? []
//
        takenMeds = medications.filter {$0.wasTakenToday()}
        notTakenMeds = medications.filter { !$0.wasTakenToday()}
    }
    
    func updateMedication(medication: Medication, name:String, timeOfDay:Date) {
        medication.name = name
        medication.timeOfDay = timeOfDay
        CoreDataStack.saveContext()
    }
    
    func markMedicationTaken(medication: Medication, wasTaken: Bool) {
        if wasTaken {
            TakenDate(date: Date(), medication: medication)
            if let index = notTakenMeds.firstIndex(of: medication) {
                notTakenMeds.remove(at: index)
                takenMeds.append(medication)
            }
        } else {
            let mutableTakenDates = medication.mutableSetValue(forKey: "takenDates")
            
            if let takenDate = (mutableTakenDates as? Set<TakenDate>)?.first(where: {takenDate in
                guard let date = takenDate.date else {return false}
                
                return Calendar.current.isDate(date, inSameDayAs: Date())
            }) {
                mutableTakenDates.remove(takenDate)
                if let index = takenMeds.firstIndex(of: medication) {
                    takenMeds.remove(at: index)
                    notTakenMeds.append(medication)
                }
            }
            
        }
        CoreDataStack.saveContext()
    }
    
    func deleteMedication(medication: Medication, wasTaken: Bool) {
        
    }
}
