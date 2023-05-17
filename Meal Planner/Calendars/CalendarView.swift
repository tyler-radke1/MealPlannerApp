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
    
    private var favoriteUsed = false
    
    override func viewDidLoad() {
        let width = view.frame.width
        let height = view.frame.height
        let myCalendarView = UICalendarView(frame: CGRect(x: 0, y: 0, width: width * 0.9, height: height / 2))
        configure(calendar: myCalendarView)

        calendarTableView.dataSource = self
        calendarTableView.delegate = self
        
        setColor()
//        navigationController?.navigationBar.tintColor = .systemPink
//        navigationController?.navigationBar.barTintColor = .systemPink
//        navigationController?.navigationBar.backgroundColor = .systemPink
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    override func viewWillDisappear(_ animated: Bool) {
        guard !favoriteUsed, let favoriteRecipeToDisplay else { return }
        context.delete(favoriteRecipeToDisplay)
        
        do {
            try context.save()
        } catch {
            print("your mother is dissapointed in you")
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
        
        let centerX = self.view.center.x
        
        let centerY = self.view.center.y - 195
       
        calendar.center = CGPoint(x: centerX, y: centerY)
        
        let gregorian = Calendar(identifier: .gregorian)
        
        calendar.calendar = gregorian
        
        calendar.backgroundColor = .customLightBlue
        
        calendar.tintColor = .customBlue
        
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
        
        favoriteUsed = recipe?.id == favoriteRecipeToDisplay?.id
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
    
    //Does nothing, but vasillys code won't compile without it. Not actually need for conformance. Idk
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return nil
    }
    
    @objc func imageTapped(sender: ImageTapGesture) {
        guard let recipe = sender.recipe else { return }
        performSegue(withIdentifier: "presentDetailView", sender: recipe)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentDetailView" {
            guard let destination = segue.destination as? RecipeDetailsViewController else { return }
            
            destination.recipe = sender as? Recipe
        }
    }
    
    
    func configure(cell: MealCell, at indexPath: IndexPath) {
        cell.setCellColor()
        
        let tapRecognizer = ImageTapGesture(target: self, action: #selector(imageTapped))
        
        var recipe: Recipe? = nil
        
        switch indexPath.section {
        case 0:
            recipe = days[loadedDate]?.breakfast
        case 1:
            recipe = days[loadedDate]?.lunch
        case 2:
            recipe = days[loadedDate]?.dinner
        default:
            recipe = days[loadedDate]?.breakfast
        }
        
        cell.recipeNameButton.setTitle(recipe?.name ?? "None", for: .normal)
        
        if let data = recipe?.photo {
            cell.recipeImage.image = UIImage(data: data)
        } else {
            cell.recipeImage.image = UIImage(systemName: "photo")
        }
        cell.recipeNameButton.showsMenuAsPrimaryAction = true
        
        cell.delegate = self
        
        cell.cellMeal = MealType.allCases[indexPath.section]
        
        cell.favoriteRecipe = self.favoriteRecipeToDisplay
        
        tapRecognizer.recipe = recipe
        
        cell.recipeImage.addGestureRecognizer(tapRecognizer)
        //Makes it so if there IS a favoriteRecipe selected, primary action is set to false.
        cell.recipeNameButton.showsMenuAsPrimaryAction = (favoriteRecipeToDisplay == nil)
            
        cell.recipeNameButton.menu = cell.addMenuItems()
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
    }
}
