//
//  QuizTableViewController.swift
//  PubQuizzer
//
//  Created by Markus Mühlberger on 14.05.16.
//  Copyright © 2016 Markus Mühlberger. All rights reserved.
//

import UIKit
import CoreData

class QuizTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    internal var coreDataStack : CoreDataStack?

    let dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .NoStyle
    }

    override func viewWillAppear(animated: Bool) {
        self.initializeFetchedResultsController()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
         
        configureCell(cell, indexPath: indexPath)
         
        return cell
    }

    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let quiz = fetchedResultsController.objectAtIndexPath(indexPath) as! Quiz

        cell.textLabel!.text = quiz.name
        if let date = quiz.date {
            cell.detailTextLabel!.text = dateFormatter.stringFromDate(date)
        }
    }
    
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
         // Return false if you do not want the specified item to be editable.
         return true
     }
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
     }
     */

    // MARK: - Core Data Integration
    
    var fetchedResultsController : NSFetchedResultsController!
    func initializeFetchedResultsController() {
        let request = NSFetchRequest(entityName: "Quiz")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStack!.mainQueueContext, sectionNameKeyPath: nil, cacheName: "quizCache")
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




























