//
//  CreateQuestionViewController.swift
//  PubQuizzer
//
//  Created by Markus Mühlberger on 14.05.16.
//  Copyright © 2016 Markus Mühlberger. All rights reserved.
//

import UIKit
import CoreData

class CreateQuestionViewController: UIViewController, UITextFieldDelegate, CoreDataStackable {

    internal var coreDataStack : CoreDataStack?
    internal var quiz : Quiz?
    internal var question : Question?

    @IBOutlet var questionField : UITextView!
    @IBOutlet var answerField : UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let q = question {
            questionField.text = q.question
            answerField.text = q.answer
        }
        
        questionField.becomeFirstResponder()
    }
    
    @IBAction func saveQuestion(sender: AnyObject) {
        let moc = coreDataStack!.mainQueueContext

        if self.question == nil {
            moc.performBlockAndWait {
                let description = NSEntityDescription.entityForName("Question", inManagedObjectContext: moc)
                self.question = Question(entity: description!, insertIntoManagedObjectContext: moc)
            }

            question!.quiz = quiz
        }

        question!.question = questionField.text!
        question!.answer = answerField.text!

        moc.performBlock {
            try! moc.save()
        }

        dismissModal(self)
    }
    
    @IBAction func focusOnAnswerField(sender: AnyObject) {
        answerField.becomeFirstResponder()
    }
    
    @IBAction func dismissModal(sender: AnyObject) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == questionField {
            // TODO: Store question
        } else if textField == answerField {
            // TODO: Store answer
        }
    }
}
