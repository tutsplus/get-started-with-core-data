//
//  Quiz+CoreDataProperties.swift
//  PubQuizzer
//
//  Created by Envato Tuts+ on 26/05/16.
//  Copyright © 2016 Markus Mühlberger. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Quiz {

    @NSManaged var name: String?
    @NSManaged var date: NSDate?
    @NSManaged var questions: NSOrderedSet?

}
