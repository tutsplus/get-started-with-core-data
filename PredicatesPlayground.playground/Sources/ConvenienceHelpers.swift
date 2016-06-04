import Foundation

extension SequenceType where Self.Generator.Element: AnyObject {
    public func filterWithPredicate(predicate: NSPredicate)  -> [Self.Generator.Element] {
        return filter { predicate.evaluateWithObject($0) }
    }
}