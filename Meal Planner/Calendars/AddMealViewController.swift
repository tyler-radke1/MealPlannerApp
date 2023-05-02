//
//  AddMealViewController.swift
//  Meal Planner
//
//  Created by Tyler Radke on 4/24/23.
//

import UIKit

class AddMealViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var mealsToAddPicker: UIPickerView!
    
    var delegate: MealScheduleDelegate? = nil
    
    let meals = ["Breakfast", "Lunch", "Dinner"]

    var selectedFood: Recipe? = nil
    
    var dateToAddMeal: Date? = nil
    
    var addingBreakfastLunchDinner: MealType = .breakfast
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mealsToAddPicker.delegate = self
        mealsToAddPicker.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return DummyData.recipes[row].name
    }
    
    @IBAction func addMealButtonTapped(_ sender: UIButton) {
        guard let selectedFood, let dateToAddMeal else { return }
        delegate?.passDayPair(date: dateToAddMeal, recipe: selectedFood, meal: addingBreakfastLunchDinner)
        self.navigationController?.popViewController(animated: true)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedFood = DummyData.recipes[row]
    }
}



