//
//  Recipe+CoreDataProperties.swift
//  
//
//  Created by Sterling Jenkins on 5/4/23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var id: Int64
    @NSManaged public var instructions: String?
    @NSManaged public var name: String?
    @NSManaged public var photo: Data?
    @NSManaged public var breakfast: Day?
    @NSManaged public var dinner: Day?
    @NSManaged public var ingredients: NSSet?
    @NSManaged public var lunch: Day?

}

// MARK: Generated accessors for ingredients
extension Recipe {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: Ingredient)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: Ingredient)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}

extension Recipe : Identifiable {

}
