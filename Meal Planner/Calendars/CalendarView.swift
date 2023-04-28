//
//  CalendarView.swift
//  Meal Planner
//
//  Created by Tyler Radke on 4/17/23.
//

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
            days[loadedDate] = Day()
        }
        
        print(type)
        
        switch type {
        case .breakfast:
            days[loadedDate]?.breakfast = recipe
        case .lunch:
            days[loadedDate]?.lunch = recipe
        case .dinner:
            days[loadedDate]?.dinner = recipe
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


//class DummyData {
//    private static var ingredient = Ingredient(name: "test", quantity: "test")
//    private static let soup = Recipe(name: "Soup", ingredients: [ingredient])
//    private static let iceCream = Recipe(name: "Ice Cream", ingredients: [ingredient])
//    private static let pizza = Recipe(name: "Pizza", ingredients: [ingredient])
//    private static let grilledCheese = Recipe(name: "Grilled Cheese Sandwich", ingredients: [ingredient])
//    
//    static var recipes = [soup, iceCream, pizza, grilledCheese]
//
//        static let scrambledEggsInstructions = """
//        Instructions:
//        
//        1. Crack the eggs into a bowl and beat them with a fork.
//        2. Melt the butter in a non-stick pan over medium heat.
//        3. Pour the beaten eggs into the pan.
//        4. Use a spatula to gently stir the eggs as they cook.
//        5. When the eggs are set but still moist, remove them from the heat.
//        6. Season with salt and pepper to taste.
//    """
//        static let pbjIngredients = [
//            Ingredient(name: "Bread", quantity: "2 slices"),
//            Ingredient(name: "Peanut Butter", quantity: "2 tablespoons"),
//            Ingredient(name: "Jelly", quantity: "2 tablespoons")
//        ]
//
//        static let pbjInstructions = """
//        Instructions:
//
//            1. Toast the bread (optional).
//            2. Spread peanut butter on one slice of bread.
//            3. Spread jelly on the other slice of bread.
//            4. Put the two slices of bread together, with the peanut butter and jelly sides facing each other.
//            5. Cut the sandwich in half (optional).
//        """
//        
//        static let macaronIngredients = [
//        Ingredient(name: "extra large egg whites", quantity: "4"),
//        Ingredient(name: "confectioners' sugar", quantity: "1 2/3 c."),
//        Ingredient(name: "almond flour", quantity: "1 1/3 c."),
//        Ingredient(name: "salt", quantity: "1/8 tsp"),
//        Ingredient(name: "superfine (castor) sugar", quantity: "1/4 c."),
//        Ingredient(name: "seedless raspberry jam", quantity: "1/4 c.")
//        ]
//        
//        static let macaronInstructions = """
//    Instructions:
//
//    1. Place egg whites into a metal mixing bowl and refrigerate, 8 hours to overnight.
//
//    2. Remove egg whites from the refrigerator and bring to room temperature, 20 to 30 minutes.
//
//    3. Whisk confectioners' sugar and almond flour together in a bowl.
//
//    4. Add salt to egg whites and beat with an electric mixer on medium speed until foamy, about 1 minute. Increase the speed to high and gradually beat in superfine sugar, about 1 tablespoon at a time, until egg whites are glossy and hold stiff peaks, 3 to 5 more minutes.
//
//    5. Gently fold almond flour mixture into whipped egg whites until thoroughly incorporated. Spoon meringue into a pastry bag fitted with a 3/8-inch tip. Line two baking sheets with parchment paper.
//
//    6. Pipe 1-inch disks of meringue 2 inches apart onto the prepared baking sheets; batter will spread. Lift the baking sheets up a few inches and drop them gently onto the work surface several times to remove any air bubbles. Let stand at room temperature until the shiny surfaces dulls and a thin skin forms, about 15 minutes.
//
//    7. Meanwhile, preheat the oven to 280 degrees F (138 degrees C).
//
//    8. Place the baking sheets in the preheated oven and bake with the oven door cracked until cookies are completely dry on the surface, about 15 minutes. Remove from the oven and let cool completely on the baking sheets, about 30 minutes.
//
//    9. Gently peel parchment paper from cookies to remove. Spread 1/2 of the cookies with jam, then top with remaining cookies and press gently to push jam to the edges. Refrigerate until cookies soften, 2 hours to overnight.
//    """
//}
