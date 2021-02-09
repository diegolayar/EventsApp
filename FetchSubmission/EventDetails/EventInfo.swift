import Foundation
import UIKit
import CoreData

class EventInfo {
    var title: String               // Title of the event
    var venue: [String:Any]         // Parent of location in the JSON response, serves as a helper
    var location: String            // Location of the event
    var date: String                // Date and time of event
    var id: Int                     // ID of the event
    var imageURL: String            // URL of image as string
    var popularity: Double          // Popularity of the event from 0 to 1
    var ticketsURL: String          // Link to the site to buy tickets
    
    // Heart styles
    
    let filled = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
    let empty = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        
    init(json: [String: Any]) {
        id = json["id"] as? Int ?? -1
        title = json["title"] as? String ?? "Not Able to Catch Title"
        venue = json["venue"] as! [String:Any]
        location = venue["display_location"] as? String ?? "Not Able to Catch Location"
        date = json["datetime_utc"] as? String ?? "Not Able to Catch Date"
        ticketsURL = json["url"] as? String ?? "Not Able to Catch URL"
        popularity = json["popularity"] as? Double ?? 0.0
        imageURL = ""
        formatDate()
    }
    
    init(title: String,  location: String, date: String, id: Int, imageURL: String, ticketsURL: String, popularity: Double)  {
        self.title = title
        self.location = location
        self.date = date
        self.id = id
        self.imageURL = imageURL
        self.ticketsURL = ticketsURL
        venue = .init()
        self.popularity = popularity
    }

    // Format date to be easily understandable
    
    func formatDate() {
        let format = DateFormatter()
        format.locale = Locale(identifier: "en_US_POSIX")
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let newDate = format.date(from: date) {
            let convert = DateFormatter()
            convert.dateFormat = "MMM dd, y - HH:mm"
            date = convert.string(from: newDate)
        }
    }
}
