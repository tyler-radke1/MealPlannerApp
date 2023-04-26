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
    
    @IBOutlet weak var mealButton: UIButton!
    
    private var loadedDate = Date.now
    private var loadedBreakfast: Recipe?
    private var loadedLunch: Recipe?
    private var loadedDinner: Recipe?
    
    @IBOutlet weak var calendarTableView: UITableView!
    
    override func viewDidLoad() {
        let myCalendarView = UICalendarView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 550))
        
        configure(calendar: myCalendarView)
        
        calendarTableView.dataSource = self
        calendarTableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addMeal" {
            let destination = segue.destination as! AddMealViewController
            destination.delegate = self
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

    func passDayPair(date: Date, recipe: Recipe, meal: MealType) {
        if days[date] == nil {
            days[date] = Day()
        }
        switch meal {
        case .breakfast:
            days[date]?.breakfast = recipe
        case .lunch:
            days[date]?.lunch = recipe
        case .dinner:
            days[date]?.dinner = recipe
        }
        calendarTableView.reloadData()
    }
    
    @IBAction func mealButtonTapped(_ sender: UIButton) {
       
    }
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents, let date = dateComponents.date else { return }
        loadedDate = date
        let day = days[date]
        
        if let breakfast = day?.breakfast {
            loadedBreakfast = breakfast
        }
        
        if let lunch = day?.lunch {
            loadedLunch = lunch
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let array = ["Breakfast", "Lunch", "Dinner"]
        return array[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = calendarTableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! MealCell
       
        configure(cell: cell, at: indexPath)
        return cell
    }
    func configure(cell: MealCell, at indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            cell.recipeNameButton.setTitle("\(days[loadedDate]?.breakfast?.name ?? "No breakfast planned")", for: .normal)
        case 1:
            cell.recipeNameButton.setTitle("\(days[loadedDate]?.breakfast?.name ?? "No breakfast planned")", for: .normal)
        case 2:
            cell.recipeNameButton.setTitle("\(days[loadedDate]?.breakfast?.name ?? "No breakfast planned")", for: .normal)
        default:
            cell.recipeNameButton.setTitle("\(days[loadedDate]?.breakfast?.name ?? "No breakfast planned")", for: .normal)
        }
    
        cell.recipeNameButton.showsMenuAsPrimaryAction = true
        
        cell.recipeNameButton.menu = addMenuItems()
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
    }
    
    func addMenuItems() -> UIMenu {
        var actions: [UIAction] = []
        
        for recipe in DummyData.recipes {
            let action = UIAction(title: recipe.name) { [self] action in
                print("Tapped food")
            }
            
            actions.append(action)
        }
        
        let menuItems = UIMenu(title: "Your Recipes", children: actions)
        
        return menuItems
    }
}


