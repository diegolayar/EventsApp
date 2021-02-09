import Foundation
import CoreData


extension SavedEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedEvent> {
        return NSFetchRequest<SavedEvent>(entityName: "SavedEvent")
    }

    @NSManaged public var title: String?
    @NSManaged public var id: Int64
    @NSManaged public var imageURL: String?
    @NSManaged public var ticketsURL: String?
    @NSManaged public var date: String?
    @NSManaged public var location: String?
    @NSManaged public var popularity: Double
}

extension SavedEvent : Identifiable {

}
