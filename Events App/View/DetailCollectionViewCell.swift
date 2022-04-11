//
//  DetailCollectionViewCell.swift
//  Events App
//
//  Created by Faraz Khan on 10/04/22.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var titleImageView: UIImageView!
	@IBOutlet weak var bgView: UIView!
	@IBOutlet weak var titleNameLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var experienceLabel: UILabel!
	@IBOutlet weak var ctcLabel: UILabel!
	@IBOutlet weak var categoryLabel: UILabel!
	@IBOutlet weak var applyButton: UIButton!
	@IBOutlet weak var shareButton: UIButton!
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		//Initialization Code
		bgView.layer.cornerRadius = 40
		applyButton.layer.cornerRadius = 25
		applyButton.layer.maskedCorners = [.layerMaxXMinYCorner]
		
	}
	
	
	@IBAction func applyButtonPressed(_ sender: UIButton) {
		//TODO: - Apply Button

	}
	@IBAction func shareButtonPressed(_ sender: UIButton) {
		//TODO: - Share Button

	}
	
	func configure(eventDetail: EventDetailCoreData) {
		//set image
		guard let imageURL = URL(string: eventDetail.image ?? "") else {
			return
		}
		titleImageView.sd_setImage(with: imageURL, completed: nil)
		//set title
		titleNameLabel.text = eventDetail.name
		//experience
		experienceLabel.text = "\(eventDetail.experience?.first ?? 0) - \(eventDetail.experience?.last ?? 0) years"
		//category
		categoryLabel.text = eventDetail.category
		//description
		descriptionLabel.text = eventDetail.eventDetailDescription
		//ctc
		ctcLabel.text = eventDetail.ctc
		
	}
	
}
