//
//  SavedRecipesViewController.swift
//  Meal Planner
//
//  Created by Ami Smith on 4/18/23.
//

import UIKit
import CoreData

class SavedRecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RecipeCellDelegate, UICalendarSelectionSingleDateDelegate, FavoritedRecipeDelegate, UICalendarViewDelegate {

    private let context = PersistenceController.shared.viewContext
    
    private var recipes: [Recipe] = []
    
    public static let shared = SavedRecipesViewController()
    
    @IBOutlet weak var savedRecipesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColor()
        savedRecipesTableView.setTableViewColor()
        
        self.savedRecipesTableView.dataSource = self
        self.savedRecipesTableView.delegate = self
        
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
        } catch {
            print("you oofed")
        }
        
        print("Recipes - \(recipes)")
        
        getRecipesFromCoreData()
        savedRecipesTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRecipesFromCoreData()
    }
    
    func configure(calendar: UICalendarView) {
        calendar.delegate = self
        
        let gregorian = Calendar(identifier: .gregorian)
        
        calendar.calendar = gregorian
        
        self.view.addSubview(calendar)
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        
        calendar.selectionBehavior = dateSelection
    }
    
    @objc func getRecipesFromCoreData() {
        self.recipes = []
        print("getRecipes called")
        let fetchRequest = NSFetchRequest<Recipe>(entityName: "Recipe")

        do {
            let results = try context.fetch(fetchRequest)

            for result in results {
               // print(result)
                recipes.append(result)
            }
        } catch {
            print("you oofed")
        }
        
        self.savedRecipesTableView.reloadData()
    }
    
    func saveRecipesToCoreData() {
        do {
            try context.save()
        } catch {
            print("ERROR")
        }
    }
    
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
    }
    
    func favoriteButtonTapped(cell: UITableViewCell) {
        
        guard let indexPath = savedRecipesTableView.indexPath(for: cell) else {
            return
        }
        
        let alertController = UIAlertController(title: "Delete Recipe", message: "Are you sure you want to remove this recipe from your favorites?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { [self] (action) in
            context.delete(recipes[indexPath.row])
            saveRecipesToCoreData()
            recipes.remove(at: indexPath.row)
            savedRecipesTableView.deleteRows(at: [indexPath], with: .automatic)
            
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
    
    func calendarButtonTapped(cell: UITableViewCell, passing recipe: Recipe?, or recipeResult: RecipieResult?) {
        guard let cell = cell as? RecipeTableViewCell, let indexPath = savedRecipesTableView.indexPath(for: cell) else {
            return
        }
        let recipe = recipes[indexPath.row]

        performSegue(withIdentifier: "segueToCalendar", sender: recipe)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipeDetails" {
            if let recipeDetailsVC = segue.destination as? RecipeDetailsViewController,
               let selectedRecipe = sender as? Recipe {
                recipeDetailsVC.recipe = selectedRecipe
            }
        }
        
        if segue.identifier == "segueToCalendar" {
            if let destination = segue.destination.children.last as? CalendarView {
                destination.favoriteRecipeToDisplay = sender as? Recipe
            } 
        }
    }
}
