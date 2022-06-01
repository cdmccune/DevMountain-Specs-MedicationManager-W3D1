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
    let notificationScheduler = NotificationScheduler()
    
    private init() {}
    
    private lazy var fetchRequest: NSFetchRequest<Medication> = {
        let request = NSFetchRequest<Medication>(entityName: Strings.medicationEntityType)
        request.predicate = NSPredicate(value:true)
        let sortDescriptor = NSSortDescriptor(key: "timeOfDay", ascending: true)
        request.sortDescriptors = [sortDescriptor]
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
        
        //Schedule Notification
        notificationScheduler.scheduleNotifications(for: medication)
    }
    
    func fetchMedications() {
        
        let medications = (try? CoreDataStack.context.fetch(self.fetchRequest)) ?? []
        
        takenMeds = medications.filter {$0.wasTakenToday()}
        notTakenMeds = medications.filter { !$0.wasTakenToday()}
    }
    
    func updateMedication(medication: Medication, name:String, timeOfDay:Date) {
        medication.name = name
        medication.timeOfDay = timeOfDay
        CoreDataStack.saveContext()
        
        notificationScheduler.cancelNotifications(for: medication)
        notificationScheduler.scheduleNotifications(for: medication)
    }
    
    func markMedicationTaken(medication: Medication, wasTaken: Bool) {
        if wasTaken {
            TakenDate(date: Date(), medication: medication)
            if let index = notTakenMeds.firstIndex(of: medication) {
                notTakenMeds.remove(at: index)
                takenMeds.append(medication)
            }
        } else {
            let mutableTakenDates = medication.mutableSetValue(forKey: Strings.takenDatesKey)
            
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
    
    func markMedicationTaken(withID id: String) {
        guard let medication = notTakenMeds.first(where: {$0.id == id})
        else {return}
        
        markMedicationTaken(medication: medication, wasTaken: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Strings.medicationReminderTakenButtonTapped),object: self)
    }
    
    func deleteMedication(_ medication: Medication) {
        
        
        if let index = notTakenMeds.firstIndex(of: medication) {
            notTakenMeds.remove(at: index)
        } else if let index = takenMeds.firstIndex(of: medication) {
            takenMeds.remove(at: index)
        }
        
        CoreDataStack.context.delete(medication)
        CoreDataStack.saveContext()
        notificationScheduler.cancelNotifications(for: medication)
    }
    
    func sortMeds() {
//        let sortDescriptor = NSSortDescriptor(key: "timeOfDay", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let medications = (try? CoreDataStack.context.fetch(self.fetchRequest)) ?? []
        
        takenMeds = medications.filter {$0.wasTakenToday()}
        notTakenMeds = medications.filter { !$0.wasTakenToday()}
        
    }
}
