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
    
//    func addButtonTapped(cell: IngredientTableViewCell) {
//        <#code#>
//    }
//
// MARK: Tray image
    private let context = PersistenceController.shared.viewContext

    var ingredients: [Ingredient] = []
    var ingredientsByCategories: [String : [Ingredient]] = [:]
    var headerViews = [Int: HeaderTableViewCell]()
    var categories: [String] = []
    var isEditingEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        hideKeyboardWhenTapped()
        setColor()
        fetchCategory()
        createFetchRequest()
        
        self.tableView.register(
            UINib(nibName: "IngredientHeader", bundle: nil),
            forCellReuseIdentifier: "headerCell"
        )

    }
    
//    func tableView(_ tableView: UITableView,
//            viewForHeaderInSection section: Int) -> UIView? {
//        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.reuseIdentifier) as! SectionHeaderView
//        view.textLabel?.text = categories[section]
//
//       return view
//    }

    @IBOutlet var editButton: UIButton!
    
    @IBOutlet var addButton: UIButton!
    
    @IBOutlet var textField: UITextField!
    
    @IBAction func textFieldReturnButtonTapped(_ sender: UITextField) {
        addIngredient()
        sender.endEditing(true)
    }
    
    @IBOutlet var tableView: UITableView!
    
    
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
    
    func fetchCategory() {
        let fetchRequet = NSFetchRequest<Category>(entityName: "Category")
        do {
            let results = try context.fetch(fetchRequet)
            
            ingredientsByCategories["Uncategorized"] = []
            categories.append("Uncategorized")
            
            for category in results {
                ingredientsByCategories[category.categoryName!] = []
                categories.append(category.categoryName!)
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
                     //Commented out in merge, not sure if needed
//                     if result.recipe == nil {
//                         self.ingredients.append(result)
//                     }

                     switch result.category {
                     case nil:
                         if let noCategoryArray = ingredientsByCategories["Uncategorized"]{
                             ingredientsByCategories["Uncategorized"]!.append(result)
                         }
//                         else {
////                             categories.append("Uncaterized")
//                             ingredientsByCategories["Uncategorized"] = [result]
//                         }
                         
                     default:
                         guard  let categoryName = result.category?.categoryName else {
                             print("noCategoryName")
                             continue
                         }
                         if let categoryArray = ingredientsByCategories[categoryName]{
                             ingredientsByCategories[categoryName]!.append(result)
                         }
//                         else {
//                             ingredientsByCategories[categoryName] = [result]
//                         }
                     }
//                     self.ingredients.append(result)
                 }
                 ingredients = results
             } catch {
                 print("Failed to access ingredients")
             }
             
    }
    @IBAction func addButtonTapped(_ sender: Any) {
        addIngredient()
    }
    
    func addIngredient() {
        guard let ingredientName = textField.text, !ingredientName.isEmpty else {
            return
        }
        
//        let ingredient = Ingredient(name: ingredientName, quantity: "23") Ingredient
        
//        var ingredient: Ingredient {
            let ingredient = Ingredient(context: /* AppDelegate().managedObjectContext */  context)
            ingredient.quantity = "23"
            ingredient.name = ingredientName
//            ingredient.index = Int64(ingredients.count - 1)

//            return ingredient
//        }
        
        
        do {
            try context.save()
        } catch {
            print("Failed to save ingredient")
        }
        if ingredient.category == nil {
            ingredientsByCategories["Uncategorized"]?.append(ingredient)
//            tableView.insertRows(at: [0], with: .automatic)
        } else {
            ingredientsByCategories[ingredient.category!.categoryName!]?.append(ingredient)
        }
//        ingredients.append(ingredient)
        tableView.reloadData()
        
        textField.text = ""
    }
    //Tyler's Code
    
        
    @IBAction func editButtonTapped(_ sender: Any) {
//        editmode
        isEditingEnabled.toggle()
        tableView.setEditing(isEditingEnabled, animated: true)
        
        headerViews.values.forEach { headerView in
            if headerView.sectionLabel.text != "Uncategorized" {
                headerView.deleteSectionButton.isHidden = !isEditingEnabled
            }
        }
    }
    //    MARK: Managing navigation
