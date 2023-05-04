//
//  SavedRecipesViewController.swift
//  Meal Planner
//
//  Created by Ami Smith on 4/18/23.
//

import UIKit
import CoreData

class SavedRecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RecipeTableViewCellDelegate, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
   
    
    private let context = PersistenceController.shared.viewContext
    
    var recipes: [Recipe] = []
    
    func favoriteButtonTapped(cell: RecipeTableViewCell) {
        
        guard let indexPath = savedRecipesTableView.indexPath(for: cell) else {
            return
        }
        
        let alertController = UIAlertController(title: "Delete Recipe", message: "Are you sure you want to remove this recipe from your favorites?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
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
        
        savedRecipesTableView.reloadData()
    }
    
    func configure(calendar: UICalendarView) {
        calendar.delegate = self
        
        let gregorian = Calendar(identifier: .gregorian)
        
        calendar.calendar = gregorian
        
        self.view.addSubview(calendar)
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        
        calendar.selectionBehavior = dateSelection
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
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
    
    func calendarButtonTapped(cell: RecipeTableViewCell) {
        guard let indexPath = savedRecipesTableView.indexPath(for: cell) else {
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
            let destination = segue.destination as? CalendarView
            destination?.addingSavedRecipe = sender as? Recipe
        }
    }
}
