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
    
    @IBOutlet weak var mealsToAddPicker: UIPickerView!
    
    var delegate: MealScheduleDelegate? = nil
    
    let meals = ["Breakfast", "Lunch", "Dinner"]

    var selectedFood: Recipe? = nil
    
   // let mealOptions = ["Soup", "Pizza", "Ice Cream", "Grilled Cheese Sandwich"]
    
    var dateToAddMeal: Date? = nil
    
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

        static let scrambledEggsInstructions = """
        Instructions:
        
        1. Crack the eggs into a bowl and beat them with a fork.
        2. Melt the butter in a non-stick pan over medium heat.
        3. Pour the beaten eggs into the pan.
        4. Use a spatula to gently stir the eggs as they cook.
        5. When the eggs are set but still moist, remove them from the heat.
        6. Season with salt and pepper to taste.
    """
        static let pbjIngredients = [
            Ingredient(name: "Bread", quantity: "2 slices"),
            Ingredient(name: "Peanut Butter", quantity: "2 tablespoons"),
            Ingredient(name: "Jelly", quantity: "2 tablespoons")
        ]

        static let pbjInstructions = """
        Instructions:

            1. Toast the bread (optional).
            2. Spread peanut butter on one slice of bread.
            3. Spread jelly on the other slice of bread.
            4. Put the two slices of bread together, with the peanut butter and jelly sides facing each other.
            5. Cut the sandwich in half (optional).
        """
        
        static let macaronIngredients = [
        Ingredient(name: "extra large egg whites", quantity: "4"),
        Ingredient(name: "confectioners' sugar", quantity: "1 2/3 c."),
        Ingredient(name: "almond flour", quantity: "1 1/3 c."),
        Ingredient(name: "salt", quantity: "1/8 tsp"),
        Ingredient(name: "superfine (castor) sugar", quantity: "1/4 c."),
        Ingredient(name: "seedless raspberry jam", quantity: "1/4 c.")
        ]
        
        static let macaronInstructions = """
    Instructions:

    1. Place egg whites into a metal mixing bowl and refrigerate, 8 hours to overnight.

    2. Remove egg whites from the refrigerator and bring to room temperature, 20 to 30 minutes.

    3. Whisk confectioners' sugar and almond flour together in a bowl.

    4. Add salt to egg whites and beat with an electric mixer on medium speed until foamy, about 1 minute. Increase the speed to high and gradually beat in superfine sugar, about 1 tablespoon at a time, until egg whites are glossy and hold stiff peaks, 3 to 5 more minutes.

    5. Gently fold almond flour mixture into whipped egg whites until thoroughly incorporated. Spoon meringue into a pastry bag fitted with a 3/8-inch tip. Line two baking sheets with parchment paper.

    6. Pipe 1-inch disks of meringue 2 inches apart onto the prepared baking sheets; batter will spread. Lift the baking sheets up a few inches and drop them gently onto the work surface several times to remove any air bubbles. Let stand at room temperature until the shiny surfaces dulls and a thin skin forms, about 15 minutes.

    7. Meanwhile, preheat the oven to 280 degrees F (138 degrees C).

    8. Place the baking sheets in the preheated oven and bake with the oven door cracked until cookies are completely dry on the surface, about 15 minutes. Remove from the oven and let cool completely on the baking sheets, about 30 minutes.

    9. Gently peel parchment paper from cookies to remove. Spread 1/2 of the cookies with jam, then top with remaining cookies and press gently to push jam to the edges. Refrigerate until cookies soften, 2 hours to overnight.
    """
//        static let recipes = [
//            Recipe(name: "Scrambled Eggs", ingredients: scrambledEggsIngredients, instructions: scrambledEggsInstructions),
//            Recipe(name: "PB & J Sandwich", ingredients: pbjIngredients, instructions: pbjInstructions),
//            Recipe(name: "Macarons", ingredients: macaronIngredients, instructions: macaronInstructions)
//
//            ]
}

