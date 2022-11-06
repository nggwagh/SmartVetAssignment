//
//  ViewController.swift
//  SmartVetAssignment
//
//  Created by NWagh on 04/11/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    lazy var viewModel: HomeViewViewModelProtocol = {
        let session = HTTPUtility.session
        return HomeViewViewModel(service: HomeService(httpUtility: session))
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = sender as? IndexPath
        let destinationVC = segue.destination as? PetDetailsViewController
        destinationVC?.pet = viewModel.petsArray![indexPath!.row - 1]
    }
    
    //MARK: - custom methods
    func setupUI() {
        viewModel.loadRemoteData()
        viewModel.operationCompletion = { [weak self] (isSuccess, message) in
            if isSuccess {
                self?.tableView.reloadData()
            } else {
                self?.showAlertViewWith(title: Constants.errorTitle, message: message!)
            }
        }
    }
    
    func showAlertViewWith(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.okTitle, style: .default))
        self.present(alertController, animated: false)
    }
}

//MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let actionCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.action) as! ActionsTVC
            actionCell.selectionStyle = .none
            actionCell.delegate = self
            if let setting = viewModel.configSetting {
                actionCell.configureCell(model: setting)
            }
            return actionCell
        }  else {
            let petCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.pets) as! PetsTVC
            petCell.selectionStyle = .none
            let pet = viewModel.petsArray![indexPath.row - 1]
            petCell.configureCell(model: pet)
            return petCell
        }
    }
}

//MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return viewModel.showCallChatOptions ? Constants.cellHeight * 2 : Constants.cellHeight
        }
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            performSegue(withIdentifier: Constants.SegueIdentifier.petDetails, sender: indexPath)
        }
    }
}
//MARK: - ActionsTVCDelegate
extension HomeViewController: ActionsTVCDelegate {
    func handleCallAction() {
        let message = viewModel.checkIfWithinWorkHours(now: Date()) ? Constants.Messages.workHours : Constants.Messages.outsideWorkHours
        showAlertViewWith(title: Constants.alertTitle, message: message)
    }
    
    func handleChatAction() {
        let message = viewModel.checkIfWithinWorkHours(now: Date()) ? Constants.Messages.workHours : Constants.Messages.outsideWorkHours
        showAlertViewWith(title: Constants.alertTitle, message: message)
    }
}
