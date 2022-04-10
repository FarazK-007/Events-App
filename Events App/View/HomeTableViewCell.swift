//
//  HomeTableViewCell.swift
//  Events App
//
//  Created by Faraz Khan on 09/04/22.
//

import UIKit
import SDWebImage

class HomeTableViewCell: UITableViewCell {
	
	@IBOutlet weak var bgView: UIView!
	@IBOutlet weak var eventImageView: UIImageView!
	@IBOutlet weak var eventTitle: UILabel!
	@IBOutlet weak var experienceLabel: UILabel!
	@IBOutlet weak var categoryLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var favouriteButton: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		bgView.dropShadow(color: .black, opacity: 0.5, offSet: CGSize(width: 0, height: 0), radius: 3, scale: false)
		bgView.layer.cornerRadius = 20
		eventImageView.layer.cornerRadius = 15
		
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
	
	override func prepareForReuse() {
		favouriteButton.image = UIImage(systemName: "heart.fill")
	}
	
	func configure(eventDetail: EventDetail) -> Void {
		//set image
		guard let imageURL = URL(string: eventDetail.image) else {
			return
		}
		eventImageView.sd_setImage(with: imageURL, completed: nil)
		//set title
		eventTitle.text = eventDetail.name
		//experience
		experienceLabel.text = "\(eventDetail.experience.from) - \(eventDetail.experience.to) years"
		//category
		categoryLabel.text = eventDetail.category
		//description
		descriptionLabel.text = eventDetail.eventDetailDescription
	}
    
}

extension UIView {
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
