//
//  RecipieFinderTableViewController.swift
//  Meal Planner
//
//  Created by Sterling Jenkins on 4/17/23.
//

import UIKit
import CoreData

protocol FavoritedRecipeDelegate {
    func getRecipesFromCoreData()
    func saveRecipesToCoreData()
}

class RecipeFinderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RecipeCellDelegate {
    private let context = PersistenceController.shared.viewContext
    
    var delegate: FavoritedRecipeDelegate? = SavedRecipesViewController.shared
    
    var recipes: [RecipieResult] = []
    
    var favoritedRecipes: [Recipe] = []
    
    var ingredientsList = [Ingredient]()
    
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    
    var setButtonStateTasks: [IndexPath: Task<Void, Never>] = [:]
    
    var viewedRecipes = [IndexPath:ViewedRecipe]()
    
    var lastSearch: String = ""
    
    @IBOutlet weak var recipieNameTextField: UITextField!
    
    @IBOutlet weak var recipiesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipiesTableView.delegate = self
        recipiesTableView.dataSource = self
        
        hideKeyboardWhenTapped()
        setColor()
        recipiesTableView.setTableViewColor()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoritedRecipes = []
        ingredientsList = []
        
        recipiesTableView.reloadData()
        
        fetchCoreDataIngredients()
        fetchCoreDataRecipes()
    }
    
    func fetchCoreDataIngredients() {
        let fetchRequest = NSFetchRequest<Ingredient>(entityName: "Ingredient")

        do {
            let results = try context.fetch(fetchRequest)

            for ingredient in results {
                if ingredient.recipe == nil {
                    ingredientsList.append(ingredient)
                }
            }
        } catch {
            print("you oofed")
        }
    }
    
    func fetchCoreDataRecipes() {
        let fetchRequest = NSFetchRequest<Recipe>(entityName: "Recipe")

        do {
            let results = try context.fetch(fetchRequest)

            for result in results {
                favoritedRecipes.append(result)
            }
        } catch {
            print("you oofed")
        }
    }
    
    func favoriteButtonTapped(cell: UITableViewCell, calendarView: Bool = false) {
        guard let cell = cell as? RecipeTableViewCell, let indexPath = recipiesTableView.indexPath(for: cell) else { return }
        var recipeForCalendarView: Recipe? = nil
        Task {
            var selectedRecipe = viewedRecipes[indexPath]
            
            if viewedRecipes[indexPath] == nil {
                do {
                    selectedRecipe = try await recipieDetailsSearch(using: indexPath)
                } catch {
                    print(error)
                }
            }
            
            let recipeToSave = recipes[indexPath.row]
            guard let recipeDetailsToSave = selectedRecipe else {
                return
            }
            
            if cell.favoriteButton.isSelected || calendarView {
                let recipe = Recipe(context: self.context)
                
                recipe.id = Int64(recipeToSave.id!)
                recipe.name = recipeDetailsToSave.name
                recipe.photo = cell.recipeImage.image?.pngData()
                
                if let ingredients = recipeDetailsToSave.ingredients {
                    for (index, ingredient) in ingredients.enumerated() {
                        let savedIngredient = Ingredient(context: context)
                        savedIngredient.name = ingredient.name
                        savedIngredient.quantity = ingredient.quantity
                        savedIngredient.recipe = recipe
                        savedIngredient.sortID = Int64(index)
                    }
                }
                
                if let instructions = recipeDetailsToSave.instructions, instructions.count != 0 {
                    
                    for step in instructions.first!.steps {
                        let savedStep = Step(context: context)
                        savedStep.number = Int16(step.number)
                        savedStep.step = step.step
                        savedStep.recipe = recipe
                    }
                }
                
                if let nutrients = recipeDetailsToSave.nutrition?.nutrients {
                    for nutrient in nutrients {
                        let savedNutrient = Nutrient(context: context)
                        savedNutrient.name = nutrient.name
                        savedNutrient.amount = nutrient.amount
                        savedNutrient.recipe = recipe
                    }
                }
                
                favoritedRecipes.append(recipe)
                recipeForCalendarView = recipe
                
                print("Successfully created recipe!")
                
                do {
                    try context.save()
                    print("Sucessfully saved context!")
                } catch {
                    print("Failed to save recipe")
                }
            }  else {
                guard let recipeId = recipes[indexPath.row].id else { return }
                
                if let indexOfRecipeToDelete = favoritedRecipes.firstIndex(where: { $0.id == recipeId}) {
                    //recipeForCalendarView = favoritedRecipes.first(where: { $0.id == recipeId })
                    let recipeToDelete = favoritedRecipes.remove(at: indexOfRecipeToDelete)
                    self.context.delete(recipeToDelete)
                    print("Succesfully deleted")
                } else {
                    print("Couldn't find matching id")
                }
            }
            do {
                try context.save()
                print("Sucessfully saved context!")
                
                if calendarView {
                    performSegue(withIdentifier: "segueToCalendar", sender: recipeForCalendarView)
                }
            } catch {
                print("Failed to save recipe")
            }

        }
        
    }

    func calendarButtonTapped(cell: UITableViewCell, passing recipe: Recipe?, or recipeResult: RecipieResult?) {
        (cell as? RecipeTableViewCell)?.favoriteButton.isSelected = true
       favoriteButtonTapped(cell: cell, calendarView: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? Recipe else { return }
        if segue.identifier == "segueToCalendar" {
            if let destination = segue.destination.children.last as? CalendarView {
                destination.favoriteRecipeToDisplay = sender
            }
        }
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "apiTableViewCell", for: indexPath) as! RecipeTableViewCell
    
        configureCell(for: cell, withIndexPath: indexPath)
        return cell
    }
    
    func configureCell(for cell: RecipeTableViewCell, withIndexPath indexPath: IndexPath) {
        cell.setCellColor()

        let recipe = recipes[indexPath.row]
        
        cell.recipeResult = recipe
        
        cell.recipeNameLabel.text = recipe.title
        
        cell.delegate = self
        
        setButtonStateTasks[indexPath] = Task {
            guard let recipeId = recipe.id else { return }
            let check = favoritedRecipes.first(where: { $0.id == recipeId })
            
            cell.favoriteButton.isSelected = (check == nil ? false : true)
        }
        
        imageLoadTasks[indexPath] = Task {
            do {
                guard let urlString = recipe.image, let imageURL = URL(string: urlString) else { return }
                let image = try await retrieveRecipeImage(using: imageURL)
                cell.recipeImage.image = image
            } catch {
                print(error)
            }
        }
    }
    
    
    func loadRecipeIfNeeded(using indexPath: IndexPath) async throws ->
    ViewedRecipe {
        if let viewedRecipe = viewedRecipes[indexPath] {
            return viewedRecipe
        } else {
            let recipeDetails = try await recipieDetailsSearch(using: indexPath)
            viewedRecipes[indexPath] = recipeDetails
            return recipeDetails
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecipe = viewedRecipes[indexPath]
        //        performSegue(withIdentifier: "showRecipeDetails", sender: selectedRecipe)
        if let detailVC = UIStoryboard(name: "Saved Recipes", bundle: .main).instantiateViewController(withIdentifier: "recipeDetailView") as? RecipeDetailsViewController {
            Task {
                do {
                    let recipeDetails = try await loadRecipeIfNeeded(using: indexPath)
                    
                    // Diplay detail screen using viewedRecipes[indexPath]
                    
                    DispatchQueue.main.async {
                        
                        detailVC.viewedRecipe = recipeDetails
                        detailVC.viewedRecipeImage = (tableView.cellForRow(at: indexPath) as! RecipeTableViewCell).recipeImage.image
                        
                        self.present(detailVC, animated: true, completion: nil)

                        tableView.deselectRow(at: indexPath, animated: true)
                        
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    //MARK: - Search Functions
    
    @IBAction func searchTextField(_ sender: UITextField) {
        searchByName()
        sender.endEditing(true)
    }
    
    @IBAction func searchByNameButtonTapped() {
        searchByName()
    }
    
    func searchByName() {
        guard let text = recipieNameTextField.text, text != lastSearch else { return }
        
        lastSearch = text
        
        if text.isEmpty {
            return // Replace later with random recipe search?
        } else {
            recipeNameSearch(using: text)
        }
        
        viewedRecipes = [:]
    }
    
    @IBAction func searchByIngredientsList() {
        if !ingredientsList.isEmpty {
            recipeIngredientsListSearch(using: ingredientsList)
        }
    }
    
    func recipeNameSearch(using text: String) {
        Task {
            do {
                let results = try await recipieSearchByName(using: text)
                
                self.recipes = results.recipes ?? []
                
                recipiesTableView.reloadData()
            }
        }
    }
    
    func recipeIngredientsListSearch(using ingredients: [Ingredient]) {
        Task {
            do {
                let results = try await recipieSearchByIngredientsList(using: ingredients)
                
                self.recipes = results
                
                recipiesTableView.reloadData()
            }
        }
    }
    
    func recipieDetailsSearch(using indexPath: IndexPath) async throws -> ViewedRecipe {
        
        let fecthedRecipe = recipes[indexPath.row]
        
        guard let id = fecthedRecipe.id else { throw APIErrors.fetchRecipeDetailsFailed }
        
        let recipeDetails = try await retrieveRecipieInfo(usingRecipieID: id)
        viewedRecipes[indexPath] = recipeDetails
        
        return recipeDetails
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showRecipeDetails" {
//            if let recipeDetailsVC = segue.destination as? RecipeDetailsViewController,
//               let selectedRecipe = sender as? Recipe {
//                recipeDetailsVC.recipe = selectedRecipe
//            }
//        }
    
}
