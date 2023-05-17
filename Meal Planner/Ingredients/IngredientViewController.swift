//
//  NewIngredientViewControllerClass.swift
//  Meal Planner
//
//  Created by Tyler Radke on 4/20/23.
//

import Foundation
import UIKit
import CoreData

class IngredientViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HeaderTableViewCellDelegate {
    
    private let context = PersistenceController.shared.viewContext

    var ingredients: [Ingredient] = []
    var ingredientsByCategories: [String : [Ingredient]] = [:]
    var headerViews = [Int: HeaderTableViewCell]()
    var categories: [String] = []
    var isEditingEnabled = false
    
    @IBOutlet var editButton: UIButton!
    
    @IBOutlet var addButton: UIButton!
    
    @IBOutlet var textField: UITextField!

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        createFetchRequest()
        hideKeyboardWhenTapped()
        setColor()
        fetchCategory()
        
        self.tableView.register(
            UINib(nibName: "IngredientHeader", bundle: nil),
            forCellReuseIdentifier: "headerCell"
        )

    }
    
    func deleteSectionButtonTapped(forCell cell: HeaderTableViewCell) {
        do {
            guard let section = cell.section else { return }
            
            let header = headerViews.remove(at: headerViews.index(forKey: section)!)
            
            guard let headerTitle = header.value.sectionLabel.text else {return}
            let ingredientsForHeader = ingredientsByCategories[headerTitle]
            
            for (_, ingredient) in ingredientsForHeader!.enumerated() {
                ingredient.sectionIndex = 0
                ingredientsByCategories["Uncategorized"]!.append(ingredient)
                ingredient.rowIndex = Int64(ingredientsByCategories["Uncategorized"]!.count - 1)
            }
            
            let fetchRequet = NSFetchRequest<Category>(entityName: "Category")

            let results = try context.fetch(fetchRequet)
            context.delete(results[section - 1])
        
            try context.save()
            
            ingredientsByCategories.remove(at: ingredientsByCategories.index(forKey: headerTitle)!)
            categories.remove(at: section)
            
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    func fetchCategory() {
        let fetchRequet = NSFetchRequest<Category>(entityName: "Category")
        do {
            let results = try context.fetch(fetchRequet)
            
            ingredientsByCategories["Uncategorized"] = []
            categories.append("Uncategorized")
            
            for category in results {
                guard let categoryName = category.categoryName else { continue }
                categories.append(categoryName)
                ingredientsByCategories[categoryName] = category.ingredients?.allObjects as? Array<Ingredient>
            }
        }catch {
            print(error)
        }
    }
    
    func createFetchRequest() {
        let request = NSFetchRequest<Ingredient>(entityName: "Ingredient")
        let sectionSortDescriptor = NSSortDescriptor(key: "sectionIndex", ascending: true)
        let rowSortDescriptor = NSSortDescriptor(key: "rowIndex", ascending: true)
        
        
        request.sortDescriptors = [sectionSortDescriptor, rowSortDescriptor]
             do {
                 let results = try context.fetch(request)
 
                 for result in results {
                     switch result.category {
                     case nil:
                         if let noCategoryArray = ingredientsByCategories["Uncategorized"]{
                             ingredientsByCategories["Uncategorized"]!.append(result)
                         }
               
                     default:
                         guard  let categoryName = result.category?.categoryName else {
                             print("noCategoryName")
                             continue
                         }
                         if let categoryArray = ingredientsByCategories[categoryName]{
                             ingredientsByCategories[categoryName]!.append(result)
                         }
                     }

                 }
                 ingredients = results
             } catch {
                 print("Failed to access ingredients")
             }
             
    }
    
    func addIngredientCd(ingredient: Ingredient) {
        do {
            try context.save()
        } catch {
            print("Failed to save ingredient")
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {

        guard let ingredientName = textField.text, !ingredientName.isEmpty else {
            return
        }

            let ingredient = Ingredient(context: /* AppDelegate().managedObjectContext */  context)
            ingredient.quantity = "23"
            ingredient.name = ingredientName
        
        addIngredientCd(ingredient: ingredient)
        if ingredient.category == nil {
            ingredientsByCategories["Uncategorized"]?.append(ingredient)
        } else {
            ingredientsByCategories[ingredient.category!.categoryName!]?.append(ingredient)
        }
        tableView.reloadData()
        
        textField.text = ""
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        isEditingEnabled.toggle()
        tableView.setEditing(isEditingEnabled, animated: true)
        
        headerViews.values.forEach { headerView in
            if headerView.sectionLabel.text != "Uncategorized" {
                headerView.deleteSectionButton.isHidden = !isEditingEnabled
            }
        }
    }
    
    @IBAction func addSectionButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Section", message: "Are you Sure to add Section?", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter Section Name..."
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           alertController.addAction(cancelAction)
           
        let addAction = UIAlertAction(title: "Add", style: .default) { [self] (action) in
                if let sectionName = alertController.textFields?.first?.text {
                    // Code to add the new section with the given name
                    let category = Category(context: context)
                    category.categoryName = sectionName
                    
                    do {
                       try context.save()
                        ingredientsByCategories[category.categoryName!] = []
                        categories.append(category.categoryName!)
                        tableView.reloadData()
                    } catch {
                        print(error)
                    }
                    
                }
            }
            alertController.addAction(addAction)

            present(alertController, animated: true, completion: nil)
        }
    
    //    MARK: Managing navigation
    func numberOfSections(in tableView: UITableView) -> Int {
            return categories.count
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedIngredient = ingredientsByCategories[categories[sourceIndexPath.section]]![sourceIndexPath.row]
        
        ingredientsByCategories[categories[sourceIndexPath.section]]!.remove(at: sourceIndexPath.row)
        ingredientsByCategories[categories[destinationIndexPath.section]]!.insert(movedIngredient, at: destinationIndexPath.row)
        
        for (sectionIndex, category) in categories.enumerated() {
            for (rowIndex, ingredient) in ingredientsByCategories[category]!.enumerated() {
                ingredient.sectionIndex = Int64(sectionIndex)
                ingredient.rowIndex = Int64(rowIndex)
                
                if sectionIndex != 0 {
                    let fetchRequet = NSFetchRequest<Category>(entityName: "Category")
                    do {
                        let results = try context.fetch(fetchRequet)
                        
                        ingredient.category = results[sectionIndex - 1]
                    }catch {
                        print(error)
                    }
                } else {
                    ingredient.category = nil
                }
            }
        }
        
        do {
            try context.save()
            
        } catch {
            print("🔥 ERROR: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !categories.isEmpty else{
            print("Guard hit")
            return nil
            
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
                
        cell.delegate = self
        
        cell.section = section
        
        cell.sectionLabel.text = categories[section]
        
        cell.deleteSectionButton.isHidden = section == 0 ? true : !tableView.isEditing

        headerViews[section] = cell

        return cell

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return ingredientsByCategories[categories[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientsCell", for: indexPath)  as! IngredientTableViewCell

                let ingredient = ingredientsByCategories[categories[indexPath.section]]![indexPath.row]

                cell.configure(with: ingredient)

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
    
            self.context.delete(self.ingredientsByCategories[categories[indexPath.section]]![indexPath.row])
            do {
                try self.context.save()
            } catch {
                print("Failed to save")
            }

                self.ingredientsByCategories[categories[indexPath.section]]?.remove(at: indexPath.row)

            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
        }
    }
    
}
