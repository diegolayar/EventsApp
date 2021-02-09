import Foundation
import UIKit

extension Events: UITableViewDataSource, UITableViewDelegate,  UISearchBarDelegate {
    
    func setUpTable() {
        tableOfEvents.delegate = self
        tableOfEvents.dataSource = self
        tableOfEvents.register(SingleEvent.self, forCellReuseIdentifier: "SingleEvent")
        tableOfEvents.backgroundColor = .white
        tableOfEvents.separatorStyle = .none
    }
    
    func setUpSearchBar() {
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = .white
        searchBar.barTintColor = .white
        searchBar.searchTextField.layer.borderWidth = 0.5
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.searchTextField.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.font = UIFont(name:"AvenirNext-Regular", size: 15.0)
        searchBar.searchTextField.textColor = .black
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = "Search for an event..."
        searchBar.isTranslucent = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numOfCells = 0;
        if(showingLiked) {
            if(searching) { numOfCells = filtered.count }
            else { numOfCells = favoriteEvents.count }
        }
        else {
            if(searching) { numOfCells = filtered.count }
            else { numOfCells = events.count }
        }
        return numOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleEvent") as! SingleEvent
        var event: EventInfo
        if(showingLiked) {
            if(searching) { event = filtered[indexPath.row] }
            else { event = favoriteEvents[indexPath.row] }
        }
        else {
            if(searching) { event = filtered[indexPath.row] }
            else { event = events[indexPath.row] }
        }
        
        cell.set(event: event)
        cell.contentView.isUserInteractionEnabled = false
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventScreenSB = storyboard?.instantiateViewController(withIdentifier: "EventScreen") as? EventScreen
        var touchedEvent: EventInfo
        if(!showingLiked) {
            if(searching) { touchedEvent = filtered[indexPath.row]}
            else { touchedEvent = events[indexPath.row] }
            
        }
        else {
            if(searching) { touchedEvent = filtered[indexPath.row]}
            else { touchedEvent = favoriteEvents[indexPath.row] }
        }
        
        eventScreenSB?.titleString = touchedEvent.title
        eventScreenSB?.dateString = touchedEvent.date
        eventScreenSB?.locationString = touchedEvent.location
        eventScreenSB?.imageURL = touchedEvent.imageURL
        eventScreenSB?.ticketsURL = touchedEvent.ticketsURL
        eventScreenSB?.id = touchedEvent.id

        self.navigationController?.pushViewController(eventScreenSB!, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        searching = true
        if(showingLiked) { filtered = favoriteEvents.filter{$0.title.prefix(20).uppercased().contains(textSearched.uppercased())} }
        else { filtered = events.filter{$0.title.prefix(20).uppercased().contains(textSearched.uppercased())} }
        if(textSearched=="") { filtered = events }
        tableOfEvents.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        view.endEditing(true)
        tableOfEvents.reloadData()
    }
    

}
