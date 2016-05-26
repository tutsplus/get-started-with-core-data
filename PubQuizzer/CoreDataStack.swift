//
//  CoreDataStack.swift
//  PubQuizzer
//
//  Created by Envato Tuts+ on 26/05/16.
//  Copyright © 2016 Markus Mühlberger. All rights reserved.
//

import Foundation
import CoreData

public final class CoreDataStack {
    public private(set) lazy var persistingQueueContext : NSManagedObjectContext = {
        return self.setupPersistingQueueContext()
    }()
    private func setupPersistingQueueContext() -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        managedObjectContext.name = "Persisting Private Queue Context"
        return managedObjectContext
    }

    public private(set) lazy var mainQueueContext : NSManagedObjectContext = {
       return self.setupMainQueueContext()
    }()
    private func setupMainQueueContext() -> NSManagedObjectContext {
        var managedObjectContext : NSManagedObjectContext!
        let setup : () -> Void = {
            managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            managedObjectContext.parentContext = self.persistingQueueContext
        }
        
        if !NSThread.isMainThread() {
            dispatch_sync(dispatch_get_main_queue()) {
                setup()
            }
        } else {
            setup()
        }
        
        return managedObjectContext
    }
    
    private var persistentStoreCoordinator : NSPersistentStoreCoordinator {
        didSet {
            self.persistingQueueContext = setupPersistingQueueContext()
            persistingQueueContext.persistentStoreCoordinator = persistentStoreCoordinator
            self.mainQueueContext = setupMainQueueContext()
        }
    }
    public var managedObjectModel : NSManagedObjectModel {
        get {
            return NSBundle.mainBundle().managedObjectModel()
        }
    }
    
    public static func createSQLiteStack() -> CoreDataStack {
        let mom = NSBundle.mainBundle().managedObjectModel()
        let storeURL = NSURL(string: "PubQuizzer.sqlite", relativeToURL: documentsDirectory)
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: mom)
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        } catch {
            fatalError("Couldn't create store at \(storeURL): \(error)")
        }
        return CoreDataStack(persistentStoreCoordinator: coordinator, storeType: .SQLite(storeURL: storeURL!))
    }
    
    public static func createInMemoryStack() -> CoreDataStack {
        let mom = NSBundle.mainBundle().managedObjectModel()
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: mom)
        do {
            try coordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
        } catch {
            fatalError("Couldn't create in-memory store: \(error)")
        }
        return CoreDataStack(persistentStoreCoordinator: coordinator, storeType: .InMemory)
    }
    
    private enum StoreType {
        case InMemory
        case SQLite(storeURL: NSURL)
    }
    private let storeType: StoreType
    
    private init(persistentStoreCoordinator: NSPersistentStoreCoordinator, storeType: StoreType) {
        self.storeType = storeType
        self.persistentStoreCoordinator = persistentStoreCoordinator
        persistingQueueContext.persistentStoreCoordinator = persistentStoreCoordinator
    }
}

public extension CoreDataStack {
    public func resetStore() {
        switch self.storeType {
        case .InMemory:
            do {
                guard let store = self.persistentStoreCoordinator.persistentStores.first else {
                    fatalError("No in-memory store found")
                }
                try self.persistentStoreCoordinator.removePersistentStore(store)
                try self.persistentStoreCoordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
            } catch {
                fatalError("Couldn't reset in-memory store: \(error)")
            }
        case .SQLite(let storeURL):
            let oldCoordinator = self.persistentStoreCoordinator
            let mom = self.managedObjectModel
            guard oldCoordinator.persistentStoreForURL(storeURL) != nil else {
                fatalError("No SQLite store fount at \(storeURL)")
            }
            
            do {
                try oldCoordinator.destroyPersistentStoreAtURL(storeURL, withType: NSSQLiteStoreType, options: nil)
            } catch {
                fatalError("Couldn't destroy store at \(storeURL): \(error)")
            }
            
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: mom)
            do {
                try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
            } catch {
                fatalError("Couldn't re-create store at \(storeURL): \(error)")
            }
            self.persistentStoreCoordinator = coordinator
        }
    }
}

private extension CoreDataStack {
    private static var documentsDirectory : NSURL? {
        get {
            let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            return urls[urls.count - 1]
        }
    }
}

private extension NSBundle {
    func managedObjectModel() -> NSManagedObjectModel {
        guard let url = URLForResource("PubQuizzer", withExtension: "momd"), let model = NSManagedObjectModel(contentsOfURL: url) else {
            preconditionFailure("The core data model wasn't found or is corrupted.")
        }
        return model
    }
}