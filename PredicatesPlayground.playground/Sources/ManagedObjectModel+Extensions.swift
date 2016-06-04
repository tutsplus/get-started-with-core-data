import CoreData

extension NSManagedObjectModel {
    public convenience init(block: () -> [NSEntityDescription]) {
        self.init()
        entities = block()
    }
}