//
//  IngredientViewController.swift
//  Meal Planner
//
//  Created by Vasiliy on 4/19/23.
//

import UIKit
//import

class IngredientListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
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
        let ingredient = Ingredient(name: ingredientName)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientsCell", for: indexPath) as! IngredientTableViewCell
        let ingredient = ingredients [indexPath.row]
        
        cell.configure(with: ingredient)
        return cell
    }

}
