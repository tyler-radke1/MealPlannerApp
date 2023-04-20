//
//  IngredientTableViewCell.swift
//  Meal Planner
//
//  Created by Vasiliy on 4/19/23.
//

import UIKit
//import

class IngredientTableViewCell: UITableViewCell {

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
