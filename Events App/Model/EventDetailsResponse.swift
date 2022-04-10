//
//  EventDetailsResponse.swift
//  Events App
//
//  Created by Faraz Khan on 10/04/22.
//

import Foundation

// MARK: - EventDetailsResponse
struct EventDetailsResponse: Codable {
	let eventDetails: [EventDetail]

	enum CodingKeys: String, CodingKey {
		case eventDetails = "event_details"
	}
}

// MARK: - EventDetail
struct EventDetail: Codable {
	let id: Int
	let name: String
	let image: String
	let eventDetailDescription, category, ctc: String
	let experience: Experience
	let link: String

	enum CodingKeys: String, CodingKey {
		case id, name, image
		case eventDetailDescription = "description"
		case category, ctc, experience, link
	}
}

// MARK: - Experience
struct Experience: Codable {
	let from, to: Int
}
