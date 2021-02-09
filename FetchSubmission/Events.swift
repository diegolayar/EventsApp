import Foundation
import UIKit
import CoreData

class Events: UIViewController {
    
    // URL and my client
    
    final private let url = "https://api.seatgeek.com/2/events/"
    final private let client = "?client_id=MjE1MjA0MDV8MTYxMTg4NDkwOC4yODY0OTgz"
    
    // Context for CoreData
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var tableOfEvents: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterBy: UIStackView!
   
    var events: [EventInfo] = []        // Main list of all events gotten from the API
    var filtered: [EventInfo] = []      // List that displays based on the search bar input
    var ids: [String] = []              // List of  IDs from all events on the API

    var showingLiked = false            // Toggles filtering by liked
    let liked = UIButton()              // Toggles showingLiked

    // Decides which array fills the tableview depending on if the user is using the search bar
    
    var searching = false {
        didSet {
            if(searching) { searchBar.setShowsCancelButton(true, animated: true) }
            else {searchBar.setShowsCancelButton(false, animated: true) }
        }
    }
   
    // Get the ID of each child from /events on the API
    
    func fillTable(completionHandler: @escaping ([String])  -> Void) {
        let eventsURL = URL(string: "https://api.seatgeek.com/2/events?per_page=250&client_id=MjE1MjA0MDV8MTYxMTg4NDkwOC4yODY0OTgz")!
        URLSession.shared.dataTask(with: eventsURL) { data,response,error in
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(Result.self, from: data)
                for item in decodedData.events {
                    self.getInfo(id: String(item.id)) { (event) in
                        self.events.append(event)
                    }
                }
                completionHandler(self.ids)
            }
            catch {  return  }
        }.resume()
    }
    
    // Get the information of each event according to its ID gotten from fillTable
    
    func getInfo(id: String, completionHandler: @escaping (EventInfo)  -> Void) {
        let finalURL = URL(string: url + id + client)!
        URLSession.shared.dataTask(with: finalURL) {data,response,error in
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(ResultIndividual.self, from: data)
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                DispatchQueue.main.async {
                    let newEvent = EventInfo(json: json)
                    for item in decodedData.performers { newEvent.imageURL = item.image }
                    self.tableOfEvents.reloadData()
                    completionHandler(newEvent)
                }
            }
            catch let error { print(error) }
            
        }.resume()
    }
    
    
    func setUpFilterBar() {
        
        // Formatting the filterby bar
        
        filterBy.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17).isActive = true
        filterBy.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17).isActive = true
        filterBy.heightAnchor.constraint(equalToConstant: 50).isActive = true
        filterBy.translatesAutoresizingMaskIntoConstraints = false
        filterBy.alignment = .center
        filterBy.distribution = .fillProportionally
        filterBy.spacing = 0
        filterBy.backgroundColor = .white
        
        // Formatting the filterby title

        let filterByLabel = UILabel()
        filterBy.addArrangedSubview(filterByLabel)
        filterByLabel.widthAnchor.constraint(equalToConstant: 75).isActive = true
        filterByLabel.translatesAutoresizingMaskIntoConstraints = false;
        filterByLabel.font = UIFont(name:"AvenirNext-Regular", size: 15.0)
        filterByLabel.text = "Filter By:"
        filterByLabel.textColor = .black
        filterByLabel.backgroundColor = .white
        
        // Formatting the filter by liked button
        
        filterBy.addArrangedSubview(liked)
        liked.addTarget(self, action: #selector(toggleLikedVideos), for: .touchUpInside)
        liked.startAnimatingPressActions()
        liked.widthAnchor.constraint(equalToConstant: 75).isActive = true
        liked.translatesAutoresizingMaskIntoConstraints = false
        liked.setTitle("Liked", for: .normal)
        liked.backgroundColor = .white
        liked.setTitleColor(.black, for: .normal)
        liked.titleLabel?.font = UIFont(name:"AvenirNext-Regular", size: 15.0)
        liked.layer.cornerRadius = 10
        liked.clipsToBounds = true
        liked.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        liked.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        liked.layer.borderWidth = 0.5
        
        // Helper to make the button stick to the left because it was stubborn and didn't want to behave

        let empty = UIView()
        filterBy.addArrangedSubview(empty)
        filterBy.bringSubviewToFront(empty)
        empty.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }

    // Formatting the navbar

    func styleNavigationBar() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let navView = UIStackView()
        let width = view.frame.width
        let eventsLabel = UILabel()
        
        navigationItem.titleView = navView
        
        navView.addArrangedSubview(eventsLabel)
        navView.backgroundColor = .white
        navView.frame = .init(x: 0, y: 0, width: width, height: 300)

        eventsLabel.font = UIFont(name:"AvenirNext-Bold", size: 35.0)
        eventsLabel.translatesAutoresizingMaskIntoConstraints =  false
        eventsLabel.text = "Events"
        eventsLabel.textColor = .black
        
    }
    
    // Show the liked videos
    
    @objc func toggleLikedVideos() {
        if(!showingLiked) {
            showingLiked = true
            liked.backgroundColor = .systemPink
            liked.setTitleColor(.white, for: .normal)
        }
        else {
            showingLiked = false
            liked.backgroundColor = .white
            liked.setTitleColor(.black, for: .normal)
        }
        tableOfEvents.reloadData()

    }
    
    // Update the liked events on CoreData

    func updateLiked() {
        do {
            savedEvents = try context.fetch(SavedEvent.fetchRequest())
            favoriteEventsSet = []
            var temp: [EventInfo] = []
            for event in savedEvents {
                let favoriteEvent = EventInfo(title: event.title!, location: event.location!, date: event.date!, id: Int(event.id), imageURL: event.imageURL!, ticketsURL: event.ticketsURL!, popularity: event.popularity)
                temp.append(favoriteEvent)
                favoriteEventsSet.insert(favoriteEvent.id)
            }
            favoriteEvents = temp
        }
        catch {
            print("Error on UpdateLiked")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpTable()
        setUpSearchBar()
        setUpFilterBar()
        styleNavigationBar()
        fillTable { fill in
            DispatchQueue.main.async {
                self.tableOfEvents.reloadData()
            }
        }
        updateLiked()
    }
}
