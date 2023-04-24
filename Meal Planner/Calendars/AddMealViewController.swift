//
//  AddMealViewController.swift
//  Meal Planner
//
//  Created by Tyler Radke on 4/24/23.
//

import UIKit

protocol MealScheduleDelegate {
    func passDayPair(date: Date, recipe: Recipe, meal: MealType)
}

class AddMealViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
 
   @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var mealTypePicker: UIPickerView!
    
    @IBOutlet weak var mealOptionsPicker: UIPickerView!
    
    var delegate: MealScheduleDelegate? = nil
    
    let meals = ["Breakfast", "Lunch", "Dinner"]
    
    let mealOptions = ["Soup", "Pizza", "Ice Cream", "Grilled Cheese Sandwich"]
    
    var dateToAddMeal: Date? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let dateToAddMeal {
            datePicker.date = dateToAddMeal
        }
        
        mealTypePicker.delegate = self
        mealTypePicker.dataSource = self
        
        mealOptionsPicker.delegate = self
        mealOptionsPicker.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerView == mealTypePicker ? 3 : mealOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == mealTypePicker {
            switch row {
            case 0:
                return meals[0]
            case 1:
                return meals[1]
            case 2:
                return meals[2]
            default:
                return "Your Mom"
            }
        } else if pickerView == mealOptionsPicker {
            return mealOptions[row]
        }
        return "failure"
    }
    
    @IBAction func addMealButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        let ingredient = Ingredient(name: "test", quantity: "Test")
        //let recipe
        //delegate?.passDayPair(date: datePicker.date, recipe: Recipe(name: m, ingredients: <#T##[Ingredient]#>), meal: <#T##MealType#>)
    }
    
}
