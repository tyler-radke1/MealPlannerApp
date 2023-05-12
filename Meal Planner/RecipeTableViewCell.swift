//
//  recipesTableViewCell.swift
//  Meal Planner
//
//  Created by Ami Smith on 4/18/23.
//

import UIKit
import CoreData

protocol RecipeCellDelegate {
    func favoriteButtonTapped(cell: UITableViewCell)
    func calendarButtonTapped(cell: UITableViewCell, passing recipe: Recipe?, or recipeResult: RecipieResult?)
}

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    @IBOutlet weak var recipeImage: UIImageView!
    
    var recipeToPass: Recipe? = nil
    
    var recipeResult: RecipieResult? = nil
    
    var delegate: RecipeCellDelegate?

    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with recipe: Recipe) {
        self.setCellColor()
        recipeNameLabel.text = recipe.name
        
        self.recipeToPass = recipe
        
        guard let recipeImageData = recipe.photo
        else {
            return
        }
        
        recipeImage.image = UIImage(data: recipeImageData)
    }
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        delegate?.favoriteButtonTapped(cell: self)
    }
    
    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        delegate?.calendarButtonTapped(cell: self, passing: recipeToPass ?? nil, or: recipeResult ?? nil)
    }
    
}
