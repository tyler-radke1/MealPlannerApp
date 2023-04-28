//
//  MealCell.swift
//  Meal Planner
//
//  Created by Tyler Radke on 4/21/23.
//

import UIKit

protocol MealCellDelegate {
    func updateMeal(for type: MealType, with recipe: Recipe)
}

class MealCell: UITableViewCell {
    
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
            
//            for recipe in DummyData.recipes {
//                let action = UIAction(title: recipe.name) { [self] action in
//                    guard let delegate, let cellMeal else { return }
//                    
//                    delegate.updateMeal(for: cellMeal, with: recipe)
//                }
//                
//                actions.append(action)
//            }
            
            let menuItems = UIMenu(title: "Your Recipes", children: actions)
            
            return menuItems
        }
    }

