import CoreData

extension NSAttributeDescription {
    public static func number(name: String, defaultValue: Int32? = nil, indexed: Bool? = nil, optional: Bool? = false) -> NSAttributeDescription {
        let attr = NSAttributeDescription()
        attr.name = name
        attr.attributeType = .Integer32AttributeType
        attr.setIndexed(indexed, optional: optional, defaultValue: defaultValue.map {NSNumber(integer: Int($0))})
        return attr
    }
    
    public static func string(name: String, defaultValue: String? = nil, indexed: Bool? = nil, optional: Bool? = false) -> NSAttributeDescription {
        let attr = NSAttributeDescription()
        attr.name = name
        attr.attributeType = .StringAttributeType
        attr.setIndexed(indexed, optional: optional, defaultValue: defaultValue)
        return attr
    }
    
    private func setIndexed(indexed: Bool?, optional: Bool?, defaultValue: AnyObject?) {
        if let d: AnyObject = defaultValue {
            self.defaultValue = d
        }
        setIndexed(indexed, optional: optional)
    }
}

extension NSPropertyDescription {
    private func setIndexed(indexed: Bool?, optional: Bool?) {
        if let o = optional {
            self.optional = o
        }
        if let i = indexed {
            self.indexed = i
        }
    }
}