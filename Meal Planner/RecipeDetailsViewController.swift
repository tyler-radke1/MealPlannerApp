//
//  RecipeDetailsViewController.swift
//  Meal Planner
//
//  Created by Ami Smith on 4/20/23.
//

import UIKit
import CoreData


class RecipeDetailsViewController: UIViewController {
    
    var recipe: Recipe?
    var ingredients: [Ingredient] = []
    
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    @IBOutlet weak var ingredientsLabel: UILabel!
    
    @IBOutlet weak var instructionsLabel: UILabel!
    
    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var nutritionInformationLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColor()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let recipe = recipe {
            recipeNameLabel.text = recipe.name
            
            var ingredientStrings: [String] = []
            
            if let ingredientsSet = recipe.ingredients as? Set<Ingredient> {
                var ingredientsArray = Array(ingredientsSet)
                /// Add `orderID` variable to the Core Data Ingredient object
                /// When you save the JSON object to Core Data, grab out the index of the Ingredient and save it as the `orderID` of that ingredient.
                /// ex:
                /// JSON: [Eggs, Beans, Toast]
                /// Core Data:
                /// Ingedient("Eggs", orderID: <Array Index, which is 0>)
                /// Ingredient("Toast", orderID: 2)
                ///
                /// Notes:
                /// array.enumerated() -> [(Index, Element)]
                /// - for (index, ingredient) in ingredients.enumerated() {
                ///
                /// When you read the ingredients from Core Data, sort them by orderID
                /// i.e.
                /// 1. Set -> Array ✅
                /// 2. array.sorted(by orderID)
                ///
                
                
                ingredientsArray.sort { ingredient1, ingredient2 in
                    return ingredient1.sortID < ingredient2.sortID
                }
                //                ingredientsArray.sort { $0.sortID < $1.sortID }
                
                for ingredient in ingredientsArray {
                    let ingredientString = "\(ingredient.quantity?.formattedIngredientQuantity ?? "") \(ingredient.name ?? "")"
                    
                    ingredientStrings.append(ingredientString)
                }
                
                
                let allIngredientsString = ingredientStrings.joined(separator: "\n")
                
                ingredientsLabel.text = allIngredientsString
                
            }
            
            if let photoData = recipe.photo {
                recipeImage.image = UIImage(data: photoData)
                
            }
            
            
            var instructionString = ""
            
            if var instructions = recipe.instructions?.allObjects as? [Step] {
                
                instructions.sort { $0.number < $1.number }
                
                for step in instructions {
                    instructionString.append("Step \(step.number): ")
                    instructionString.append("\(step.step ?? "")\n\n")
                }
            }
            
            instructionsLabel.text = instructionString
            
            if let nutrients = recipe.nutrients?.allObjects as? [Nutrient] {
                print(nutrients)
                if let calories = nutrients.first(where: {$0.name == "Calories"}) {
                    nutritionInformationLabel.text = "Calories: \(calories.amount.rounded().formatted())"
                }
            } else {
                print("This is where the calories should be showing")
                //                nutritionInformationLabel.text = ""
            }
        }
    }
}
