//
//  DataPersistanceManager.swift
//  Events App
//
//  Created by Faraz Khan on 11/04/22.
//

import Foundation
import UIKit
import CoreData

//MARK: - DataPersistenceManager
struct DataPersistenceManager {
	
	//Singleton Object
	static let shared = DataPersistenceManager()
	
	//Store Items Fetched from api to Database
	func storeToDatabase(result: [EventDetail], completion: @escaping (Result<Void, Error>) -> Void ) {
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		let context = appDelegate.persistentContainer.viewContext
		
		for model in result {
			let item = EventDetailCoreData(context: context)
			item.id = Int64(model.id)
			item.name = model.name
			item.image = model.image
			item.eventDetailDescription = model.eventDetailDescription
			item.category = model.category
			item.ctc = model.ctc
			item.experience = [model.experience.from, model.experience.to]
			item.link = model.link
			
			do {
				try context.save()
				completion(.success(()))
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	//Fetch whole data from Database
	func fetchFromDatabase(completion: @escaping (Result<[EventDetailCoreData], Error>) -> Void ){
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		let context = appDelegate.persistentContainer.viewContext
		
		let request: NSFetchRequest<EventDetailCoreData>
		request = EventDetailCoreData.fetchRequest()
		
		do {
			let result = try context.fetch(request)
			completion(.success(result))
		} catch {
			completion(.failure(error))
		}
	}
	
	//Deleting whole Data from Database (its dont to update database again with latest api data)
	func deleteWholeData(completion: @escaping (Result<[OldItems], Error>) -> Void) {
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		let context = appDelegate.persistentContainer.viewContext
		
		let request: NSFetchRequest<EventDetailCoreData>
		request = EventDetailCoreData.fetchRequest()
		
		//Saving favourite data in UserDefaults before deleting whole data
		
		do {
			let result = try context.fetch(request)
			
			for item in result {
				
				//Add items in OldItems Table
				let addItem = OldItems(context: context)
				addItem.id = item.id
				addItem.favourite = item.favourite
				
				try context.save()
			}
		} catch {
			print(error)
		}
		
		//Deleting whole data
		let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: K.EventDetailCoreData)
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
		do {
			
			//fetch oldItems Data
			let request: NSFetchRequest<OldItems>
			request = OldItems.fetchRequest()
			let oldItems = try context.fetch(request)
			
			//Delete EventDetailsCoreData
			try context.execute(deleteRequest)
			try context.save()
			completion(.success(oldItems))
		} catch {
			print (error)
		}
	}
	
	//Performing Database Query for SearchBar
	func performQueryForSearchBar (searchBar: UISearchBar, completion: @escaping (Result<[EventDetailCoreData], Error>) -> Void) {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		let context = appDelegate.persistentContainer.viewContext
		
		let request: NSFetchRequest<EventDetailCoreData>
		request = EventDetailCoreData.fetchRequest()
		
		let predicate = NSPredicate(format: "name CONTAINS[cd] %@ OR category CONTAINS[cd] %@", searchBar.text!,searchBar.text!)
		request.predicate = predicate
		
		do {
			let result = try context.fetch(request)
			completion(.success(result))
		} catch {
			completion(.failure(error))
		}
		
	}
	
	//Updating Favourite in Database
	func updateFavouriteInDB (id: Int, isFavourite: Bool , completion: @escaping (Result<[EventDetailCoreData], Error>) -> Void) {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		let context = appDelegate.persistentContainer.viewContext
		
		let request: NSFetchRequest<EventDetailCoreData>
		request = EventDetailCoreData.fetchRequest()
		
		let predicate = NSPredicate(format: "id == %ld", id)
		request.predicate = predicate
		
		do {
			let result = try context.fetch(request)
			result.first?.favourite = isFavourite
			try context.save()
			completion(.success(result))
		} catch {
			completion(.failure(error))
		}
		
	}
	
	
	//Performing Query for Sorting and Filtering Data
	func performQueryForSortNFilter (isAscending: Bool, category: String, completion: @escaping (Result<[EventDetailCoreData], Error>) -> Void) {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		let context = appDelegate.persistentContainer.viewContext
		
		let request: NSFetchRequest<EventDetailCoreData>
		request = EventDetailCoreData.fetchRequest()
		
		if category != "Favourite" {
			let predicate = NSPredicate(format: "category CONTAINS[cd] %@ ", category)
			request.predicate = predicate
		} else {
			let predicate = NSPredicate(format: "favourite = %d ", true)
			request.predicate = predicate
		}
		
		request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: isAscending)]
		
		do {
			let result = try context.fetch(request)
			//print(result)
			completion(.success(result))
		} catch {
			completion(.failure(error))
		}
		
	}
	
	//Delete Data of OldItems
	func deleteWholeDataOfOldItems(completion: @escaping (Result<Void, Error>) -> Void) {
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		let context = appDelegate.persistentContainer.viewContext
		
		//Deleting whole data
		let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: K.OldItems)
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
		do {
			try context.execute(deleteRequest)
			try context.save()
		} catch {
			print (error)
		}
	}
	
}
