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
    var viewedRecipe: ViewedRecipe?
    var viewedRecipeImage: UIImage?
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
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
        if let recipe = recipe {
            recipeNameLabel.text = recipe.name
            
            var ingredientStrings: [String] = []
            
            if let ingredientsSet = recipe.ingredients as? Set<Ingredient> {
                var ingredientsArray = Array(ingredientsSet)
                
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
        } else if let recipe = viewedRecipe {
            recipeNameLabel.text = recipe.name
            
            var ingredientStrings: [String] = []
            
            if let ingredientsSet = recipe.ingredients {
                var ingredientsArray = ingredientsSet
                
                for ingredient in ingredientsArray {
                    let ingredientString = "\(ingredient.quantity.formattedIngredientQuantity) \(ingredient.name)"
                    
                    ingredientStrings.append(ingredientString)
                }
                
                
                let allIngredientsString = ingredientStrings.joined(separator: "\n")
                
                ingredientsLabel.text = allIngredientsString
                
                if let viewedRecipeImage = viewedRecipeImage {
                    recipeImage.image = viewedRecipeImage
                }
            }
            
            var instructionString = ""
            
            if var instructionsArray = recipe.instructions {
                
                for instructions in instructionsArray {
                    for step in instructions.steps {
                        instructionString.append(instructions.name)
                        instructionString.append("Step \(step.number): ")
                        instructionString.append("\(step.step ?? "")\n\n")
                    }
                }
            }
            
            instructionsLabel.text = instructionString
            
            if let nutrients = recipe.nutrition?.nutrients {
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
