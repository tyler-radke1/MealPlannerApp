//
//  MealCell.swift
//  Meal Planner
//
//  Created by Tyler Radke on 4/21/23.
//

import UIKit
import CoreData

protocol MealCellDelegate {
    func updateMeal(for type: MealType, with recipe: Recipe?)
    func saveCoreData(date: Date, day: Day)
}

class MealCell: UITableViewCell {
    
    let context = PersistenceController.shared.viewContext
    
    @IBOutlet weak var recipeNameButton: UIButton!
    
    var delegate: MealCellDelegate? = nil
    
    var cellMeal: MealType? = nil
    
    let noMeal: Recipe? = nil
    
    var favoriteRecipe: Recipe? = nil
    
    @IBAction func mealButtonTapped(_ sender: UIButton) {
        guard let cellMeal, let favoriteRecipe else { return }
        
        delegate?.updateMeal(for: cellMeal, with: favoriteRecipe)
    }
    func addMenuItems()  -> UIMenu  {
        guard let cellMeal, let delegate else { return UIMenu()}
        var actions: [UIAction] = []
        
        let noMealAction = UIAction(title: "Leave Blank") { action in
           delegate.updateMeal(for: cellMeal, with: nil)
        }
        actions.append(noMealAction)
        
        for recipe in createFetchRequest() {
            guard let name = recipe.name else { continue }
            
            let action = UIAction(title: name) { action in
                delegate.updateMeal(for: cellMeal, with: recipe)
            }
            actions.append(action)
        }
        
        let menuItems = UIMenu(title: "Your Recipes", children: actions)
        
        return menuItems
    }
    
    func createFetchRequest() -> [Recipe] {
        var recipes: [Recipe] = []
        
        let fetchRequest = NSFetchRequest<Recipe>(entityName: "Recipe")
        
        do {
            let results = try context.fetch(fetchRequest)
            results.forEach { recipes.append($0) }
            
        } catch {
            print("you oofed")
        }
        
        return recipes
    }
}

