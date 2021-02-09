import UIKit

//  Cell configuration and formatting

class SingleEvent: UITableViewCell {
    
    // Context for CoreData
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Heart styles and style for the flame
    
    let filled = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
    let empty = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
    let flame = UIImage(systemName: "flame", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))

    // Variables from the event to be shown on the cell
    
    var eventObject: EventInfo?
    let title = UILabel()
    let date = UILabel()
    let location = UILabel()
    let img = UIImageView()
    let maskedView = UIView()
    let infoBackground = UIView()
    let dateLocationParent = UIStackView()
    let likeButton = UIButton()
    let spicy = UIButton()
    var id: Int?
    var liked = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(title)
        addSubview(dateLocationParent)
        addSubview(img)
        addSubview(infoBackground)
        addSubview(likeButton)
        addSubview(maskedView)
        infoBackground.addSubview(spicy)
        configure()
    }
    
    required init?(coder: NSCoder) { fatalError("") }
    
    func set(event: EventInfo) {
        eventObject = event
        id = event.id
        title.text = event.title
        date.text = event.date
        location.text = event.location
        addLikeButton(event: event)
        
        // If event is in the favorited  set, it's heart is filled
        
        if(favoriteEventsSet.contains(id!)) {
            likeButton.setImage(filled, for: .normal)
            likeButton.tintColor = .systemPink
        }
        else {
            likeButton.setImage(empty, for: .normal)
            likeButton.tintColor = .white
        }
        
        // Just in case some image somehow passes and it's "null" on the API, set a placeholder
        
        if(event.imageURL != "null") { img.downloaded(from: URL(string: event.imageURL)!) }
        else { img.downloaded(from: URL(string: "https://www.allianceplast.com/wp-content/uploads/2017/11/no-image.png")!) }
    }
    
    func addLikeButton(event: EventInfo) {
        
        // Format the like button
        
        likeButton.startAnimatingPressActions()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        likeButton.addTarget(self, action: #selector(like), for: .touchUpInside)
        likeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        likeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        bringSubviewToFront(likeButton)
        
        // Format the fire icon if an event's popularity is equal to or higher than 0.75
        
        spicy.startAnimatingPressActions()
        spicy.translatesAutoresizingMaskIntoConstraints = false
        spicy.widthAnchor.constraint(equalToConstant: 20).isActive = true
        spicy.heightAnchor.constraint(equalToConstant: 20).isActive = true
        spicy.bottomAnchor.constraint(equalTo: date.bottomAnchor, constant: -2).isActive = true
        spicy.leadingAnchor.constraint(equalTo: date.trailingAnchor, constant: 10).isActive = true
        spicy.setImage(flame, for: .normal)
        spicy.tintColor = .black
        spicy.alpha = 0
        bringSubviewToFront(spicy)
    
        if(event.popularity >= 0.75) {  spicy.alpha = 1 }
    }
    
    // Like an event
    
    @objc func like() {
        
        if(!favoriteEventsSet.contains(id!)) {
            
            let saveEvent = SavedEvent(context: context)
            saveEvent.title = eventObject?.title
            saveEvent.location = eventObject?.location
            saveEvent.date = eventObject?.date
            saveEvent.id = Int64(exactly: eventObject!.id)!
            saveEvent.imageURL = eventObject?.imageURL
            saveEvent.ticketsURL = eventObject?.ticketsURL
            
            do { try context.save() }
            catch { print("Couln't save") }
            Events().updateLiked()
            
            likeButton.tintColor = .systemPink
            likeButton.setImage(filled, for: .normal)
        }
        else {
            var getIndex = 0
            for i in 0..<savedEvents.count { if(savedEvents[i].id == self.id!) { getIndex = i } }
            context.delete(savedEvents[getIndex])

            do { try context.save() }
            catch { print("Couln't save") }
            Events().updateLiked()

            likeButton.tintColor = .white
            likeButton.setImage(empty, for: .normal)
        }
    }
    
    func configure() {
        
        // Formatting the white box on top of the image that holds the info
        
        infoBackground.backgroundColor = .white;
        infoBackground.translatesAutoresizingMaskIntoConstraints = false
        infoBackground.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        infoBackground.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        infoBackground.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        infoBackground.topAnchor.constraint(equalTo: bottomAnchor, constant: -105).isActive = true
        bringSubviewToFront(infoBackground)
        
        // Format the title
        
        title.textColor = .black
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        title.topAnchor.constraint(equalTo: infoBackground.topAnchor, constant: 10).isActive = true
        title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40).isActive = true
        title.font = UIFont(name:"AvenirNext-Regular", size: 18.0)
        title.numberOfLines = 2
        bringSubviewToFront(title)
        
        // Parent that ensures the formatting of the date and location is consistent
        
        dateLocationParent.translatesAutoresizingMaskIntoConstraints = false
        dateLocationParent.addArrangedSubview(location)
        dateLocationParent.addArrangedSubview(date)
        dateLocationParent.distribution = .fillProportionally
        dateLocationParent.alignment = .leading
        dateLocationParent.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        dateLocationParent.spacing = 10
        dateLocationParent.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5).isActive = true
        dateLocationParent.bottomAnchor.constraint(equalTo: title.bottomAnchor, constant: 25).isActive = true
        bringSubviewToFront(dateLocationParent)

        // Formatting the date
        
        date.textColor = .black
        date.translatesAutoresizingMaskIntoConstraints = false
        date.font = UIFont(name:"AvenirNext-Regular", size: 15.0)
        date.numberOfLines = 1
        bringSubviewToFront(date)

        // Formatting the  location
        
        location.textColor = .gray
        location.translatesAutoresizingMaskIntoConstraints = false
        location.font = UIFont(name:"AvenirNext-Regular", size: 15.0)
        location.numberOfLines = 1
        bringSubviewToFront(location)

        // Formatting the image
        
        img.translatesAutoresizingMaskIntoConstraints = false
        img.heightAnchor.constraint(equalToConstant: 300).isActive = true
        img.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        img.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        img.contentMode = .scaleToFill
        img.layer.masksToBounds = false;
        
        // Adding the black fading to the image

        let gradientMaskLayer = CAGradientLayer()
        let degrees:CGFloat = -180
        maskedView.backgroundColor = .black
        maskedView.alpha = 0.6
        maskedView.frame = CGRect(x: 0, y: 30, width: 414, height: 250)
        gradientMaskLayer.locations = [0.3, 1]
        maskedView.transform = CGAffineTransform(rotationAngle: degrees * CGFloat(Double.pi)/180);
        gradientMaskLayer.frame = maskedView.bounds
        gradientMaskLayer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        maskedView.layer.mask = gradientMaskLayer
    }
    
}
