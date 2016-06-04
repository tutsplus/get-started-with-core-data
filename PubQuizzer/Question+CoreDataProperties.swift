//
//  Question+CoreDataProperties.swift
//  PubQuizzer
//
//  Created by Envato Tuts+ on 04/06/16.
//  Copyright © 2016 Markus Mühlberger. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Question {

    @NSManaged var answer: String?
    @NSManaged var question: String?
    @NSManaged var index: NSNumber?
    @NSManaged var quiz: Quiz?

}
