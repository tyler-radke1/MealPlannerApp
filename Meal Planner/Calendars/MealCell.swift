//
//  MealCell.swift
//  Meal Planner
//
//  Created by Tyler Radke on 4/21/23.
//

import UIKit
import CoreData

protocol MealCellDelegate {
    func updateMeal(for type: MealType, with recipe: Recipe)
}

class MealCell: UITableViewCell {
    
    let context = PersistenceController.shared.viewContext
    
    @IBOutlet weak var recipeNameButton: UIButton!
    
    var delegate: MealCellDelegate? = nil
    
    var cellMeal: MealType? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func addMenuItems()  -> UIMenu  {
        var actions: [UIAction] = []
        
        for recipe in createFetchRequest() {
            guard let delegate, let cellMeal, let name = recipe.name else { continue }
            
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

