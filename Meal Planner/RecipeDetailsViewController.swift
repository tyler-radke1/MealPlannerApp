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
                let ingredientsArray = Array(ingredientsSet)
                
                for ingredient in ingredientsArray {
                    let ingredientString = "\(ingredient.quantity ?? "") - \(ingredient.name ?? "")"
                    
                    ingredientStrings.append(ingredientString)
                }
                
                let allIngredientsString = ingredientStrings.joined(separator: "\n")
                
                ingredientsLabel.text = allIngredientsString
                
            }
            
             if let photoData = recipe.photo {
                recipeImage.image = UIImage(data: photoData)
            }
            
            instructionsLabel.text = recipe.instructions
        }
    }
}
