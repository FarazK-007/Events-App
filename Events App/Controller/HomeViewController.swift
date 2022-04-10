//
//  ViewController.swift
//  Events App
//
//  Created by Faraz Khan on 09/04/22.
//

import UIKit

class HomeViewController: UIViewController {
	
	var eventDetails: [EventDetail]?
	
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
		
		APICaller.shared.getEventDetails { [weak self] (result) in
			switch result {
			case .success(let reusltEvents):
				DispatchQueue.main.async {
					self?.eventDetails = reusltEvents
					self?.tableView.reloadData()
					print(self?.eventDetails!)
				}
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
		guard let rows = eventDetails?.count else {
			return 0
		}
		return rows
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: K.HomeTableReusableCell, for: indexPath) as? HomeTableViewCell else {
			return UITableViewCell()
		}
		cell.backgroundColor = .clear
		cell.configure(eventDetail: eventDetails![indexPath.row])
		return cell
	}
	
}
