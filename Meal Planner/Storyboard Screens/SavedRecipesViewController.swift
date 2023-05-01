//
//  SavedRecipesViewController.swift
//  Meal Planner
//
//  Created by Ami Smith on 4/18/23.
//

import UIKit
import CoreData

class SavedRecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RecipeTableViewCellDelegate {
    
    private let context = PersistenceController.shared.viewContext
    
    var recipes: [Recipe] = []
    
    func favoriteButtonTapped(cell: RecipeTableViewCell) {
        
        guard let indexPath = savedRecipesTableView.indexPath(for: cell) else {
            return
        }
        
        let alertController = UIAlertController(title: "Delete Recipe", message: "Are you sure you want to remove this recipe from your favorites?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            
            self.context.delete(self.recipes[indexPath.row])
            do {
               try self.context.save()
            } catch {
                print("error")
            }
            
            self.recipes.remove(at: indexPath.row)
            self.savedRecipesTableView.deleteRows(at: [indexPath], with: .automatic)
            
            
            
        })
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var savedRecipesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        savedRecipesTableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "recipesTableViewCell")
        
        self.savedRecipesTableView.dataSource = self
        self.savedRecipesTableView.delegate = self
        
        
        
        
        
//        var recipe: Recipe {
//            let  recipe = Recipe(context: context)
//            recipe.name = "Scrambled Eggs"
//
//            let recipeIngredient = Ingredient(context: context)
//
//            recipeIngredient.name = "Large eggs"
//            recipeIngredient.quantity = "2"
//
//            recipeIngredient.recipe = recipe
//
//            let recipeIngredient2 = Ingredient(context: context)
//
//            recipeIngredient2.name = "Butter"
//            recipeIngredient2.quantity = "1 tablespoon"
//
//            recipeIngredient2.recipe = recipe
//
//            let recipeIngredient3 = Ingredient(context: context)
//
//            recipeIngredient3.name = "Salt"
//            recipeIngredient3.quantity = "to taste"
//
//            recipeIngredient3.recipe = recipe
//
//            let recipeIngredient4 = Ingredient(context: context)
//
//
//            recipeIngredient4.name = "Pepper"
//            recipeIngredient4.quantity = "to taste"
//
//            recipeIngredient4.recipe = recipe
//
//            recipe.instructions = """
//   Instructions:
//
//    1. Crack the eggs into a bowl and beat them with a fork.
//    2. Melt the butter in a non-stick pan over medium heat.
//    3. Pour the beaten eggs into the pan.
//    4. Use a spatula to gently stir the eggs as they cook.
//    5. When the eggs are set but still moist, remove them from the heat.
//    6. Season with salt and pepper to taste.
//"""
//
//            return recipe
//        }
        
        //recipes.append(recipe)
    
        //context.insert(recipe)
        
        do {
            try context.save()
        } catch {
            print("ERROR")
        }
        
        
        let fetchRequest = NSFetchRequest<Recipe>(entityName: "Recipe")

        do {
            let results = try context.fetch(fetchRequest)

            for result in results {
                print(result)
                recipes.append(result)
            }
        } catch let error as NSError {
            print("you oofed")
        }
        
        print("Recipes - \(recipes)")
        
        savedRecipesTableView.reloadData()
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