//    let ingreadientListViewController = IngredientListViewController()
//    navigationController.pushViewController(ingreadientListViewController, animated: true)
    //
    
    
    
   
    
    
    

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
//MARK: i dont like alphibeticle order while i working on moving the rows
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let movedIngredient = ingredients[sourceIndexPath.row]
//        ingredients.remove(at: sourceIndexPath.row)
//        ingredients.insert(movedIngredient, at: destinationIndexPath.row)
//        for (index, ingredient) in ingredients.enumerated() {
//            ingredient.index = CoreDataIndexPath(indexPath: index)
//        }
        
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
     
    func numberOfSections(in tableView: UITableView) -> Int {
//        return categories.count + 1
//        if let noCategory = ingredientsByCategories["Uncategorized"] {
//            return categories.count + 1
//        }else{

            return categories.count
//        }
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
//        let label = UILabel()
//        label.text = categories[section]
//
//        let button = UIButton()
//        var config = UIButton.Configuration.bordered()
//        config.title = "REMOVE"
//        button.configuration = config
//        button.isHidden = !tableView.isEditing
//
//        let hStack = UIStackView(arrangedSubviews: [label, button])
//        hStack.axis = .horizontal
//        hStack.insetsLayoutMarginsFromSafeArea = true

        headerViews[section] = cell

        return cell

    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        guard !categories.isEmpty else{ return nil }
//
////        switch section {
////        case 0:
//////            if let noCategory = ingredientsByCategories["Uncategorized"] {
//////                return "Uncategorized"
//////            } else {
////                return categories[0]
//////            }
////        default:
////            if let noCategory = ingredientsByCategories["Uncategorized"] {
////                return categories[section - 1]
////            } else {
//                return categories[section]
////            }
//        }

//        return section == 0 ? "Uncategorized" : categories[section - 1].categoryName
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//         return ingredients.count
//        switch section {
//        case 0:
//            if let noCategory = ingredientsByCategories["Uncategorized"] {
//                return noCategory.count
//            } else {
//                return ingredientsByCategories[categories[0]]!.count
//            }
//        default:
//            if let noCategory = ingredientsByCategories["Uncategorized"] {
//                return ingredientsByCategories[categories[section - 1]]!.count
//            } else {
                return ingredientsByCategories[categories[section]]!.count
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientsCell", for: indexPath)  as! IngredientTableViewCell
//        let ingredient = ingredients [indexPath.row]
        
//        switch indexPath.section {
//        case 0:
//            if let noCategory = ingredientsByCategories["Uncategorized"] {
//                let ingredient = ingredientsByCategories["Uncategorized"]![indexPath.row]
//                cell.configure(with: ingredient)
//            } else {
//                let ingredient = ingredientsByCategories[categories[indexPath.section]]![indexPath.row]
//                cell.configure(with: ingredient)
//            }
//        default:
//            if let noCategory = ingredientsByCategories["Uncategorized"] {
//                let ingredient = ingredientsByCategories[categories[indexPath.section - 1]]![indexPath.row]
//                cell.configure(with: ingredient)
//            } else {
                let ingredient = ingredientsByCategories[categories[indexPath.section]]![indexPath.row]

                cell.configure(with: ingredient)
//            }
//        }
        
        
        
//        cell.delegate = self
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            
//            tableView.deleteRows(at: [indexPath], with: .fade)
            self.context.delete(self.ingredientsByCategories[categories[indexPath.section]]![indexPath.row])
            do {
                try self.context.save()
            } catch {
                print("Failed to save")
            }
//            self.ingredients.remove(at: indexPath.row)
//            if let noCategory = ingredientsByCategories["Uncategorized"] {
//                if indexPath.section != 0 {
//                    self.ingredientsByCategories[categories[indexPath.section - 1]]?.remove(at: indexPath.row)
//                } else {
//                    self.ingredientsByCategories["Uncategorized"]?.remove(at: indexPath.row)
//                }
//
//            } else {
            
                self.ingredientsByCategories[categories[indexPath.section]]?.remove(at: indexPath.row)
//            }
           
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
        }
    }
    
}
