//
//  MealCell.swift
//  Meal Planner
//
//  Created by Tyler Radke on 4/21/23.
//

import UIKit

class MealCell: UITableViewCell {
    @IBOutlet weak var mealNameLabel: UILabel!
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
