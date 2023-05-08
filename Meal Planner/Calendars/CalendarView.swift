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
    
    var favoriteRecipeToDisplay: Recipe? 
    
    override func viewDidLoad() {
       
        let myCalendarView = UICalendarView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 550))
        configure(calendar: myCalendarView)

        calendarTableView.dataSource = self
        calendarTableView.delegate = self
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let today = Date.now
//        self.dateSelection(self, didSelectDate: DateComponents(day: today.
        loadCoreData()
    }
    
    func loadCoreData() {
        let request = NSFetchRequest<CalendarDates>(entityName: "CalendarDates")
        do {
            let results = try context.fetch(request)
            
            for result in results {
                guard let date = result.date, let day = result.day else { continue }
                days[date] = day
                
                if let breakfast = day.breakfast {
                    loadedBreakfast = breakfast
                }
                if let lunch = day.lunch {
                    loadedLunch = lunch
                }
                if let dinner = day.dinner {
                    loadedDinner = dinner
                    
                }
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
    
    
    func updateMeal(for type: MealType, with recipe: Recipe?) {
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
    
    @IBAction func mealButtonTapped(_ sender: UIButton) {
//        guard let favoriteRecipeToDisplay else { return }
//        print("button tapped with recipe")
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
    
    //Does nothing, but vasillys code won't compile without it. Not actually need for conformance. Idk
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return nil
    }
    
    @objc func imageTapped() {
       
        print("image tapped")
    }
    
    
    func configure(cell: MealCell, at indexPath: IndexPath) {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        
        cell.recipeImage.addGestureRecognizer(tapRecognizer)
        var recipe: Recipe? = nil
        
        switch indexPath.section {
        case 0:
           // cell.recipeNameButton.setTitle("\(days[loadedDate]?.breakfast?.name ?? "None")", for: .normal)
            recipe = days[loadedDate]?.breakfast
        case 1:
           // cell.recipeNameButton.setTitle("\(days[loadedDate]?.lunch?.name ?? "None")", for: .normal)
            recipe = days[loadedDate]?.lunch
        case 2:
           // cell.recipeNameButton.setTitle("\(days[loadedDate]?.dinner?.name ?? "None")", for: .normal)
            recipe = days[loadedDate]?.dinner
        default:
          //  cell.recipeNameButton.setTitle("\(days[loadedDate]?.breakfast?.name ?? "None")", for: .normal)
            recipe = days[loadedDate]?.breakfast
        }
        
        cell.recipeNameButton.setTitle(recipe?.name ?? "None", for: .normal)
        
        if let data = recipe?.photo {
            cell.recipeImage.image = UIImage(data: data)
        }
        cell.recipeNameButton.showsMenuAsPrimaryAction = true
        
        cell.delegate = self
        
        cell.cellMeal = MealType.allCases[indexPath.section]
        
        cell.favoriteRecipe = self.favoriteRecipeToDisplay
        
        //Makes it so if there IS a favoriteRecipe selected, primary action is set to false.
        cell.recipeNameButton.showsMenuAsPrimaryAction = (favoriteRecipeToDisplay == nil)
            
        cell.recipeNameButton.menu = cell.addMenuItems()
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
    }
}


class DummyData {
   
    static let shared = DummyData()
    
    func generateData() {
        
        let names = ["Pizza", "Duck Soup", "Tacos", "Whale Blubber Ice Cream", "Toenail Smoothie"]
        let context = PersistenceController.shared.viewContext
        
        let ingredient = Ingredient(context: context)
        
        ingredient.name = "Test Name"
        ingredient.quantity = "69"
        
        for i in 0...4 {
            let recipe = Recipe(context: context)
            recipe.name = names[i]
            
            recipe.ingredients = NSSet(array: [ingredient])
            
            context.insert(recipe)
        }
        
        do {
            try context.save()
        } catch {
            print("failed to save")
        }
    }
}
