//
//  DeatilPagingViewController.swift
//  Events App
//
//  Created by Faraz Khan on 10/04/22.
//

import UIKit

class DetailPagingViewController: UIViewController {
	
	var eventDetail: [EventDetailCoreData] = [EventDetailCoreData]()
	var localIndexPath: IndexPath = IndexPath(row: 0, section: 0)

	@IBOutlet weak var detailCollectionView: UICollectionView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		detailCollectionView.delegate = self
		detailCollectionView.dataSource = self
		
        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		detailCollectionView.scrollToItem(at: self.localIndexPath, at: .bottom, animated: true)
	}
	
	func configure(model: [EventDetailCoreData], indexPath: IndexPath) {
		eventDetail = model
		localIndexPath = indexPath
	}

}

extension DetailPagingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return eventDetail.count

	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.PagingCollectionViewCell, for: indexPath) as? DetailCollectionViewCell else {
			return UICollectionViewCell()
		}
		cell.configure(eventDetail: eventDetail[indexPath.row])
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	
}
