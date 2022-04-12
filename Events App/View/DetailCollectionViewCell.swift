//
//  DetailCollectionViewCell.swift
//  Events App
//
//  Created by Faraz Khan on 10/04/22.
//

import UIKit
import MessageUI

//MARK: - DetailCollectionViewCell
class DetailCollectionViewCell: UICollectionViewCell {
	
	//Intializing Component variables
	@IBOutlet weak var titleImageView: UIImageView!
	@IBOutlet weak var bgView: UIView!
	@IBOutlet weak var titleNameLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var experienceLabel: UILabel!
	@IBOutlet weak var ctcLabel: UILabel!
	@IBOutlet weak var categoryLabel: UILabel!
	@IBOutlet weak var applyButton: UIButton!
	@IBOutlet weak var shareButton: UIButton!
	@IBOutlet weak var favouriteButton: UIButton!
	
	//Declaring Variables
	var model: EventDetailCoreData?
	var vc = UIViewController()
	var collectionView: UICollectionView?
	
	//Initialization Code
	override func awakeFromNib() {
		super.awakeFromNib()
		
		//Customizing UI
		bgView.layer.cornerRadius = 40
		applyButton.layer.cornerRadius = 25
		applyButton.layer.maskedCorners = [.layerMaxXMinYCorner]
		
	}
	
	//Favourite Button of Collection view, updates Favourite in Database
	@IBAction func favouriteButtonPressed(_ sender: UIButton) {
		if model!.favourite {
			DataPersistenceManager.shared.updateFavouriteInDB(id: Int(model!.id), isFavourite: false) { [weak self] (result) in
				switch result {
				case .success(_):
					self?.collectionView?.reloadData()
				case .failure(let error):
					print(error)
				}
			}
		} else {
			DataPersistenceManager.shared.updateFavouriteInDB(id: Int(model!.id), isFavourite: true) { [weak self] (result) in
				switch result {
				case .success(_):
					self?.collectionView?.reloadData()
				case .failure(let error):
					print(error)
				}
			}
		}
	}
	
	//Apply Button of Collection View, open Url in SAFARI
	@IBAction func applyButtonPressed(_ sender: UIButton) {
		let url = URL(string: model!.link!)
		UIApplication.shared.open(url!, completionHandler: nil)

	}
	
	//Share Button of Collection View, share to IMessage
	@IBAction func shareButtonPressed(_ sender: UIButton) {
		
		if MFMessageComposeViewController.canSendText() {
			let messageVC = MFMessageComposeViewController()
			messageVC.subject = model!.category
			messageVC.body = "Join:\n\(model!.name ?? "")\nClick on this Link:\n\(model!.link ?? "")"
			messageVC.recipients = ["Enter Recipients Here"]
			
			messageVC.messageComposeDelegate = self
			
			vc.present(messageVC, animated: true, completion: nil)
		} else {
			print("Device Cant send message")
		}

	}
	
	//Configure Cell
	func configure(eventDetail: EventDetailCoreData, vcModel: UIViewController, collectionView: UICollectionView) {
		
		//Initializing variables
		self.collectionView = collectionView
		model = eventDetail
		
		//Set Image
		guard let imageURL = URL(string: eventDetail.image ?? "") else {
			return
		}
		titleImageView.sd_setImage(with: imageURL, completed: nil)
		
		//Set Title
		titleNameLabel.text = eventDetail.name
		
		//Set Experience
		experienceLabel.text = "\(eventDetail.experience?.first ?? 0) - \(eventDetail.experience?.last ?? 0) years"
		
		//Set Category
		categoryLabel.text = eventDetail.category
		
		//Set Description
		descriptionLabel.text = eventDetail.eventDetailDescription
		
		//Set Ctc
		ctcLabel.text = eventDetail.ctc
		
		//Set Favourite Button Image
		if eventDetail.favourite {
			favouriteButton.setBackgroundImage(UIImage(systemName: K.imgHeartFill), for: .normal)
		} else {
			favouriteButton.setBackgroundImage(UIImage(systemName: K.imgHeartOutline), for: .normal)
		}
	}
	
}

//MARK: - DetailCollectionViewCell: MFMessageComposeViewControllerDelegate
extension DetailCollectionViewCell: MFMessageComposeViewControllerDelegate {
	
	//Delegate Function didFinishWith
	func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
		switch result {
		case .cancelled:
			print("Cancelled Sending Message")
			controller.dismiss(animated: true, completion: nil)
		case .failed:
			print("Failed to Send Message")
			controller.dismiss(animated: true, completion: nil)
		case .sent:
			print("Message Sent")
			controller.dismiss(animated: true, completion: nil)
		default:
			break
		}
	}
	
}
