//
//  SortMenuViewController.swift
//  Events App
//
//  Created by Faraz Khan on 09/04/22.
//

import UIKit

//MARK: - SortMenuViewController
class SortMenuViewController: UIViewController {
	
	//Closure Completion handler for Passing Data
	var completionHandler: (([EventDetailCoreData]) -> Void)?

	//initilizing UIComponents
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var sortOrderSegmentControl: UISegmentedControl!
	
	//Declaring Variables
	var eventDetails = [EventDetailCoreData]()
	var sortOrderIsAscending = true
	var sortNFilter = ["Favourite"]
	var categoryArray = [String]()
	var setArray = Set<String>()
	
	//Intialization Code
	override func viewDidLoad() {
        super.viewDidLoad()

		//TableView
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.separatorStyle = .none
		
		//SegmentControl
		sortOrderSegmentControl.selectedSegmentIndex = 0
		
		//Intializing Required Variables
		sortOrderIsAscending = true
		
		setCategoryArray()
		sortNFilter += setArray.sorted()
    }
    
	//Action for If Reset Button is Pressed
	@IBAction func resetButtonPressed(_ sender: UIButton) {
		
		DataPersistenceManager.shared.fetchFromDatabase { [weak self] (result) in
			switch result {
			case .success(let items):
				self?.eventDetails = items
				self?.updateHomeVCData(model: items)
			case .failure(let error):
				print(error)
			}
		}
		
		dismiss(animated: true, completion: nil)
		
	}
	
	//Getting data From SegmentControl
	@IBAction func sortOrderSegmentedControlChanged(_ sender: UISegmentedControl) {
		if sender.selectedSegmentIndex == 0 {
			sortOrderIsAscending = true
		}
		else if sender.selectedSegmentIndex == 1 {
			sortOrderIsAscending = false
		}
	}
	
	//Configure VC
	func configure(model: [EventDetailCoreData]) {
		eventDetails = model
	}
	
	//Taking all items from EventDetails Category Attributes
	func setCategoryArray() {
		for item in eventDetails {
			categoryArray.append(item.category ?? "No category")
		}
		setArray = Set(categoryArray.map{$0})
	}
	
	//Updates in Home VC according to Selection
	func updateHomeVCData (model: [EventDetailCoreData]) {
		completionHandler?(model)
	}

}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension SortMenuViewController: UITableViewDelegate, UITableViewDataSource {
	
	//MARK: - TableView DataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sortNFilter.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: K.sortMenuCell, for: indexPath)
		cell.imageView?.image = UIImage(systemName: "circle.circle.fill")
		cell.textLabel!.text = sortNFilter[indexPath.row]
		cell.tintColor = .label
		return cell
		
	}
	
	//MARK: - TableView Delegate
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		DataPersistenceManager.shared.performQueryForSortNFilter(isAscending: sortOrderIsAscending, category: sortNFilter[indexPath.row]) { [weak self] (result) in
			switch result {
			case .success(let items):
				self?.eventDetails = items
				self?.updateHomeVCData(model: items)
			case .failure(let error):
				print(error)
			}
		}
		dismiss(animated: true, completion: nil)
	}
	
}
