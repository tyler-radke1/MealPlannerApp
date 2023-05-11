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
    func calendarButtonTapped(cell: RecipeTableViewCell, passing recipe: Recipe?)
}

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    @IBOutlet weak var recipeImage: UIImageView!
    
    private var recipeToPass: Recipe? = nil
    
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
        print("calendar button tapped")
        delegate?.calendarButtonTapped(cell: self, passing: recipeToPass ?? nil)
    }
    
}
