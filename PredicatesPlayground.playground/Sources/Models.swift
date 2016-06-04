import Foundation
import CoreData

public final class City : NSManagedObject {
    @NSManaged public var name : String
    @NSManaged public var inhabitants : Int32
    @NSManaged public var state : State?
    @NSManaged public var stateCapital : State?
    
    public var nameAndState : String {
        return "\(name), \(state!.abbreviation)"
    }
}

public class State : NSManagedObject {
    @NSManaged public var name : String
    @NSManaged public var abbreviation : String
    @NSManaged public var cities : Set<City>
    @NSManaged public var capital : City
}

public func createDataModel() -> NSManagedObjectModel {
    return NSManagedObjectModel() {
        let city = NSEntityDescription(klass: City.self, name: "City")
        city.addProperty(NSAttributeDescription.string("name"))
        city.addProperty(NSAttributeDescription.string("zipCode", optional: true))
        city.addProperty(NSAttributeDescription.number("inhabitants", defaultValue: 0))
        
        let state = NSEntityDescription(klass: State.self, name: "State")
        state.addProperty(NSAttributeDescription.string("name"))
        state.addProperty(NSAttributeDescription.string("abbreviation"))
        
        state.createOneToManyRelationTo(city, to: "cities", from: "state")
        state.createOneToOneRelationTo(city, to: "capital", from: nil)
        
        return [city, state]
    }
}

private let states = [
    ["name": "Alabama",    "abbreviation": "AL", "capital": "Montgomery"],
    ["name": "New York",   "abbreviation": "NY", "capital": "Albany"],
    ["name": "Wyoming",    "abbreviation": "WY", "capital": "Cheyenne"],
    ["name": "California", "abbreviation": "CA", "capital": "Sacramento"],
    ["name": "Texas",      "abbreviation": "TX", "capital": "Austin"]
]

public func createCitiesAndStatesInContext(moc: NSManagedObjectContext) {
    do {
        for state in states {
            var allCities : [City] = []
            
            let stateObject = NSEntityDescription.insertNewObjectForEntityForName("State", inManagedObjectContext: moc) as! State
            stateObject.name = state["name"]!
            stateObject.abbreviation = state["abbreviation"]!
            
            let capitalObject = NSEntityDescription.insertNewObjectForEntityForName("City", inManagedObjectContext: moc) as! City
            allCities.append(capitalObject)
            capitalObject.name = state["capital"]!
            capitalObject.state = stateObject
            capitalObject.inhabitants = Int32(arc4random_uniform(1000000))

            stateObject.capital = capitalObject
            
            for _ in 0..<49 {
                let city = NSEntityDescription.insertNewObjectForEntityForName("City", inManagedObjectContext: moc) as! City
                allCities.append(city)
                city.name = generateCityName()
                city.state = stateObject
                city.inhabitants = Int32(arc4random_uniform(1000000))
            }
            
            stateObject.cities = Set(allCities)
        }
        
        try moc.save()
    } catch {
        fatalError("Couldn't save data: \(error)")
    }
}

