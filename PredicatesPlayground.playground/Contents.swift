import UIKit
import CoreData

let model = createDataModel()
let moc = NSManagedObjectContext(model: model)
createCitiesAndStatesInContext(moc)

let allCities = try! moc.executeFetchRequest(NSFetchRequest(entityName: "City")) as! [City]
let allStates = try! moc.executeFetchRequest(NSFetchRequest(entityName: "State")) as! [State]

func allCitiesMatchingPredicate(predicate: NSPredicate) -> [City] {
    return allCities.filterWithPredicate(predicate)
}

func allStatesMatchingPredicate(predicate: NSPredicate) -> [State] {
    return allStates.filterWithPredicate(predicate)
}

// Let's play:

allCities.count

let inhabitantsPredicate = NSPredicate(format: "%K BETWEEN {%ld, %ld}", "inhabitants", 100000, 500000)
let cityNamePredicate = NSPredicate(format: "%K BEGINSWITH[c] %@", "name", "A")
let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [inhabitantsPredicate, cityNamePredicate])

if let city = allCitiesMatchingPredicate(predicate).first {
    "\(city.name): \(city.inhabitants)"
}

let statePredicate = NSPredicate(format: "state.abbreviation = %@", "NY")
if let city = allCitiesMatchingPredicate(predicate).first {
    "\(city.nameAndState): \(city.inhabitants)"
}

let citiesPredicate = NSPredicate(format: "(SUBQUERY(cities, $x, $x.inhabitants > %lu).@count == 0)", 975000)
if let state = allStatesMatchingPredicate(citiesPredicate).first {
    "\(state.name)"
}

let specificState = NSPredicate(format: "state == %@", allStates.first!)
allCitiesMatchingPredicate(specificState).count