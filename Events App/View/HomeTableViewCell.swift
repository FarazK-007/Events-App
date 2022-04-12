//
//  HomeTableViewCell.swift
//  Events App
//
//  Created by Faraz Khan on 09/04/22.
//

import UIKit
import SDWebImage

//MARK: - HomeTableViewCell
class HomeTableViewCell: UITableViewCell {
	
	//Intializing Component variables
	@IBOutlet weak var bgView: UIView!
	@IBOutlet weak var eventImageView: UIImageView!
	@IBOutlet weak var eventTitle: UILabel!
	@IBOutlet weak var experienceLabel: UILabel!
	@IBOutlet weak var categoryLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var favouriteButton: UIButton!
	
	//Declaring Variables
	var model: EventDetailCoreData?
	var tableView: UITableView?
	
	
	// Initialization code
    override func awakeFromNib() {
        super.awakeFromNib()
		
		//Customizing UI
		bgView.dropShadow(color: .black, opacity: 0.5, offSet: CGSize(width: 0, height: 0), radius: 3, scale: false)
		bgView.layer.cornerRadius = 20
		eventImageView.layer.cornerRadius = 15
		
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
	
	//Favourite Button of Collection view, updates Favourite in Database
	@IBAction func favButtonPressed(_ sender: UIButton) {
		if model!.favourite {
			DataPersistenceManager.shared.updateFavouriteInDB(id: Int(model!.id), isFavourite: false) { [weak self] (result) in
				switch result {
				case .success(_):
					self?.tableView?.reloadData()
				case .failure(let error):
					print(error)
				}
			}
		} else {
			DataPersistenceManager.shared.updateFavouriteInDB(id: Int(model!.id), isFavourite: true) { [weak self] (result) in
				switch result {
				case .success(_):
					self?.tableView?.reloadData()
				case .failure(let error):
					print(error)
				}
			}
		}
		
	}
	
	//Configure Cell
	func configure(eventDetail: EventDetailCoreData, tableView: UITableView) -> Void {
		
		//Initializing variables
		self.tableView = tableView
		model = eventDetail
		
		//Set Image
		guard let imageURL = URL(string: eventDetail.image ?? "") else {
			return
		}
		eventImageView.sd_setImage(with: imageURL, completed: nil)
		
		//Set Title
		eventTitle.text = eventDetail.name
		
		//Set Experience
		experienceLabel.text = "\(eventDetail.experience?.first ?? 0) - \(eventDetail.experience?.last ?? 0) years"
		
		//Set Category
		categoryLabel.text = eventDetail.category
		
		//Set Description
		descriptionLabel.text = eventDetail.eventDetailDescription
		
		//Set Favourite Button Image
		if eventDetail.favourite {
			favouriteButton.setBackgroundImage(UIImage(systemName: K.imgHeartFill), for: .normal)
		} else {
			favouriteButton.setBackgroundImage(UIImage(systemName: K.imgHeartOutline), for: .normal)
		}
	}
    
}

//MARK: - extension UIView - dropShadow
extension UIView {
	
	//Drop shadow for View
	func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
		layer.masksToBounds = false
		layer.shadowColor = color.cgColor
		layer.shadowOpacity = opacity
		layer.shadowOffset = offSet
		layer.shadowRadius = radius

		//layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
		//layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
		layer.shouldRasterize = true
		layer.rasterizationScale = UIScreen.main.scale
	  }
	
}
