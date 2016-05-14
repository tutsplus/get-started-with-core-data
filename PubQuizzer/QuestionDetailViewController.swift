//
//  QuestionDetailViewController.swift
//  PubQuizzer
//
//  Created by Markus Mühlberger on 14.05.16.
//  Copyright © 2016 Markus Mühlberger. All rights reserved.
//

import UIKit

class QuestionDetailViewController: UIViewController {

    @IBOutlet var questionView : UITextView!
    @IBOutlet var answerView : UITextView!
    @IBOutlet var toggleAnswerButton : UIBarButtonItem!
    
    var shouldShowAnswer = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            shouldShowAnswer = appDelegate.shouldShowAnswer
        }
        
        setAnswerDisplay(shouldShowAnswer, sync: false)
    }

    @IBAction func toggleAnswer(sender: UIBarButtonItem) {
        setAnswerDisplay(!shouldShowAnswer)
    }
    
    func setAnswerDisplay(shouldShow: Bool, sync: Bool = true) {
        shouldShowAnswer = shouldShow
        
        if sync {
            if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                appDelegate.shouldShowAnswer = shouldShowAnswer
            }
        }
        
        toggleAnswerButton.title = "\(shouldShowAnswer ? "Hide" : "Show") Answer"
        answerView.hidden = !shouldShowAnswer
    }
}
