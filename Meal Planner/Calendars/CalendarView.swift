//
//  CalendarView.swift
//  Meal Planner
//
//  Created by Tyler Radke on 4/17/23.
//

import CoreData
import UIKit

enum MealType: String, CaseIterable {
    case breakfast = "breakfast"
    case lunch = "lunch"
    case dinner = "dinner"
}
protocol MealScheduleDelegate {
    func passDayPair(date: Date, recipe: Recipe, meal: MealType)
}

class CalendarView: UIViewController, UICalendarSelectionSingleDateDelegate, UITableViewDelegate, UITableViewDataSource, UICalendarViewDelegate, MealCellDelegate {
    
    var days: [Date: Day] = [:]
    
    let context = PersistenceController.shared.viewContext
    @IBOutlet weak var mealButton: UIButton!
    
    private var loadedDate = Date.now
    
    private var loadedBreakfast: Recipe?
    private var loadedLunch: Recipe?
    private var loadedDinner: Recipe?
    
    @IBOutlet weak var calendarTableView: UITableView!
    
    override func viewDidLoad() {
        let myCalendarView = UICalendarView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 550))
        configure(calendar: myCalendarView)
        loadCoreData()
        calendarTableView.dataSource = self
        calendarTableView.delegate = self
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths)
    }
    
    func loadCoreData() {
        let request = NSFetchRequest<CalendarDates>(entityName: "CalendarDates")
        
        do {
            let results = try context.fetch(request)
            
            for result in results {
                guard let date = result.date, let day = result.day else { return }
                days[date] = day
            }
        } catch {
            print("error")
        }
    }
    
    func saveCoreData(date: Date, day: Day) {
        let calendarDate = CalendarDates(context: context)
        
        calendarDate.date = date
        calendarDate.day = day
        
        context.insert(calendarDate)
        
        do {
            try context.save()
        } catch {
            print("failed to save")
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
    
    
    func updateMeal(for type: MealType, with recipe: Recipe) {
        if days[loadedDate] == nil {
            days[loadedDate] = Day(context: context)
        }
        
        switch type {
        case .breakfast:
            days[loadedDate]?.breakfast = recipe
        case .lunch:
            days[loadedDate]?.lunch = recipe
        case .dinner:
            days[loadedDate]?.dinner = recipe
        }
        
        if let day = days[loadedDate] {
            saveCoreData(date: loadedDate, day: day)
        }
        calendarTableView.reloadData()
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
            cell.recipeNameButton.setTitle("\(days[loadedDate]?.lunch?.name ?? "No lunch planned")", for: .normal)
        case 2:
            cell.recipeNameButton.setTitle("\(days[loadedDate]?.dinner?.name ?? "No dinner planned")", for: .normal)
        default:
            cell.recipeNameButton.setTitle("\(days[loadedDate]?.breakfast?.name ?? "No breakfast planned")", for: .normal)
        }
        
        cell.recipeNameButton.showsMenuAsPrimaryAction = true
        
        cell.delegate = self
        
        cell.cellMeal = MealType.allCases[indexPath.section]
        
        cell.recipeNameButton.menu = cell.addMenuItems()
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
    }
}
