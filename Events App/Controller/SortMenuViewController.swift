//
//  SortMenuViewController.swift
//  Events App
//
//  Created by Faraz Khan on 09/04/22.
//

import UIKit

class SortMenuViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	let arr = ["Job","Hackathon","Internship","Coding"]
	
	override func viewDidLoad() {
        super.viewDidLoad()

		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.separatorStyle = .none
		
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SortMenuViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return arr.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: K.sortMenuCell, for: indexPath)
		cell.imageView?.image = UIImage(systemName: "circle.fill")
		cell.textLabel!.text = arr[indexPath.row]
		cell.tintColor = .label
		return cell
		
	}
	
	
}
