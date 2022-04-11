//
//  Constants.swift
//  Events App
//
//  Created by Faraz Khan on 09/04/22.
//

import Foundation

struct K {
	
	//API
	static let api_url = "https://winjittesting.free.beeceptor.com/temp/api"
	
	//Cells
	static let sortMenuCell = "sortMenuCell"
	static let PagingCollectionViewCell = "PagingCollectionViewCell"
	static let HomeTableReusableCell = "HomeTableReusableCell"
	
	//Nibs
	static let HomeTableViewCell = "HomeTableViewCell"
	static let DetailCollectionViewCell = "DetailCollectionViewCell"
	
	//VC's
	static let SortMenuVCID = "SortMenuVCID"
	static let DetailVCwithPaging = "DetailVCwithPaging"
	static let DetailVCwithoutPaging = "DetailVCwithoutPaging"
	
	//Segue's
	static let HomeToPagingSegue = "HomeToPagingSegue"
	static let SortMenuSegue = "SortMenuSegue"
	
	//Sort Menu
	static let Ascending = "Ascending"
	static let Descending = "Descending"
	
	//CoreData
	static let EventDetailCoreData = "EventDetailCoreData"
	static let ExperienceTransformer = "ExperienceTransformer"
	
	//NotificationCenter
	static let storedToDatabase = "storedToDatabase"
	
}
