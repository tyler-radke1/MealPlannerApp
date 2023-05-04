//
//  Ingredient+CoreDataProperties.swift
//  
//
//  Created by Sterling Jenkins on 5/4/23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var index: Int64
    @NSManaged public var name: String?
    @NSManaged public var quantity: String?
    @NSManaged public var recipe: Recipe?

}

extension Ingredient : Identifiable {

}
