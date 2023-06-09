//
//  RecipeDetailsViewController.swift
//  Meal Planner
//
//  Created by Ami Smith on 4/20/23.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    
    var recipe: Recipe?
    var ingredients: [Ingredient] = []
    
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    @IBOutlet weak var ingredientsLabel: UILabel!
    
    @IBOutlet weak var instructionsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let recipe = recipe {
               recipeNameLabel.text = recipe.name
            
            var ingredientStrings: [String] = []
            
            for ingredient in recipe.ingredients {
                let ingredientString = "\(ingredient.quantity) - \(ingredient.name)"
                
                ingredientStrings.append(ingredientString)
            }
            
            let allIngredientsString = ingredientStrings.joined(separator: "\n")
           ingredientsLabel.text = allIngredientsString
            instructionsLabel.text = recipe.instructions
           
       }
    }

    /*
    // MARK: - Navigation

     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
