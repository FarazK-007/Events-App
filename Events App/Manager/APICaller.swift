//
//  APICaller.swift
//  Events App
//
//  Created by Faraz Khan on 10/04/22.
//

import Foundation

//MARK: - APICaller
struct APICaller {
	//Singleton Object
	static let shared = APICaller()
	
	//Fetch Event Details from Api
	func getEventDetails(completion: @escaping (Result< [EventDetail], Error>) -> Void) {
		
		guard let base_url = URL(string: K.api_url) else {
			return
		}
		
		let task = URLSession.shared.dataTask(with: URLRequest(url: base_url)) { (data, response, error) in
			guard let _data = data, error == nil else { return }
			do {
				let result = try JSONDecoder().decode(EventDetailsResponse.self, from: _data)
				completion(.success(result.eventDetails))
			} catch {
				completion(.failure(error))
			}
		}
		
		task.resume()
	}
	
	
}
