//

import Combine
import CoreLocation
import IBExtensions
import iCarousel
import UIKit

// MARK: - CELL

enum RowType {
    case all
    case topRow
    case middleRow
    case bottomRow
}

class DiaryEntryTableViewCell: UITableViewCell {
    let ImageCellIdentifier = "ImageCell"
    var rowType = RowType.all
    var tableView: DiaryTableViewWrapper?
    
    // MARK: - IBOutlets -
    
    @IBOutlet var imagesCarouselView: iCarousel?
    
    @IBOutlet var latitudeLabel: UILabel?
    @IBOutlet var longitudeLabel: UILabel?
    @IBOutlet var headlineButton: UIButton?
    @IBOutlet var subHeadline: UILabel?
    @IBOutlet var arrivalIcon: UIImageView?
    @IBOutlet var arrival: UILabel?
    @IBOutlet var departureIcon: UIImageView?
    @IBOutlet var departure: UILabel?
    
    @IBOutlet var durationIcon: UIImageView?
    @IBOutlet var stayDuration: UILabel?
    @IBOutlet var distanceIcon: UIImageView?
    @IBOutlet var distanceFromLocation: UILabel?
    
    @IBOutlet var cardTileBackground: SwiftyInnerShadowView?
    @IBOutlet var mapImage: UIImageView?
    
    @IBOutlet var mapGradientView: UIView?
    
    @IBOutlet var openInMapsButton: UIButton?
    @IBOutlet var detailsButton: UIButton?
    
    @IBOutlet var compassButton: UIButton?
    @IBOutlet var compassImage: UIImageView?
    
    @IBOutlet var bottomDivider: UIView?
    
    // MARK: - VIEWMODELS -
    
//    private let photosViewModel = PhotoViewModel()
    
