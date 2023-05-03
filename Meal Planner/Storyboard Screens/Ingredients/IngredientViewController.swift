//
//  NewIngredientViewControllerClass.swift
//  Meal Planner
//
//  Created by Tyler Radke on 4/20/23.
//

import Foundation
import UIKit
import CoreData

class IngredientViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    func addButtonTapped(cell: IngredientTableViewCell) {
//        <#code#>
//    }
//
// MARK: Tray image
    private let context = PersistenceController.shared.viewContext

    var ingredients: [Ingredient] = []
      var isEditingEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableview.dataSource = self
        tableview.delegate = self
        
        createFetchRequest()
    }

    @IBOutlet var editButton: UIButton!
    
    @IBOutlet var addButton: UIButton!
    
    @IBOutlet var textField: UITextField!
    
    
    @IBOutlet var tableview: UITableView!
    
    
    
    func createFetchRequest() {
        let request = NSFetchRequest<Ingredient>(entityName: "Ingredient")
        let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
        request.sortDescriptors = [sortDescriptor]
             do {
                 let results = try context.fetch(request)
                 
                 for result in results {
                     self.ingredients.append(result)
                 }
             } catch {
                 print("Failed to access ingredients")
             }
             
    }
    @IBAction func addButtonTapped(_ sender: Any) {
//        textField
        guard let ingredientName = textField.text, !ingredientName.isEmpty else {
            return
        }
        
//        let ingredient = Ingredient(name: ingredientName, quantity: "23") Ingredient
        
//        var ingredient: Ingredient {
            let ingredient = Ingredient(context: /* AppDelegate().managedObjectContext */  context)
            ingredient.quantity = "23"
            ingredient.name = ingredientName
        ingredient.index = Int64(ingredients.count - 1)
//            return ingredient
//        }
        
        
        addIngredientCd(ingredient: ingredient)
        ingredients.append(ingredient)
        tableview.reloadData()
        
        textField.text = ""
    }
    
    //Tyler's Code
    
    func addIngredientCd(ingredient: Ingredient) {
       // context.insert(ingredient)
        
        do {
            try context.save()
        } catch {
            print("Failed to save ingredient")
        }
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
//        editmode
        isEditingEnabled.toggle()
        tableview.setEditing(isEditingEnabled, animated: true)
    }
    //    MARK: Managing navigation
//    let ingreadientListViewController = IngredientListViewController()
//    navigationController.pushViewController(ingreadientListViewController, animated: true)
    //
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return ingredients.count
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
//MARK: i dont like alphibeticle order while i working on moving the rows
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedIngredient = ingredients[sourceIndexPath.row]
        ingredients.remove(at: sourceIndexPath.row)
        ingredients.insert(movedIngredient, at: destinationIndexPath.row)
        for (index, ingredient) in ingredients.enumerated() {
            ingredient.index = Int64(index)
        }
        do {
            try context.save()
            
        } catch {
            print("🔥 ERROR: \(error)")
        }
    }
       
       
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientsCell", for: indexPath)  as! IngredientTableViewCell
        let ingredient = ingredients [indexPath.row]
        
        cell.configure(with: ingredient)
        
//        cell.delegate = self
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            
//            tableView.deleteRows(at: [indexPath], with: .fade)
            self.context.delete(self.ingredients[indexPath.row])
            do {
                try self.context.save()
            } catch {
                print("Failed to save")
            }
            self.ingredients.remove(at: indexPath.row)
            self.tableview.deleteRows(at: [indexPath], with: .automatic)
//            self.tableview.reloadData()
        }
    }
    
}
