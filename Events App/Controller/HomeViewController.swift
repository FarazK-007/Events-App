//
//  ViewController.swift
//  Events App
//
//  Created by Faraz Khan on 09/04/22.
//

import UIKit

class HomeViewController: UIViewController {
	
	var eventDetails: [EventDetailCoreData] = [EventDetailCoreData]()
	
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var totalEventsLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
		
		tableView.register(UINib(nibName: K.HomeTableViewCell, bundle: nil), forCellReuseIdentifier: K.HomeTableReusableCell)
		
		NotificationCenter.default.addObserver(forName: NSNotification.Name(K.storedToDatabase), object: nil, queue: nil) { [weak self] (_) in
			self?.fetchDatafromDatabase()
			self?.totalEventsLabel.text = "TOTAL EVENTS: \(self?.eventDetails.count ?? 0)"
		}
	}
	
	func fetchDatafromDatabase() {
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

	@IBAction func sortButtonTapped(_ sender: UIButton) {
		
		//TODO: Button
		
	}
	
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return eventDetails.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: K.HomeTableReusableCell, for: indexPath) as? HomeTableViewCell else {
			return UITableViewCell()
		}
		cell.backgroundColor = .clear
		cell.configure(eventDetail: eventDetails[indexPath.row])
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		guard let vc = storyboard?.instantiateViewController(withIdentifier: K.DetailVCwithPaging) as? DetailPagingViewController else {
			return
		}
		vc.configure(model: eventDetails, indexPath: indexPath)
		self.navigationController?.pushViewController(vc, animated: true)
		
	}
	
}

extension HomeViewController: UIPopoverPresentationControllerDelegate {
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == K.SortMenuSegue {
			let popoverViewController = segue.destination
			popoverViewController.popoverPresentationController?.delegate = self
		}
	}
	
	//To force stop the view to show modally
	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.none
	}
}
