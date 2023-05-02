//
//  RecipieFinderTableViewController.swift
//  Meal Planner
//
//  Created by Sterling Jenkins on 4/17/23.
//

import UIKit

class RecipeFinderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var recipes: [RecipieResult] = []
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    
    @IBOutlet weak var recipieNameTextField: UITextField!
    
    @IBOutlet weak var recipiesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        recipiesTableView.delegate = self
        recipiesTableView.dataSource = self
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "apiTableViewCell", for: indexPath) as! APIResultTableViewCell
        
        configureCell(for: cell, withIndexPath: indexPath)
        
        return cell
    }
    
    func configureCell(for cell: APIResultTableViewCell, withIndexPath indexPath: IndexPath) {
                
        let recipe = recipes[indexPath.row]
        
        cell.recipeTitleLabel.text = recipe.title
        
        imageLoadTasks[indexPath] =  Task {
            do {
                guard let urlString = recipe.image, let imageURL = URL(string: urlString) else { return }
                let image = try await retrieveRecipeImage(using: imageURL)
                cell.recipeimage.image = image
            } catch {
                print(error)
            }
        }
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = recipes[indexPath.row].id else { return }
        if viewedRecipes[indexPath] == nil {
            Task {
                do {
                    let recipeDetails = try await retrieveRecipieInfo(usingRecipieID: id)
                    viewedRecipes[indexPath] = recipeDetails
                    
                    // Diplay detail screen using viewedRecipes[indexPath]
                    print(viewedRecipes)
                } catch {
                    print(error)
                }
            }
        } else {
            // Diplay detail screen using viewedRecipes[indexPath]
            print("Already been selected")
        }
    }
    //MARK: - Search Functions
    
    @IBAction func searchByNameButtonTapped() {
        guard let text = recipieNameTextField.text else { return }
        
        if text.isEmpty {
            return // Replace later with random recipe search?
        } else {
            recipeNameSearch(using: text)
        }
        
        viewedRecipes = [:]
    }
    
    @IBAction func searchByIngredientsList() {
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
