//
//  SavedRecipesViewController.swift
//  Meal Planner
//
//  Created by Ami Smith on 4/18/23.
//

import UIKit

class SavedRecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RecipeTableViewCellDelegate {
    
    
    func favoriteButtonTapped(cell: RecipeTableViewCell) {
        
        guard let indexPath = savedRecipesTableView.indexPath(for: cell) else {
            return
        }
        let selectedRecipe = recipes[indexPath.row]

        let alertController = UIAlertController(title: "Delete Recipe", message: "Are you sure you want to remove this recipe from your recipes?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            self.recipes.remove(at: indexPath.row)
            self.savedRecipesTableView.deleteRows(at: [indexPath], with: .automatic)
            
            
        })
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    var recipes: [Recipe] = []
    
    let scrambledEggsIngredients = [
                Ingredient(name: "Large eggs", quantity: "2"),
                Ingredient(name: "Butter", quantity: "1 tablespoon"),
                Ingredient(name: "Salt", quantity: "to taste"),
                Ingredient(name: "Pepper", quantity: "to taste")
            ]
    
    let scrambledEggsInstructions = """
    Instructions:
    
    1. Crack the eggs into a bowl and beat them with a fork.
    2. Melt the butter in a non-stick pan over medium heat.
    3. Pour the beaten eggs into the pan.
    4. Use a spatula to gently stir the eggs as they cook.
    5. When the eggs are set but still moist, remove them from the heat.
    6. Season with salt and pepper to taste.
"""
    let pbjIngredients = [
        Ingredient(name: "Bread", quantity: "2 slices"),
        Ingredient(name: "Peanut Butter", quantity: "2 tablespoons"),
        Ingredient(name: "Jelly", quantity: "2 tablespoons")
    ]

    let pbjInstructions = """
    Instructions:

        1. Toast the bread (optional).
        2. Spread peanut butter on one slice of bread.
        3. Spread jelly on the other slice of bread.
        4. Put the two slices of bread together, with the peanut butter and jelly sides facing each other.
        5. Cut the sandwich in half (optional).
    """
    
    @IBOutlet weak var savedRecipesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.savedRecipesTableView.dataSource = self
        self.savedRecipesTableView.delegate = self
        
       
        
        recipes = [
        Recipe(name: "Scrambled Eggs", ingredients: scrambledEggsIngredients, instructions: scrambledEggsInstructions),
        Recipe(name: "PB & J Sandwich", ingredients: pbjIngredients, instructions: pbjInstructions)]
        
    }
    // MARK: - Navigation
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipesTableViewCell", for: indexPath) as! RecipeTableViewCell
        
        let recipe = recipes[indexPath.row]

        cell.configure(with: recipe)
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecipe = recipes[indexPath.row]
        performSegue(withIdentifier: "showRecipeDetails", sender: selectedRecipe)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipeDetails" {
            if let recipeDetailsVC = segue.destination as? RecipeDetailsViewController,
               let selectedRecipe = sender as? Recipe {
                recipeDetailsVC.recipe = selectedRecipe
            }
        }
    }

    
    @IBAction func addToCalendarButtonTapped(_ sender: UIButton) {
    }
    
}
