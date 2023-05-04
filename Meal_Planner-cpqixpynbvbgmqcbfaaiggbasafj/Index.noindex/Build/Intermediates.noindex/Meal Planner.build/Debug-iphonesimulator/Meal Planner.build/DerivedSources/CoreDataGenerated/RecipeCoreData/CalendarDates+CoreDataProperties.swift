//
//  CalendarDates+CoreDataProperties.swift
//  
//
//  Created by Sterling Jenkins on 5/4/23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension CalendarDates {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CalendarDates> {
        return NSFetchRequest<CalendarDates>(entityName: "CalendarDates")
    }

    @NSManaged public var date: Date?
    @NSManaged public var day: Day?

}

extension CalendarDates : Identifiable {

}
