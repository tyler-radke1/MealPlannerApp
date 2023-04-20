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
        recipes = [
        Recipe(name: "Scrambled Eggs", ingredients: scrambledEggsIngredients)]
        
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
