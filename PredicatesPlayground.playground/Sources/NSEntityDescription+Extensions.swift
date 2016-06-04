import CoreData

extension NSEntityDescription {
    public convenience init<A : NSManagedObject>(klass: A.Type, name: String) {
        self.init()
        self.managedObjectClassName = NSStringFromClass(klass) as String
        self.name = name
    }
    
    public func addProperty(property: NSPropertyDescription) {
        var props = properties
        props.append(property)
        properties = props
    }
    
    public func createOneToOneRelationTo(target: NSEntityDescription, to: String, from: String?) {
        let relation = NSRelationshipDescription.toOne(to, destinationEntity: target)
        if let fromName = from {
            let inverse = NSRelationshipDescription.toOne(fromName, destinationEntity: self)
            relation.inverseRelationship = inverse
            inverse.inverseRelationship = relation
            target.addProperty(inverse)
        }
        self.addProperty(relation)
    }
    
    public func createOneToManyRelationTo(target: NSEntityDescription, to: String, from: String?) {
        let relation = NSRelationshipDescription.toMany(to, destinationEntity: target)
        if let fromName = from {
            let inverse = NSRelationshipDescription.toOne(fromName, destinationEntity: self)
            relation.inverseRelationship = inverse
            inverse.inverseRelationship = relation
            target.addProperty(inverse)
        }
        self.addProperty(relation)
    }
}

