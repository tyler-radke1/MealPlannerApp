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
    
    var ingredients: [Ingredient] = []
      var isEditingEnabled = false
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "IngredientsCoreData")
               container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                   if let error = error as NSError? {
                       fatalError("Unresolved error \(error), \(error.userInfo)")
    }
               })
                      return container
                  }()
                  
                  lazy var managedObjectContext: NSManagedObjectContext = {
                      let context = persistentContainer.viewContext
                      return context
                  }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableview.dataSource = self
        tableview.delegate = self
    }
//    IngredientTableViewCell
    @IBOutlet var editButton: UIButton!
    
    @IBOutlet var addButton: UIButton!
    
    @IBOutlet var textField: UITextField!
    
    
    @IBOutlet var tableview: UITableView!
    
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
//        textField
        guard let ingredientName = textField.text, !ingredientName.isEmpty else {
            return
        }
        
        let ingredient = Ingredient(name: ingredientName, quantity: "23")
        
        ingredients.append(ingredient)
        tableview.reloadData()
        
        textField.text = ""
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

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientsCell", for: indexPath)  as! IngredientTableViewCell
        let ingredient = ingredients [indexPath.row]
        
        cell.configure(with: ingredient)
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

}