    private var entry: DiaryEntryViewModel?
    private var headingPublisher: AnyCancellable?
    private var currentLocation = Settings.lastLocation
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupCell(entry: DiaryEntryViewModel, rowType: RowType = .all) {
        self.mapImage?.isHidden = true
        
        entry.updateData = { [weak self] in
            if let self = self, let entry = self.entry {
                DispatchQueue.main.async {
                    self.fillForm(entry: entry)
                }
            }
        }
        
        self.entry = entry
        self.fillForm(entry: entry)
        
        if let compassImage = compassImage,
            let entry = self.entry {
            let image = UIImage(systemName: "location.north.fill")?.withRenderingMode(.alwaysTemplate)
            
            compassImage.image = image
            compassImage.tintColor = .actionInvers
            
            self.headingPublisher = LocationPublisher.shared.headingPublisher.sink {
                headingData in
                compassImage.rotate(degrees: CGFloat(entry.bearing - headingData.heading))
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        if self.imagesCarouselView == nil { // compact version
            if let openInMapsButton = openInMapsButton {
                openInMapsButton.addSoftUIEffectForButton(cornerRadius: openInMapsButton.bounds.size.width / 2, themeColor: UIColor.neoWhite)
            }
            if let compassButton = compassButton {
                compassButton.addSoftUIEffectForButton(cornerRadius: compassButton.bounds.size.width / 2, themeColor: UIColor.neoWhite)
            }
        } else {
            if let openInMapsButton = openInMapsButton {
                openInMapsButton.layer.cornerRadius = openInMapsButton.bounds.size.width / 2
                openInMapsButton.backgroundColor = UIColor.action
                let image = UIImage(systemName: "map")?.withRenderingMode(.alwaysTemplate)
                
                openInMapsButton.setImage(image, for: .normal)
                openInMapsButton.imageView?.tintColor = .actionInvers
            }
            if let compassButton = compassButton {
                compassButton.layer.cornerRadius = compassButton.bounds.size.width / 2
                compassButton.backgroundColor = UIColor.action
            }
        }
    }
    
    @objc func onCompassPressed() {
        if let entry = self.entry {
            AppNotification.sendShowCompass(entry: entry)
        }
    }
    
    private func fillForm(entry: DiaryEntryViewModel) {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.cardTileBackground?.backgroundColor = .clear
        
        self.arrivalIcon?.image = UIImage.arrival
        self.departureIcon?.image = UIImage.departure
        self.durationIcon?.image = UIImage.clock
        self.distanceIcon?.image = UIImage.distance
        
        let symbolConfig = Settings.cellStyle == .compact ? UIImage.smallSymbol : UIImage.bigSymbol
        
        self.openInMapsButton?.setImage(UIImage(systemName: "map", withConfiguration: symbolConfig), for: .normal)
        
        if let carousel = imagesCarouselView {
            if Settings.showPictures {
                carousel.backgroundColor = .clear
                carousel.dataSource = self
                carousel.delegate = self
                carousel.type = .coverFlow
                
                carousel.reloadData()
                carousel.isHidden = false
            } else {
                carousel.isHidden = true
            }
        }
        
        if let cardTileBackground = cardTileBackground,
            cardTileBackground.layer.cornerRadius == 0 {
            let compact = Settings.cellStyle == .compact
            cardTileBackground.layer.cornerRadius = compact ? 6 : 12
            
            cardTileBackground.clipsToBounds = true
            cardTileBackground.layer.shadowColor = UIColor.black.cgColor
            cardTileBackground.layer.shadowRadius = compact ? 5 : 2
            cardTileBackground.layer.shadowOpacity = compact ? 0.2 : 0.3
            cardTileBackground.layer.shadowOffset = compact ? CGSize(width: 0.5, height: 0.1) : CGSize(width: 1, height: 1)
            cardTileBackground.generateOuterShadow()
        }
        
        self.headlineButton?.setTitle(entry.locationName, for: .normal)
        self.subHeadline?.text = entry.headline
        
        self.arrival?.text = entry.arrivalTime
        if entry.isCurrent {
            self.departure?.text = TXT.currentlyHere
        } else if entry.isSameDay {
            self.departure?.text = entry.departureTime
        } else {
            self.departure?.text = "\(entry.departureTime) + \(entry.daysOfStay)"
                + TXT.dayAbbreviation
        }
        self.stayDuration?.text = entry.secondsOfStay.timeString()
        self.distanceFromLocation?.text = entry.distanceFromLocation.formattedDistanceWithUnit
        self.latitudeLabel?.text = entry.latitude.latitudeString
        self.longitudeLabel?.text = entry.longitude.longitudeString
        
        if let mapImage = mapImage {
            CLLocationCoordinate2D(
                latitude: entry.latitude,
                longitude: entry.longitude)
                .mkMapImage(size: mapImage.bounds.size) {
                    image in
                    mapImage.image = image
                    mapImage.isHidden = false
                }
        }
        
        self.bottomDivider?.isHidden = self.rowType == .bottomRow
        
        self.accessabilitySetup(entry: entry)
    }
    
    func accessabilitySetup(entry: DiaryEntryViewModel) {
        self.latitudeLabel?.setAccessability(.geoLatitude, with: entry.latitude.latitudeString)
        self.longitudeLabel?.setAccessability(.geoLongitude, with: entry.longitude.longitudeString)
        
        self.headlineButton?.setAccessability(.entryLocation, with: entry.locationName)
        self.arrival?.setAccessability(.arrivalTime, with: entry.arrivalDate + " " + entry.arrivalTime)
        self.departure?.setAccessability(.departureTime, with: entry.departureTime + " " + entry.departureTime)
        
        self.stayDuration?.setAccessability(.durationOfStay, with: entry.secondsOfStay.timeString())
        self.distanceFromLocation?.setAccessability(.distanceFromLocation, with: [entry.locationName, entry.distanceFromLocation.formattedDistanceWithUnit])
        
        self.openInMapsButton?.setAccessability(.openInMapsButton, with: entry.locationName)
        self.detailsButton?.setAccessability(.detailsButton)
        
        self.compassButton?.setAccessability(.compassButton, with: entry.locationName)
    }
    
    @IBAction func onFavoriteButtonPressed(_ button: UIButton) {
        let newState = !button.isSelected
        button.isSelected = newState
        self.entry?.toggleFavorite()
    }
    
    @IBAction func openInMaps(_ sender: Any?) {
        if let entry = self.entry {
            entry.openInMaps()
        }
    }
    
    @IBAction func displayDetails(_ sender: Any?) {
        if let entry = self.entry {
            AppNotification.sendShowDetail(entry: entry)
        }
    }
    
    @IBAction func editLocation(_ sender: Any?) {
        if let entry = self.entry {
            AppNotification.sendEditLocation(entry: entry)
        }
    }
    
    @IBAction func displayCompass(_ sender: Any) {
        if let entry = self.entry {
            AppNotification.sendShowCompass(entry: entry)
        }
    }
    
    @IBAction func DummyButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            break
        default:
            break
        }
    }
}

