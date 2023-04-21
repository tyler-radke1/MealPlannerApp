//
//  CalendarView.swift
//  Meal Planner
//
//  Created by Tyler Radke on 4/17/23.
//

import UIKit

class CalendarView: UIViewController, UICalendarSelectionSingleDateDelegate, UITableViewDelegate, UITableViewDataSource, UICalendarViewDelegate {
    
    
    var days: [Date: Day] = [:]
    
    private var loadedDate = Date.now
    private var loadedBreakfast: Recipe?
    private var loadedLunch: Recipe?
    private var loadedDinner: Recipe?
    
    @IBOutlet weak var calendarTableView: UITableView!
    
    override func viewDidLoad() {
        let myCalendarView = UICalendarView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 400))
        
        configure(calendar: myCalendarView)
        
        calendarTableView.dataSource = self
        calendarTableView.delegate = self
    }
    
    func generateFood(for day: Date) {
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = calendarTableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! MealCell
       
        configure(cell: cell, at: indexPath)
        return cell
    }
    func configure(cell: MealCell, at indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            cell.mealNameLabel.text = "Breakfast"
        case 1:
            cell.mealNameLabel.text = "Lunch"
        case 2:
            cell.mealNameLabel.text = "Dinner"
        default:
            cell.mealNameLabel.text = "Coming"
        }
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        
        cell.recipeNameLabel.text = "\(formatter.string(from: loadedDate))"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
}
