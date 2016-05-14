//
//  CreateQuizViewController.swift
//  PubQuizzer
//
//  Created by Markus Mühlberger on 14.05.16.
//  Copyright © 2016 Markus Mühlberger. All rights reserved.
//

import UIKit

class CreateQuizViewController: UIViewController {
    @IBOutlet var nameField : UITextField!
    @IBOutlet var dateField : UITextField!
    var dateValue = NSDate ()
    let dateFormatter = NSDateFormatter()
    
    @IBOutlet var datePicker : UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .NoStyle
        
        dateField.inputView = datePicker
        dateField.text = dateFormatter.stringFromDate(dateValue)
        
        nameField.becomeFirstResponder()
    }
    
    @IBAction func saveQuiz(sender: AnyObject) {
        // TODO: Save Quiz with Core Data
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