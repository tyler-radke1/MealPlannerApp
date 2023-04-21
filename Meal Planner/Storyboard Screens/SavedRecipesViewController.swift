//
//  SavedRecipesViewController.swift
//  Meal Planner
//
//  Created by Ami Smith on 4/18/23.
//

import UIKit

class SavedRecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var recipes: [Recipe] = []
    
    @IBOutlet weak var savedRecipesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.savedRecipesTableView.dataSource = self
        self.savedRecipesTableView.delegate = self
        
        let scrambledEggsIngredients = [
                    Ingredient(name: "Large eggs", quantity: "2"),
                    Ingredient(name: "Butter", quantity: "1 tablespoon"),
                    Ingredient(name: "Salt", quantity: "to taste"),
                    Ingredient(name: "Pepper", quantity: "to taste")
                ]
        
        let scrambledEggsInstructions = """
"Instructions:
        
        1. Crack the eggs into a bowl and beat them with a fork.
        2. Melt the butter in a non-stick pan over medium heat.
        3. Pour the beaten eggs into the pan.
        4. Use a spatula to gently stir the eggs as they cook.
        5. When the eggs are set but still moist, remove them from the heat.
        6. Season with salt and pepper to taste.
"""
        
        recipes = [
        Recipe(name: "Scrambled Eggs", ingredients: scrambledEggsIngredients, instructions: scrambledEggsInstructions)]
        
    }
    // MARK: - Navigation
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "recipesTableViewCell", for: indexPath) as! RecipeTableViewCell
        
        let recipe = recipes[indexPath.row]

        cell.configure(with: recipe)
        return cell
    }
   


    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func addToCalendarButtonTapped(_ sender: UIButton) {
    }
    
}
