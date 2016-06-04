import CoreData

extension NSRelationshipDescription {
    public static func toOne(name: String, destinationEntity: NSEntityDescription?) -> NSRelationshipDescription {
        let relation = NSRelationshipDescription()
        relation.name = name
        relation.destinationEntity = destinationEntity
        relation.minCount = 1
        relation.maxCount = 1
        return relation
    }
    
    public static func toMany(name: String, destinationEntity: NSEntityDescription?) -> NSRelationshipDescription {
        let relation = NSRelationshipDescription()
        relation.name = name
        relation.destinationEntity = destinationEntity
        relation.minCount = 0
        relation.maxCount = Int.max
        return relation
    }
}

