//
//  CreateQuestionViewController.swift
//  PubQuizzer
//
//  Created by Markus Mühlberger on 14.05.16.
//  Copyright © 2016 Markus Mühlberger. All rights reserved.
//

import UIKit

class CreateQuestionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var questionField : UITextView!
    @IBOutlet var answerField : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionField.becomeFirstResponder()
    }
    
    @IBAction func saveQuestion(sender: AnyObject) {
        // TODO: Save Question with Core Data
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
