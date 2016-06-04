import CoreData

extension NSManagedObjectContext {
    public convenience init(model: NSManagedObjectModel) {
        self.init(concurrencyType: .MainQueueConcurrencyType)
        let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! psc.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
        persistentStoreCoordinator = psc
    }
}

