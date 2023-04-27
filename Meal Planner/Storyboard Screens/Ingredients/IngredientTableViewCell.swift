//
//  NewIngredientCell.swift
//  Meal Planner
//
//  Created by Tyler Radke on 4/20/23.
//


import UIKit
import CoreData
//import

protocol IngredientTableViewCellDelegate {
    func addButtonTapped(cell: IngredientTableViewCell)
}

class IngredientTableViewCell: UITableViewCell {

    var delegate: IngredientTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    @IBOutlet var ingredientLabel: UILabel!
    
//    on delete
    
    
    func configure(with ingredient: Ingredient) {
        ingredientLabel.text = ingredient.name
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}