// MARK: - Corousel Data Source

extension DiaryEntryTableViewCell: iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        #if targetEnvironment(simulator)
            return 4
        #else
            self.entry?.photos.photos.sort { identImage1, identImage2 in
                (identImage1.timeStamp ?? Date.distantPast) < (identImage2.timeStamp ?? Date.distantPast)
            }
            return self.entry?.photos.photos.count ?? 0
        #endif
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        #if targetEnvironment(simulator)
            var imgName = "n"
            
            if let entry = entry, Int(entry.latitude) == 38 {
                imgName = "w"
            }
            imgName = "\(imgName)\(index)"
            guard let image = UIImage(named: imgName) else {
                return UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
            }
            
        #else
            guard let image = self.entry?.photos.photos[index].uiImage else {
                return UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
            }
        #endif
        
        let scaledImage = image.resize(withSize: CGSize(width: 150, height: 150), contentMode: .contentAspectFit)
        let imageView = UIImageView(image: scaledImage)
        
        imageView.layer.borderColor = UIColor(white: 0.95, alpha: 1).cgColor
        imageView.layer.borderWidth = 4
        imageView.layer.shadowOffset = CGSize(width: 4, height: 4)
        imageView.layer.shadowRadius = 6
        imageView.layer.shadowOpacity = 0.3
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }
}

extension DiaryEntryTableViewCell: iCarouselDelegate {
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        
        guard let id = entry?.photos.photos[index].id,
            let image = self.entry?.photos.photos[index].uiImage else {
            return
        }
        imageTapped(image: image, id: id)
    }
}

extension DiaryEntryTableViewCell {
    func imageTapped(image: UIImage, id: String) {
        let newImageView = UIImageView(image: image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        newImageView.alpha = 0
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            viewController.view.addSubview(newImageView)
            UIView.animate(withDuration: 0.3) {
                newImageView.alpha = 1
            }
            
            // TODO: load full size image
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            
            if let image = Caching.cachedImage(id: id, width: width, height: height) {
                newImageView.image = image
            } else {
                UIImage.photoroll(with: [id], width: width, height: height) { [weak self] _, image, _, _, _ in
                    guard self != nil else {
                        return
                    }
                    newImageView.image = image
                }
            }
        }
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
}

extension UIImage {
    enum ContentMode {
        case contentFill
        case contentAspectFill
        case contentAspectFit
    }
    
    func resize(withSize size: CGSize, contentMode: ContentMode = .contentAspectFill) -> UIImage? {
        let aspectWidth = size.width / self.size.width
        let aspectHeight = size.height / self.size.height
        
        switch contentMode {
        case .contentFill:
            return self.resize(withSize: size)
        case .contentAspectFit:
            let aspectRatio = min(aspectWidth, aspectHeight)
            return self.resize(withSize: CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio))
        case .contentAspectFill:
            let aspectRatio = max(aspectWidth, aspectHeight)
            return self.resize(withSize: CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio))
        }
    }
    
    private func resize(withSize size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
