//
//  Quiz.swift
//  PubQuizzer
//
//  Created by Envato Tuts+ on 26/05/16.
//  Copyright © 2016 Markus Mühlberger. All rights reserved.
//

import Foundation
import CoreData


class Quiz: NSManagedObject {

    @NSManaged private var primitiveDate : NSDate

    override func awakeFromInsert() {
        super.awakeFromInsert()

        primitiveDate = NSDate()
    }

}