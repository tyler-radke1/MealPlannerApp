//
//  CalendarView.swift
//  Meal Planner
//
//  Created by Tyler Radke on 4/17/23.
//

import UIKit

enum MealType: String {
    case breakfast = "breakfast"
    case lunch = "lunch"
    case dinner = "dinner"
}

class CalendarView: UIViewController, UICalendarSelectionSingleDateDelegate, UITableViewDelegate, UITableViewDataSource, UICalendarViewDelegate, MealScheduleDelegate {
    
    var days: [Date: Day] = [:]
    
    private var loadedDate = Date.now
    private var loadedBreakfast: Recipe?
    private var loadedLunch: Recipe?
    private var loadedDinner: Recipe?
    
    @IBOutlet weak var calendarTableView: UITableView!
    
    override func viewDidLoad() {
        let myCalendarView = UICalendarView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 420))
        
        configure(calendar: myCalendarView)
        
        calendarTableView.dataSource = self
        calendarTableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addMeal" {
            let destination = segue.destination as! AddMealViewController
            destination.dateToAddMeal = self.loadedDate
        }
    }
    
    func configure(calendar: UICalendarView) {
        calendar.delegate = self
        
        let gregorian = Calendar(identifier: .gregorian)
        
        calendar.calendar = gregorian
        
        self.view.addSubview(calendar)
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        
        calendar.selectionBehavior = dateSelection
    }

    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            return nil
    }
    
    func passDayPair(date: Date, recipe: Recipe, meal: MealType) {
        switch meal {
        case .breakfast:
            days[date]?.breakfast = recipe
        case .lunch:
            days[date]?.lunch = recipe
        case .dinner:
            days[date]?.dinner = recipe
        }
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents, let date = dateComponents.date else { return }
        loadedDate = date
        var day = days[date]
        
        if let breakfast = day?.breakfast {
            loadedBreakfast = breakfast
        }
        
        if let lunch = day?.lunch {
            loadedLunch = lunch
        } else {
            days[date] = generateDummyDay(with: "Test String - \(date.formatted())")
        }
        
        if let dinner = day?.dinner {
            loadedDinner = dinner
        }
        calendarTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //Each meal will be their own section
        3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Each meal is just it's own cell
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = calendarTableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! MealCell
       
        configure(cell: cell, at: indexPath)
        return cell
    }
    func configure(cell: MealCell, at indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            cell.mealNameLabel.text = "Breakfast"
            cell.recipeNameLabel.text = "\(days[loadedDate]?.breakfast?.name ?? "No breakfast planned")"
        case 1:
            cell.mealNameLabel.text = "Lunch"
            cell.recipeNameLabel.text = "\(days[loadedDate]?.lunch?.name ?? "No lunch planned")"
        case 2:
            cell.mealNameLabel.text = "Dinner"
            cell.recipeNameLabel.text = "\(days[loadedDate]?.dinner?.name ?? "No dinner planned")"
        default:
            cell.mealNameLabel.text = "Coming"
        }
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
}

extension CalendarView {
    func generateDummyDay(with recipeName: String) -> Day {
        let ingredient = Ingredient(name: "Ingredient", quantity: "14")
        
        let recipe = Recipe(name: recipeName, ingredients: [ingredient, ingredient])
        
        return Day(lunch: recipe)
    }
}
