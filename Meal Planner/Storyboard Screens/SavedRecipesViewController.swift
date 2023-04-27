//
//  SavedRecipesViewController.swift
//  Meal Planner
//
//  Created by Ami Smith on 4/18/23.
//

import UIKit

class SavedRecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let context = PersistenceController.shared.viewContext
    var recipes: [Recipe] = []
    
    @IBOutlet weak var savedRecipesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.savedRecipesTableView.dataSource = self
        self.savedRecipesTableView.delegate = self
        
//        let scrambledEggsIngredients = [
//                    Ingredient(name: "Large eggs", quantity: "2"),
//                    Ingredient(name: "Butter", quantity: "1 tablespoon"),
//                    Ingredient(name: "Salt", quantity: "to taste"),
//                    Ingredient(name: "Pepper", quantity: "to taste")
//                ]
//        recipes = [
//        Recipe(name: "Scrambled Eggs", ingredients: scrambledEggsIngredients)]
        
        var recipe: Recipe {
            let  recipe = Recipe(context: context)
            recipe.name = "Scrambeled Eggs"
            
            let recipeIngredient = Ingredient(context: context)
            
            recipeIngredient.name = "Large eggs"
            recipeIngredient.quantity = "2"
            
            recipeIngredient.recipe = recipe
            
            let recipeIngredient2 = Ingredient(context: context)
            
            recipeIngredient2.name = "Butter"
            recipeIngredient2.quantity = "1 tablespoon"
            
            recipeIngredient2.recipe = recipe
            
            let recipeIngredient3 = Ingredient(context: context)
            
            recipeIngredient3.name = "Salt"
            recipeIngredient3.quantity = "to taste"
            
            recipeIngredient3.recipe = recipe
            
            let recipeIngredient4 = Ingredient(context: context)
            

            recipeIngredient4.name = "Pepper"
            recipeIngredient4.quantity = "to taste"
            
            recipeIngredient4.recipe = recipe
           
            
            
            
            
            return recipe
        }
        
        
        
        
        
    }
    // MARK: - Navigation
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "recipesTableViewCell", for: indexPath) as! RecipeTableViewCell
        
        let recipe = recipes[indexPath.row]
//        otherConfigureCell(cell: cell)
        cell.configure(with: recipe)
        return cell
    }
   
//    func otherConfigureCell(cell: RecipeTableViewCell) {
//
//    }

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func addToCalendarButtonTapped(_ sender: UIButton) {
    }
    
}
