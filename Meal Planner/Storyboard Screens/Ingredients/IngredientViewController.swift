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
    
    private let context = PersistenceController.shared.viewContext
    
    var ingredients: [Ingredient] = []
      var isEditingEnabled = false
    
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
       // let ingredient = Ingredient(name: ingredientName, quantity: "23")
        var ingredient: Ingredient {
            let ingredient = Ingredient(context: context)
            ingredient.quantity = "23"
            ingredient.name = ingredientName
            return ingredient
        }
        
        ingredients.append(ingredient)
        tableview.reloadData()
        
        textField.text = ""
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
//        editmode
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

}
