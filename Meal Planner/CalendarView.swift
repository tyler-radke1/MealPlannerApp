//
//  CalendarView.swift
//  Meal Planner
//
//  Created by Tyler Radke on 4/17/23.
//

import UIKit

class CalendarView: UIViewController, UICalendarViewDelegate {
    
    
    override func viewDidLoad() {
        let myCalendarView = UICalendarView()
        
        myCalendarView.delegate = self
        
        let gregorian = Calendar(identifier: .gregorian)
        
        myCalendarView.calendar = gregorian
        
        view.addSubview(myCalendarView)
        
        print("if theres no calendar right now, you failed.")
        
    }
    
}
