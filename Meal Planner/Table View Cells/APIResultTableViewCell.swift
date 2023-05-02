//
//  APIResultTableViewCell.swift
//  Meal Planner
//
//  Created by Sterling Jenkins on 4/27/23.
//

import UIKit

protocol APIResultTableViewCellDelegate {
    func favoriteButtoneTapped(on cell: APIResultTableViewCell)
    func calendarButtonTapped(on cell: APIResultTableViewCell)
}

class APIResultTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeimage: UIImageView!
    
    @IBOutlet weak var recipeTitleLabel: UILabel!
    
    var delegate: APIResultTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func favoriteButtoneTapped() {
        delegate?.favoriteButtoneTapped(on: self)
    }
    
    @IBAction func calendarButtonTapped() {
        delegate?.calendarButtonTapped(on: self)
    }
    
}
