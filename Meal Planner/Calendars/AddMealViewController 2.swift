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
    
    @IBOutlet weak var breakfastLunchDinnerPicker: UIPickerView!
    
    @IBOutlet weak var mealsToAddPicker: UIPickerView!
    
    var delegate: MealScheduleDelegate? = nil
    
    let meals = ["Breakfast", "Lunch", "Dinner"]
    
    var breakfastLunchDinnerSelected: MealType = .breakfast
    
    var selectedFood: Recipe? = nil
    
   // let mealOptions = ["Soup", "Pizza", "Ice Cream", "Grilled Cheese Sandwich"]
    
    var dateToAddMeal: Date? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let dateToAddMeal {
            datePicker.date = dateToAddMeal
        }
        
        breakfastLunchDinnerPicker.delegate = self
        breakfastLunchDinnerPicker.dataSource = self
        
        mealsToAddPicker.delegate = self
        mealsToAddPicker.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerView == breakfastLunchDinnerPicker ? 3 : DummyData.recipes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == breakfastLunchDinnerPicker {
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
        } else if pickerView == mealsToAddPicker {
            return DummyData.recipes[row].name
        }
        return "failure"
    }
    
    @IBAction func addMealButtonTapped(_ sender: UIButton) {
        guard let selectedFood else { return }
        delegate?.passDayPair(date: datePicker.date, recipe: selectedFood, meal: breakfastLunchDinnerSelected)
        self.navigationController?.popViewController(animated: true)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard pickerView == breakfastLunchDinnerPicker else {
            selectedFood = DummyData.recipes[row]
            return
        }
        switch pickerView.delegate?.pickerView?(pickerView, titleForRow: row, forComponent: component) {
        case "Breakfast":
            self.breakfastLunchDinnerSelected = .breakfast
        case "Lunch":
            self.breakfastLunchDinnerSelected = .lunch
        case "Dinner":
            self.breakfastLunchDinnerSelected = .dinner
        default:
            print("hello world")
        }
    }
}


class DummyData {
    private static var ingredient = Ingredient(name: "test", quantity: "test")
    private static let soup = Recipe(name: "Soup", ingredients: [ingredient])
    private static let iceCream = Recipe(name: "Ice Cream", ingredients: [ingredient])
    private static let pizza = Recipe(name: "Pizza", ingredients: [ingredient])
    private static let grilledCheese = Recipe(name: "Grilled Cheese Sandwich", ingredients: [ingredient])
    
    static var recipes = [soup, iceCream, pizza, grilledCheese]
}

