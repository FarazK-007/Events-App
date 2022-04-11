//
//  SortMenuViewController.swift
//  Events App
//
//  Created by Faraz Khan on 09/04/22.
//

import UIKit

class SortMenuViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var sortOrderSedmentControl: UISegmentedControl!
	
	var sortOrder = K.Ascending
	
	var sortNFilter = ["Favourite"]
	let arr = ["Job","Hackathon","Internship","Coding"]
	
	override func viewDidLoad() {
        super.viewDidLoad()

		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.separatorStyle = .none
		
		sortOrderSedmentControl.selectedSegmentIndex = 0
		sortOrder = K.Ascending
		
		sortNFilter += arr
    }
    
	@IBAction func favouriteButtonPressed(_ sender: UIButton) {
		//TODO: - favourite button pressed
		
	}
	
	@IBAction func sortOrderSegmentedControlChanged(_ sender: UISegmentedControl) {
		if sender.selectedSegmentIndex == 0 {
			sortOrder = K.Ascending
		}
		else if sender.selectedSegmentIndex == 1 {
			sortOrder = K.Descending
		}
	}

}

extension SortMenuViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return arr.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: K.sortMenuCell, for: indexPath)
		cell.imageView?.image = UIImage(systemName: "circle.fill")
		cell.textLabel!.text = sortNFilter[indexPath.row]
		cell.tintColor = .label
		return cell
		
	}
	
	
}
