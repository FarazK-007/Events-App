//
//  DataPersistanceManager.swift
//  Events App
//
//  Created by Faraz Khan on 11/04/22.
//

import Foundation
import UIKit
import CoreData

struct DataPersistenceManager {
	
	enum DatabaseError: Error {
		case failedToSaveData
		case failedToFetchData
		case failedToDeleteData
	}
	
	static let shared = DataPersistenceManager()
	
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
				completion(.failure(DatabaseError.failedToSaveData))
			}
		}
	}
	
	
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
			completion(.failure(DatabaseError.failedToFetchData))
		}
	}
	
	
	func deleteWholeData(completion: @escaping (Result<Void, Error>) -> Void) {
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			return
		}
		let context = appDelegate.persistentContainer.viewContext
		
		let request: NSFetchRequest<EventDetailCoreData>
		request = EventDetailCoreData.fetchRequest()
		do {
			
			let result = try context.fetch(request)
			
			for item in result {
				UserDefaults.standard.set(item.id, forKey: "id")
				UserDefaults.standard.set(item.favourite, forKey: "favourite")
			}
		} catch {
			
		}
		
		let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: K.EventDetailCoreData)
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
		do {
			try context.execute(deleteRequest)
			try context.save()
		} catch {
			print (DatabaseError.failedToDeleteData)
		}
	}
	
}
