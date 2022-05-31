//
//  MoodSurveyController.swift
//  MedicationManager
//
//  Created by Curt McCune on 5/31/22.
//

import Foundation
import CoreData

class MoodSurveyController {
    
    static let shared = MoodSurveyController()
    
    private lazy var fetchRequest: NSFetchRequest<MoodSurvey> = {
        let request = NSFetchRequest<MoodSurvey>(entityName: "MoodSurvey")
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let endOfToday = Calendar.current.date(byAdding: .day, value: 1, to: startOfToday) ?? Date()
        let afterPredicate = NSPredicate(format: "date > %@", startOfToday as NSDate)
        let beforePredicate = NSPredicate(format: "date < %@", endOfToday as NSDate)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [afterPredicate, beforePredicate])
        return request
    }()
    
    var todaysMoodSurvey: MoodSurvey?
    
    private init() {}
    
    //CRU
    
    private func createMoodSurvey(mentalState: String) {
        let moodSurvey = MoodSurvey(mentalState: mentalState, date: Date())
        todaysMoodSurvey = moodSurvey
        CoreDataStack.saveContext()
    }
    
    func fetchTodaysSurveys() -> MoodSurvey? {
        guard let todaysMoodSurvey = try? CoreDataStack.context.fetch(fetchRequest).first
        else {return nil}
        
        self.todaysMoodSurvey = todaysMoodSurvey
        return todaysMoodSurvey
        
    }
    
    private func update(newMentalState: String) {
        guard let todaysMoodSurvey = todaysMoodSurvey else {return}

        todaysMoodSurvey.mentalState = newMentalState
        CoreDataStack.saveContext()
    }
    
    func didTapMoodEmoji(_ emoji:String) {
        if todaysMoodSurvey != nil {
            update(newMentalState: emoji)
        } else {
            createMoodSurvey(mentalState: emoji)
        }
    }
}
