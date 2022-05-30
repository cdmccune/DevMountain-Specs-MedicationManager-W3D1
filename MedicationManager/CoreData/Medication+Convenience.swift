//
//  Medication+Convenience.swift
//  MedicationManager
//
//  Created by Curt McCune on 5/30/22.
//

import Foundation
import CoreData

extension Medication {
    @discardableResult convenience init(name: String, timeOfDay: Date, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.timeOfDay = timeOfDay
    }
}
