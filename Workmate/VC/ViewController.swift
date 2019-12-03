//
//  ViewController.swift
//  Workmate
//
//  Created by Bilguun Batbold on 3/12/19.
//  Copyright © 2019 Bilguun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var wageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationManagerLabel: UILabel!
    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var clockInTimeLabel: UILabel!
    @IBOutlet weak var clockOutTimeLabel: UILabel!
    @IBOutlet weak var clockInOutButton: ClockInOutButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    private var isLoading = true {
        didSet {
            activityIndicator.isHidden = !isLoading
        }
    }
    
    private var clockInState: ClockInState = .none

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Methods

    func setup() {
        APIService.shared.login { [weak self] (result) in
            switch result {
            case .success(let response):
                APIService.shared.setApiKey(with: response.key)
                print(response.key)
                self?.getTestUser()
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "Failed to get api key")
                }
            }
        }
    }
    
    func getTestUser() {
        APIService.shared.getTestUser { [weak self] (result) in
            switch result {
            case .success(let user):
                print(user)
                DispatchQueue.main.async {
                    self?.populateFields(with: user)
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "Failed to get test user")
                }
            }
        }
    }
    
    func populateFields(with user: User) {
        nameLabel.text = user.positionName
        companyLabel.text = user.clientName
        locationLabel.text = user.locationStreet
        locationManagerLabel.text = user.managerName
        contactNumberLabel.text = user.managerNumber
        wageLabel.text = "\(user.wageAmount) \(user.wageType.replacingOccurrences(of: "_", with: " "))"
        isLoading = false
    }
    
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func clockInActionTap(_ sender: UIButton) {
        let overlayVC = OverlayViewController()
        overlayVC.clockInState = self.clockInState
        overlayVC.delegate = self
        self.present(overlayVC, animated: true, completion: nil)
    }
    
}

public enum ClockInState {
    case none, clockedIn, clockedOut
}

extension ViewController: OverlayControllerProtocol {
    func confirmAction(clockInState: ClockInState) {
        switch clockInState {
        case .none:
            APIService.shared.clockInTestUser { [weak self] (result) in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self?.clockInTimeLabel.text = self?.dateFormatter.string(from: response.clockInTime)
                        self?.clockInOutButton.setTitle("Clock Out", for: .normal)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: "Unable to clock in")
                    }
                }
            }
            self.clockInState = .clockedIn
        case .clockedIn:
            self.clockInOutButton.isHidden = true
        default:
            return
        }
    }
    
    
}
