//
//  recipesTableViewCell.swift
//  Meal Planner
//
//  Created by Ami Smith on 4/18/23.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with recipe: Recipe) {
//        guard let recipeNameLabel else { return }
        recipeNameLabel.text = recipe.name
    }
    

}
