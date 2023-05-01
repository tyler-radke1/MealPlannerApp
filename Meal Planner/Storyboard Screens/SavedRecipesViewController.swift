//
//  SavedRecipesViewController.swift
//  Meal Planner
//
//  Created by Ami Smith on 4/18/23.
//

import UIKit

class SavedRecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RecipeTableViewCellDelegate {
    
    
    @IBOutlet weak var savedRecipesTableView: UITableView!
    
    private let context = PersistenceController.shared.viewContext
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
    
    let macaronIngredients = [
    Ingredient(name: "extra large egg whites", quantity: "4"),
    Ingredient(name: "confectioners' sugar", quantity: "1 2/3 c."),
    Ingredient(name: "almond flour", quantity: "1 1/3 c."),
    Ingredient(name: "salt", quantity: "1/8 tsp"),
    Ingredient(name: "superfine (castor) sugar", quantity: "1/4 c."),
    Ingredient(name: "seedless raspberry jam", quantity: "1/4 c.")
    ]
    
    let macaronInstructions = """
Instructions:

1. Place egg whites into a metal mixing bowl and refrigerate, 8 hours to overnight.

2. Remove egg whites from the refrigerator and bring to room temperature, 20 to 30 minutes.

3. Whisk confectioners' sugar and almond flour together in a bowl.

4. Add salt to egg whites and beat with an electric mixer on medium speed until foamy, about 1 minute. Increase the speed to high and gradually beat in superfine sugar, about 1 tablespoon at a time, until egg whites are glossy and hold stiff peaks, 3 to 5 more minutes.

5. Gently fold almond flour mixture into whipped egg whites until thoroughly incorporated. Spoon meringue into a pastry bag fitted with a 3/8-inch tip. Line two baking sheets with parchment paper.

6. Pipe 1-inch disks of meringue 2 inches apart onto the prepared baking sheets; batter will spread. Lift the baking sheets up a few inches and drop them gently onto the work surface several times to remove any air bubbles. Let stand at room temperature until the shiny surfaces dulls and a thin skin forms, about 15 minutes.

7. Meanwhile, preheat the oven to 280 degrees F (138 degrees C).

8. Place the baking sheets in the preheated oven and bake with the oven door cracked until cookies are completely dry on the surface, about 15 minutes. Remove from the oven and let cool completely on the baking sheets, about 30 minutes.

9. Gently peel parchment paper from cookies to remove. Spread 1/2 of the cookies with jam, then top with remaining cookies and press gently to push jam to the edges. Refrigerate until cookies soften, 2 hours to overnight.
"""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.savedRecipesTableView.dataSource = self
        self.savedRecipesTableView.delegate = self
        
<<<<<<< HEAD
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
        
        
        
        
=======
        
        recipes = [
        Recipe(name: "Scrambled Eggs", ingredients: scrambledEggsIngredients, instructions: scrambledEggsInstructions),
        Recipe(name: "PB & J Sandwich", ingredients: pbjIngredients, instructions: pbjInstructions),
        Recipe(name: "Macarons", ingredients: macaronIngredients, instructions: macaronInstructions)
        
        ]
>>>>>>> newDev
        
    }
    
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
