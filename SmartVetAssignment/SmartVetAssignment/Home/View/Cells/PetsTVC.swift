//
//  PetsTVC.swift
//  SmartVetAssignment
//
//  Created by NWagh on 04/11/22.
//

import UIKit

class PetsTVC: UITableViewCell {

  //MARK: - Outlets
  @IBOutlet weak var petImageView: LazyImageView!
  @IBOutlet weak var petTitle: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    //MARK: - custom methods
    func configureCell(model: Pet) {
        petTitle.text = model.title
        petImageView.loadImage(fromURL: URL(string: model.imageURL)!)
    }
}


