//
//  ViewController.swift
//  Events App
//
//  Created by Faraz Khan on 09/04/22.
//

import UIKit

//MARK: - HomeViewController
class HomeViewController: UIViewController {
	
	//Declaring Variables
	var eventDetails: [EventDetailCoreData] = [EventDetailCoreData]()
	
	//initilizing UIComponents
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var totalEventsLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	
	//Intialization Code
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//TableVeiw
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
		
		tableView.register(UINib(nibName: K.HomeTableViewCell, bundle: nil), forCellReuseIdentifier: K.HomeTableReusableCell)
		
		//Search Bar
		searchBar.delegate = self
		
		//Notification Center
		NotificationCenter.default.addObserver(forName: NSNotification.Name(K.storedToDatabase), object: nil, queue: nil) { [weak self] (_) in
			self?.fetchDataFromDatabase()
			self?.totalEventsLabel.text = "TOTAL EVENTS: \(self?.eventDetails.count ?? 0)"
		}
	}
	
	//ViewDidAppear - reload tableView everytime View Appears
	override func viewDidAppear(_ animated: Bool) {
		tableView.reloadData()
	}

	//sortButtonTapped connected Directly from Stroryboard
	@IBAction func sortButtonTapped(_ sender: UIButton) {
		//Empty
	}
	
	//Fetch Data from Database
	func fetchDataFromDatabase() {
		DataPersistenceManager.shared.fetchFromDatabase { [weak self](result) in
			switch result {
			case .success(let items):
				self?.eventDetails = items
				self?.tableView.reloadData()
			case .failure(let error):
				print(error)
			}
		}
	}
	
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
	
	//MARK: -  Table View Data Source
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return eventDetails.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: K.HomeTableReusableCell, for: indexPath) as? HomeTableViewCell else {
			return UITableViewCell()
		}
		cell.backgroundColor = .clear
		cell.configure(eventDetail: eventDetails[indexPath.row], tableView: tableView)
		return cell
	}
	
	//MARK: - TableView Delegate
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		guard let vc = storyboard?.instantiateViewController(withIdentifier: K.DetailVCwithPaging) as? DetailPagingViewController else {
			return
		}
		vc.configure(model: eventDetails, indexPath: indexPath)
		self.navigationController?.pushViewController(vc, animated: true)
		
	}
	
}

//MARK: - UIPopoverPresentationControllerDelegate
extension HomeViewController: UIPopoverPresentationControllerDelegate {
	
	//Present Popover
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == K.SortMenuSegue {
			
			let popoverViewController = segue.destination as! SortMenuViewController
			popoverViewController.configure(model: eventDetails)
			
			//Closure for accesing data from SortMenuViewController to Self
			popoverViewController.completionHandler = { [weak self] model in
				self?.eventDetails = model
				self?.tableView.reloadData()
			}
			
			//Delegate
			popoverViewController.popoverPresentationController?.delegate = self
		}
	}
	
	//To force stop the view to show modally
	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.none
	}
}

//MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
	
	//Search Button Tapped
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		search(searchBar)
		DispatchQueue.main.async {
			searchBar.resignFirstResponder()
		}
		
	}
	
	//Search instantly as textChanges
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text?.count == 0 {
			DataPersistenceManager.shared.fetchFromDatabase { [weak self] (result) in
				switch result {
				case .success(let items):
					self?.eventDetails = items
					self?.tableView.reloadData()
				case .failure(let error):
					print(error)
				}
			}
			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
			}
		}
		else {
			search(searchBar)
		}
		
	}
	
	//Search in Database
	func search(_ searchBar: UISearchBar) {
		DataPersistenceManager.shared.performQueryForSearchBar(searchBar: searchBar) { [weak self] (result) in
			switch result {
			case .success( let items ):
				self?.eventDetails = items
				self?.tableView.reloadData()
			case .failure(let error):
				print(error)
			}
		}
	}
}
