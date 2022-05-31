//
//  MoodSurvey+Convenience.swift
//  MedicationManager
//
//  Created by Curt McCune on 5/31/22.
//

import Foundation
import CoreData

extension MoodSurvey {
    @discardableResult convenience init(mentalState:String, date:Date, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context:context)
        self.mentalState = mentalState
        self.date = date
    }
}
