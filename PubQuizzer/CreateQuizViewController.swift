//
//  CreateQuizViewController.swift
//  PubQuizzer
//
//  Created by Markus Mühlberger on 14.05.16.
//  Copyright © 2016 Markus Mühlberger. All rights reserved.
//

import UIKit
import CoreData

class CreateQuizViewController: UIViewController, CoreDataStackable {
    @IBOutlet var nameField : UITextField!
    @IBOutlet var dateField : UITextField!
    var dateValue = NSDate ()
    let dateFormatter = NSDateFormatter()
    
    @IBOutlet var datePicker : UIDatePicker!

    internal var coreDataStack : CoreDataStack?
    internal var quiz : Quiz?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let q = quiz {
            nameField.text = q.name
            if let d = q.date {
                dateValue = d
            }
        }
        
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .NoStyle
        
        dateField.inputView = datePicker
        dateField.text = dateFormatter.stringFromDate(dateValue)
        
        nameField.becomeFirstResponder()
    }
    
    @IBAction func saveQuiz(sender: AnyObject) {
        let moc = coreDataStack!.mainQueueContext

        if self.quiz == nil {
            moc.performBlockAndWait {
                let description = NSEntityDescription.entityForName("Quiz", inManagedObjectContext: moc)
                self.quiz = Quiz(entity: description!, insertIntoManagedObjectContext: moc)
            }
        }

        quiz!.name = self.nameField.text!
        quiz!.date = self.dateValue

        moc.performBlock {
            try! moc.save()
        }

        dismissModal(self)
    }
    
    @IBAction func dismissModal(sender: AnyObject) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func dateValueChanged(picker: UIDatePicker) {
        dateValue = picker.date
        dateField.text = dateFormatter.stringFromDate(dateValue)
    }
    
    @IBAction func focusOnDateField(sender: AnyObject) {
        dateField.becomeFirstResponder()
    }
}