private let cityPrefix = ["North", "East", "West", "South", "New", "Lake", "Port"]
private let citySuffix = ["town", "ton", "land", "ville", "berg", "burgh", "borough", "bury", "view", "port", "mouth", "stad", "furt", "chester", "mouth", "fort", "haven", "side", "shire"]
private let cityName = ["Abbott", "Abernathy", "Abshire", "Adams", "Altenwerth", "Anderson", "Ankunding", "Armstrong", "Auer", "Aufderhar", "Bahringer", "Bailey", "Balistreri", "Barrows", "Bartell", "Bartoletti", "Barton", "Bashirian", "Batz", "Bauch", "Baumbach", "Bayer", "Beahan", "Beatty", "Bechtelar", "Becker", "Bednar", "Beer", "Beier", "Berge", "Bergnaum", "Bergstrom", "Bernhard", "Bernier", "Bins", "Blanda", "Blick", "Block", "Bode", "Boehm", "Bogan", "Bogisich", "Borer", "Bosco", "Botsford", "Boyer", "Boyle", "Bradtke", "Brakus", "Braun", "Breitenberg", "Brekke", "Brown", "Bruen", "Buckridge", "Carroll", "Carter", "Cartwright", "Casper", "Cassin", "Champlin", "Christiansen", "Cole", "Collier", "Collins", "Conn", "Connelly", "Conroy", "Considine", "Corkery", "Cormier", "Corwin", "Cremin", "Crist", "Crona", "Cronin", "Crooks", "Cruickshank", "Cummerata", "Cummings", "Dach", "D'Amore", "Daniel", "Dare", "Daugherty", "Davis", "Deckow", "Denesik", "Dibbert", "Dickens", "Dicki", "Dickinson", "Dietrich", "Donnelly", "Dooley", "Douglas", "Doyle", "DuBuque", "Durgan", "Ebert", "Effertz", "Eichmann", "Emard", "Emmerich", "Erdman", "Ernser", "Fadel", "Fahey", "Farrell", "Fay", "Feeney", "Feest", "Feil", "Ferry", "Fisher", "Flatley", "Frami", "Franecki", "Friesen", "Fritsch", "Funk", "Gaylord", "Gerhold", "Gerlach", "Gibson", "Gislason", "Gleason", "Gleichner", "Glover", "Goldner", "Goodwin", "Gorczany", "Gottlieb", "Goyette", "Grady", "Graham", "Grant", "Green", "Greenfelder", "Greenholt", "Grimes", "Gulgowski", "Gusikowski", "Gutkowski", "Gutmann", "Haag", "Hackett", "Hagenes", "Hahn", "Haley", "Halvorson", "Hamill", "Hammes", "Hand", "Hane", "Hansen", "Harber", "Harris", "Hartmann", "Harvey", "Hauck", "Hayes", "Heaney", "Heathcote", "Hegmann", "Heidenreich", "Heller", "Herman", "Hermann", "Hermiston", "Herzog", "Hessel", "Hettinger", "Hickle", "Hilll", "Hills", "Hilpert", "Hintz", "Hirthe", "Hodkiewicz", "Hoeger", "Homenick", "Hoppe", "Howe", "Howell", "Hudson", "Huel", "Huels", "Hyatt", "Jacobi", "Jacobs", "Jacobson", "Jakubowski", "Jaskolski", "Jast", "Jenkins", "Jerde", "Johns", "Johnson", "Johnston", "Jones", "Kassulke", "Kautzer", "Keebler", "Keeling", "Kemmer", "Kerluke", "Kertzmann", "Kessler", "Kiehn", "Kihn", "Kilback", "King", "Kirlin", "Klein", "Kling", "Klocko", "Koch", "Koelpin", "Koepp", "Kohler", "Konopelski", "Koss", "Kovacek", "Kozey", "Krajcik", "Kreiger", "Kris", "Kshlerin", "Kub", "Kuhic", "Kuhlman", "Kuhn", "Kulas", "Kunde", "Kunze", "Kuphal", "Kutch", "Kuvalis", "Labadie", "Lakin", "Lang", "Langosh", "Langworth", "Larkin", "Larson", "Leannon", "Lebsack", "Ledner", "Leffler", "Legros", "Lehner", "Lemke", "Lesch", "Leuschke", "Lind", "Lindgren", "Littel", "Little", "Lockman", "Lowe", "Lubowitz", "Lueilwitz", "Luettgen", "Lynch", "Macejkovic", "MacGyver", "Maggio", "Mann", "Mante", "Marks", "Marquardt", "Marvin", "Mayer", "Mayert", "McClure", "McCullough", "McDermott", "McGlynn", "McKenzie", "McLaughlin", "Medhurst", "Mertz", "Metz", "Miller", "Mills", "Mitchell", "Moen", "Mohr", "Monahan", "Moore", "Morar", "Morissette", "Mosciski", "Mraz", "Mueller", "Muller", "Murazik", "Murphy", "Murray", "Nader", "Nicolas", "Nienow", "Nikolaus", "Nitzsche", "Nolan", "Oberbrunner", "O'Connell", "O'Conner", "O'Hara", "O'Keefe", "O'Kon", "Okuneva", "Olson", "Ondricka", "O'Reilly", "Orn", "Ortiz", "Osinski", "Pacocha", "Padberg", "Pagac", "Parisian", "Parker", "Paucek", "Pfannerstill", "Pfeffer", "Pollich", "Pouros", "Powlowski", "Predovic", "Price", "Prohaska", "Prosacco", "Purdy", "Quigley", "Quitzon", "Rath", "Ratke", "Rau", "Raynor", "Reichel", "Reichert", "Reilly", "Reinger", "Rempel", "Renner", "Reynolds", "Rice", "Rippin", "Ritchie", "Robel", "Roberts", "Rodriguez", "Rogahn", "Rohan", "Rolfson", "Romaguera", "Roob", "Rosenbaum", "Rowe", "Ruecker", "Runolfsdottir", "Runolfsson", "Runte", "Russel", "Rutherford", "Ryan", "Sanford", "Satterfield", "Sauer", "Sawayn", "Schaden", "Schaefer", "Schamberger", "Schiller", "Schimmel", "Schinner", "Schmeler", "Schmidt", "Schmitt", "Schneider", "Schoen", "Schowalter", "Schroeder", "Schulist", "Schultz", "Schumm", "Schuppe", "Schuster", "Senger", "Shanahan", "Shields", "Simonis", "Sipes", "Skiles", "Smith", "Smitham", "Spencer", "Spinka", "Sporer", "Stamm", "Stanton", "Stark", "Stehr", "Steuber", "Stiedemann", "Stokes", "Stoltenberg", "Stracke", "Streich", "Stroman", "Strosin", "Swaniawski", "Swift", "Terry", "Thiel", "Thompson", "Tillman", "Torp", "Torphy", "Towne", "Toy", "Trantow", "Tremblay", "Treutel", "Tromp", "Turcotte", "Turner", "Ullrich", "Upton", "Vandervort", "Veum", "Volkman", "Von", "VonRueden", "Waelchi", "Walker", "Walsh", "Walter", "Ward", "Waters", "Watsica", "Weber", "Wehner", "Weimann", "Weissnat", "Welch", "West", "White", "Wiegand", "Wilderman", "Wilkinson", "Will", "Williamson", "Willms", "Windler", "Wintheiser", "Wisoky", "Wisozk", "Witting", "Wiza", "Wolf", "Wolff", "Wuckert", "Wunsch", "Wyman", "Yost", "Yundt", "Zboncak", "Zemlak", "Ziemann", "Zieme", "Zulauf"]

private func generateCityName() -> String {
    switch(arc4random_uniform(4) % 4) {
    case 0:
        return "\(cityPrefix.randomElement) \(cityName.randomElement) \(citySuffix.randomElement)"
    case 1:
        return "\(cityName.randomElement) \(citySuffix.randomElement)"
    case 2:
        return "\(cityPrefix.randomElement) \(cityName.randomElement)"
    default:
        return cityName.randomElement
    }
}

extension Array {
    public var randomElement: Generator.Element {
        let offset = arc4random_uniform(UInt32(count))
        let idx = startIndex.advancedBy(Int(offset))
        return self[idx]
    }
}