//
//  CalendarView.swift
//  Meal Planner
//
//  Created by Tyler Radke on 4/17/23.
//

import UIKit

class CalendarView: UIViewController, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate, UITableViewDelegate, UITableViewDataSource {
   
    
    
    @IBOutlet weak var calendarTableView: UITableView!
    
    override func viewDidLoad() {
        let myCalendarView = UICalendarView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 400))
        
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

    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
       // guard let dateComponents else { return }
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
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
