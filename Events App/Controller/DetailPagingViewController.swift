//
//  DeatilPagingViewController.swift
//  Events App
//
//  Created by Faraz Khan on 10/04/22.
//

import UIKit

//MARK: - DetailPagingViewController
class DetailPagingViewController: UIViewController {
	
	//Declaring Variables
	var eventDetail: [EventDetailCoreData] = [EventDetailCoreData]()
	var toIndexPath:IndexPath?

	//initilizing UIComponents
	@IBOutlet weak var detailCollectionView: UICollectionView!
	
	//Intialization Code
	override func viewDidLoad() {
        super.viewDidLoad()
		
		//CollectionView
		detailCollectionView.delegate = self
		detailCollectionView.dataSource = self
    }
	
	//When ViewDidAppear Scroll to specific Index
	override func viewDidAppear(_ animated: Bool) {
		detailCollectionView.scrollToItem(at: self.toIndexPath!, at: .bottom, animated: true)
	}
	
	//Configuere Self
	func configure(model: [EventDetailCoreData], indexPath: IndexPath) {
		
		eventDetail = model
		toIndexPath = indexPath
	}

}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension DetailPagingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	//MARK: - CollectionView DataSource
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return eventDetail.count

	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.PagingCollectionViewCell, for: indexPath) as? DetailCollectionViewCell else {
			return UICollectionViewCell()
		}
		self.title = eventDetail[indexPath.row].category
		cell.configure(eventDetail: eventDetail[indexPath.row], vcModel: self, collectionView: collectionView)
		return cell
	}
	
	//MARK: - CollectionView Flow Layout
	//Set Cell Size
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
	}
	
	//Customizing Cell for Paging without Sections
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	
}
