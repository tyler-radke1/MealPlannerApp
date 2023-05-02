//
//  recipesTableViewCell.swift
//  Meal Planner
//
//  Created by Ami Smith on 4/18/23.
//

import UIKit
import CoreData

protocol RecipeTableViewCellDelegate {
    func favoriteButtonTapped(cell: RecipeTableViewCell)
    func calendarButtonTapped(cell: RecipeTableViewCell)
}

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    var delegate: RecipeTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with recipe: Recipe) {
        recipeNameLabel.text = recipe.name
    }
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        print("Favorite button tapped")
        delegate?.favoriteButtonTapped(cell: self)
    }
    
    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        print("calendar button tapped")
        delegate?.calendarButtonTapped(cell: self)
    }
    
}
