//
//  ExperienceTransformer.swift
//  Events App
//
//  Created by Faraz Khan on 11/04/22.
//

import Foundation

class ExperienceTransformer: ValueTransformer {
	
	override func transformedValue(_ value: Any?) -> Any? {
		guard let array = value as? [Int] else {return nil}
		
		do {
			let data = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: true)
			return data
		} catch {
			return nil
		}
	}
	
	override func reverseTransformedValue(_ value: Any?) -> Any? {
		guard let data = value as? Data else {return nil}
		
		do {
			let array = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Int]
			return array
		} catch {
			return nil
		}
	}
	
}
