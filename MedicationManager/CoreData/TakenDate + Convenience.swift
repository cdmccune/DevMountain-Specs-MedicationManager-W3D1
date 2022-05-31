//
//  TakenDate + Convenience.swift
//  MedicationManager
//
//  Created by Curt McCune on 5/31/22.
//

import Foundation
import CoreData

extension TakenDate {
    @discardableResult convenience init (date:Date, medication:Medication, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context:context)
        self.date = date
        self.medication = medication
    }
}
