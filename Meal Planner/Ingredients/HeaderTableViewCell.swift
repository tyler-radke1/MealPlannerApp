//
//  HeaderTableViewCell.swift
//  Meal Planner
//
//  Created by Vasiliy on 5/15/23.
//

import UIKit
protocol HeaderTableViewCellDelegate{
    func deleteSectionButtonTapped(forCell cell: HeaderTableViewCell)
}
    

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet var deleteSectionButton: UIButton!
    
    @IBOutlet var sectionLabel: UILabel!
    
    @IBAction func deleteSectionButtonTapped(_ sender: Any) {
        delegate?.deleteSectionButtonTapped(forCell: self)
    }
    
    var delegate: HeaderTableViewCellDelegate?
    var section: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
