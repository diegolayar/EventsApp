import UIKit
import Foundation

class EventScreen: UIViewController {
   
    // Context for CoreData to save and retrieve
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // Heart types for the like button
    
    let filled = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
    let empty = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
    
    // ID of the event to check if it's liked or not
    
    var id = 0
    
    // Image displayed
    
    let eventImage = UIImageView()
    var imageURL: String = ""
    
    //Title of the event
    
    let titulo = UILabel()
    var titleString: String = ""
    
    // Date of the event
    
    let eventDate = UILabel()
    var dateString: String = ""

    // Location of the event
    
    let eventLocation = UILabel()
    var locationString: String = ""
    
    //  White fade on the image
    
    let maskedView = UIView()
    
    // Buy tickets button
    
    let buyImage = UIImageView()
    let buyTickets = UIButton()
    var ticketsURL: String = ""
    
    // Like button (heart)
    
    let likeButton = UIButton()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(maskedView)
        view.addSubview(eventImage)
        view.addSubview(titulo)
        view.addSubview(eventDate)
        view.addSubview(eventLocation)
        view.addSubview(buyImage)
        view.addSubview(buyTickets)
        view.addSubview(likeButton)
        setInfo()
        formatInfo(view: view)
        formatBar()
    }
    
    func setInfo() {
        
        // Set the info displayed to the info passed by the row
        
        titulo.text = titleString
        eventDate.text = dateString
        eventLocation.text = locationString
    }
    
    func formatBar() {
        
        // Set up the format for the top title "Event"
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let navView = UIStackView()
        let width = view.frame.width
        let eventsLabel = UILabel()
        navigationItem.titleView = navView
        navView.addArrangedSubview(eventsLabel)
        eventsLabel.translatesAutoresizingMaskIntoConstraints =  false
        navView.frame = .init(x: 0, y: 0, width: width, height: 300)
        eventsLabel.font = UIFont(name:"AvenirNext-Bold", size: 35.0)
        eventsLabel.text = "Event"
        eventsLabel.textColor = .black
    }
    
    func formatInfo(view: UIView) {
        
        // Format image displayed
        
        eventImage.translatesAutoresizingMaskIntoConstraints = false
        eventImage.downloaded(from: URL(string: imageURL)!)
        eventImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive =  true
        eventImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        eventImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive =  true
        eventImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        // Format title of event displayed

        titulo.translatesAutoresizingMaskIntoConstraints = false
        titulo.topAnchor.constraint(equalTo: eventImage.bottomAnchor, constant: 30).isActive = true
        titulo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        titulo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        titulo.font = UIFont(name:"AvenirNext-Bold", size: 25.0)
        titulo.heightAnchor.constraint(equalToConstant: heightForLabel(text: titulo.text ?? "Error: Title Not Found", font: UIFont(name:"AvenirNext-Bold", size: 25.0) ?? UIFont(), width: 300)).isActive = true
        titulo.textColor = .black
        titulo.numberOfLines = 0;
        
        // Format date displayed
        
        eventDate.translatesAutoresizingMaskIntoConstraints = false
        eventDate.topAnchor.constraint(equalTo: titulo.bottomAnchor, constant: 20).isActive = true
        eventDate.bottomAnchor.constraint(equalTo: titulo.bottomAnchor, constant: 50).isActive = true
        eventDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        eventDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        eventDate.font = UIFont(name:"AvenirNext-Normal", size: 25.0)
        eventDate.textColor = .black
        eventDate.numberOfLines = 1;
        
        // Format location displayed

        eventLocation.translatesAutoresizingMaskIntoConstraints = false
        eventLocation.topAnchor.constraint(equalTo: eventDate.bottomAnchor, constant: 20).isActive = true
        eventLocation.bottomAnchor.constraint(equalTo: eventDate.bottomAnchor, constant: 50).isActive = true
        eventLocation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        eventLocation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        eventLocation.font = UIFont(name:"AvenirNext-Normal", size: 25.0)
        eventLocation.textColor = .gray
        eventLocation.numberOfLines = 1;
        
        // Format image background on the button for buying tickets, which depends on the image of the event
        
        buyImage.translatesAutoresizingMaskIntoConstraints = false
        buyImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        buyImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        buyImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        buyImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        buyImage.layer.cornerRadius = 20
        buyImage.clipsToBounds = true
        buyImage.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        buyImage.downloaded(from: URL(string: imageURL)!)

        // Format title of the buy tickets button

        buyTickets.translatesAutoresizingMaskIntoConstraints = false
        buyTickets.setTitleColor(.black, for: .normal)
        buyTickets.startAnimatingPressActions()
        buyTickets.backgroundColor = .none
        buyTickets.addTarget(self, action: #selector(sendToLink), for: .touchUpInside)
        buyTickets.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        buyTickets.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        buyTickets.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        buyTickets.heightAnchor.constraint(equalToConstant: 60).isActive = true
        buyTickets.titleLabel?.font = UIFont(name:"AvenirNext-DemiBold", size: 20.0)
        buyTickets.setTitleColor(.white, for: .normal)
        buyTickets.setTitle("Buy Tickets", for: .normal)

        // Blurring the image of the buy button for a modern feel

        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.bounds = buyImage.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        buyImage.addSubview(blurEffectView)
        buyImage.bringSubviewToFront(blurEffectView)
        buyImage.bringSubviewToFront(buyTickets)
        
        // Format white fading grid on the image

        let gradientMaskLayer = CAGradientLayer()
        let degrees: CGFloat = -180
        maskedView.translatesAutoresizingMaskIntoConstraints = false
        maskedView.backgroundColor = .white
        maskedView.frame = CGRect(x: 0, y: 200, width: 414, height: 200)
        maskedView.transform = CGAffineTransform(rotationAngle: degrees * CGFloat(Double.pi)/180);
        maskedView.layer.mask = gradientMaskLayer
        gradientMaskLayer.locations = [0, 1]
        gradientMaskLayer.frame = maskedView.bounds
        gradientMaskLayer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        view.bringSubviewToFront(maskedView)
        
        // Format the like button

        likeButton.startAnimatingPressActions()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        likeButton.addTarget(self, action: #selector(like), for: .touchUpInside)
        likeButton.topAnchor.constraint(equalTo: eventImage.topAnchor, constant: 20).isActive = true
        likeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        view.bringSubviewToFront(likeButton)

        // Setting up the heart form depending if an event is liked or not
        
        if(favoriteEventsSet.contains(id)) {
            likeButton.setImage(filled, for: .normal)
            likeButton.tintColor = .systemPink
        }
        else {
            likeButton.setImage(empty, for: .normal)
            likeButton.tintColor = .white
        }
    }
    
    // Function that decides how much space to give to the event title label
    
    func heightForLabel(text: String, font: UIFont, width: CGFloat) -> CGFloat {
       let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
       label.numberOfLines = 0
       label.lineBreakMode = NSLineBreakMode.byWordWrapping
       label.font = font
       label.text = text
       label.sizeToFit()
       return label.frame.height
    }
    
    // Opening the page to buy tickets
    
    @objc func sendToLink() {
        UIApplication.shared.open(URL(string: ticketsURL)!)
    }
    
    // Liking the event
    
    @objc func like() {
        if(!favoriteEventsSet.contains(id)) {
            
            let saveEvent = SavedEvent(context: context)
            saveEvent.title = titleString
            saveEvent.location = locationString
            saveEvent.date = dateString
            saveEvent.id = Int64(exactly: id)!
            saveEvent.imageURL = imageURL
            saveEvent.ticketsURL = ticketsURL
            
            do { try context.save() }
            catch { print("Couln't save") }
            Events().updateLiked()
            
            likeButton.tintColor = .systemPink
            likeButton.setImage(filled, for: .normal)
        }
        else {
            var getIndex = 0
            for i in 0..<savedEvents.count { if(savedEvents[i].id == id) { getIndex = i } }
            context.delete(savedEvents[getIndex])

            do { try context.save() }
            catch { print("Couln't save") }
            Events().updateLiked()

            likeButton.tintColor = .white
            likeButton.setImage(empty, for: .normal)
        }
        
    }
    
}
