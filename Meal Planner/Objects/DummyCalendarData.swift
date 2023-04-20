//
//  DummyCalendarData.swift
//  Meal Planner
//
//  Created by Tyler Radke on 4/19/23.
//

import Foundation

class DummyData {
    static var sharedIntance = DummyData()
    
    let days: [Date: Day] = [:]
    
    func yummyEggs() -> Day {
        let eggs = Ingredient(name: "Eggs")
        let eggJuice = Recipe(ingredients: [eggs], instructions: "Simply drink the egg")
        let eggDay = Day(breakfast: eggJuice, lunch: eggJuice, dinner: eggJuice)
        
        return eggDay
    }
    
    
}
