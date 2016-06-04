//
//  QuestionToQuestion2Policy.swift
//  PubQuizzer
//
//  Created by Envato Tuts+ on 04/06/16.
//  Copyright © 2016 Markus Mühlberger. All rights reserved.
//

import CoreData

class QuestionToQuestion2Policy : NSEntityMigrationPolicy {
    override func createDestinationInstancesForSourceInstance(sInstance: NSManagedObject, entityMapping mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        try super.createDestinationInstancesForSourceInstance(sInstance, entityMapping: mapping, manager: manager)


        let question = manager.destinationInstancesForEntityMappingNamed(mapping.name, sourceInstances: [sInstance]).first!
        let quiz = sInstance.valueForKey("quiz")
        let quizQuestions = quiz!.valueForKey("quiz.questions") as! NSOrderedSet
        question.setValue(quizQuestions.indexOfObject(sInstance), forKey: "index")
    }
}