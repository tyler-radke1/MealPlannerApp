//
//  Day+CoreDataProperties.swift
//  
//
//  Created by Sterling Jenkins on 5/4/23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var breakfast: Recipe?
    @NSManaged public var dinner: Recipe?
    @NSManaged public var lunch: Recipe?

}

extension Day : Identifiable {

}
