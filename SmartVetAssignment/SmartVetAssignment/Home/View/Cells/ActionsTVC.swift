//
//  ActionsTVC.swift
//  SmartVetAssignment
//
//  Created by NWagh on 04/11/22.
//

import UIKit

protocol ActionsTVCDelegate {
    func handleCallAction()
    func handleChatAction()
}

class ActionsTVC: UITableViewCell {

    //MARK: - Outlets
  @IBOutlet weak var chatButton: UIButton!
  @IBOutlet weak var callButton: UIButton!
  @IBOutlet weak var hoursLabel: UILabel!

    var delegate: ActionsTVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
  
    //MARK: - custom methods
    func configureCell(model: Settings) {
        setupUI()
        chatButton.isHidden = !model.isChatEnabled
        callButton.isHidden = !model.isChatEnabled
        hoursLabel.text = String(format: "%@: %@", Constants.workingHours, model.workHours)
    }
    
    func setupUI() {
        contentView.tintAdjustmentMode = .normal
        hoursLabel.layer.borderColor = UIColor.lightGray.cgColor
        hoursLabel.layer.borderWidth = 2
    }
    
    //MARK: - IBActions
    @IBAction func callButtonAction(_ sender: UIButton) {
        delegate?.handleCallAction()
    }
    @IBAction func chatButtonAction(_ sender: UIButton) {
        delegate?.handleChatAction()
    }
}
