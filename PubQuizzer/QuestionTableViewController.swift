//
//  QuestionTableViewController.swift
//  PubQuizzer
//
//  Created by Markus Mühlberger on 14.05.16.
//  Copyright © 2016 Markus Mühlberger. All rights reserved.
//

import UIKit
import CoreData

class QuestionTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, CoreDataStackable {

    internal var coreDataStack : CoreDataStack?
    internal var quiz : Quiz?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = quiz?.name

        self.clearsSelectionOnViewWillAppear = false

        self.toolbarItems = [self.editButtonItem()]
        self.navigationController?.toolbarHidden = false

        self.tableView.allowsSelectionDuringEditing = true
    }

    override func viewWillAppear(animated: Bool) {
        initializeFetchedResultsController()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = fetchedResultsController.sections! as [NSFetchedResultsSectionInfo]
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("QuestionCell", forIndexPath: indexPath)

        configureCell(cell, indexPath: indexPath)

        return cell
    }

    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let question = fetchedResultsController.objectAtIndexPath(indexPath) as! Question

        cell.textLabel!.text = "\(Int(question.index!) + 1). \(question.question!)"
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        var questions = fetchedResultsController.fetchedObjects as! [Question]

        let question = questions.removeAtIndex(fromIndexPath.row)
        questions.insert(question, atIndex: toIndexPath.row)

        for question in questions {
            question.index = questions.indexOf(question)
        }

        let moc = coreDataStack!.mainQueueContext
        moc.performBlock {
            try! moc.save()
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.editing {
            performSegueWithIdentifier("CreateQuestionSegue", sender: fetchedResultsController.objectAtIndexPath(indexPath))
        }
    }

    // MARK: - Navigation

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return !(identifier == "QuestionDetailSegue" && tableView.editing)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "QuestionDetailSegue" {
            let controller = segue.destinationViewController as! QuestionDetailViewController
            controller.question = quiz!.questions!.objectAtIndex(tableView.indexPathForSelectedRow!.row) as? Question
            controller.quiz = self.quiz
        } else if segue.identifier == "CreateQuestionSegue" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! CreateQuestionViewController
            controller.coreDataStack = self.coreDataStack
            controller.quiz = self.quiz

            if tableView.editing {
                controller.question = quiz!.questions!.objectAtIndex(tableView.indexPathForSelectedRow!.row) as? Question
            }
        }
    }

    // MARK: - Core Data Integration

    var fetchedResultsController : NSFetchedResultsController!
    func initializeFetchedResultsController() {
        let request = NSFetchRequest(entityName: "Question")
        request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        request.predicate = NSPredicate(format: "quiz == %@", quiz!)
        request.returnsObjectsAsFaults = false
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStack!.mainQueueContext, sectionNameKeyPath: nil, cacheName: "\(quiz?.objectID)-QuestionsCache")
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize fetched results controller: \(error)")
        }
    }

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, indexPath: indexPath!)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}
