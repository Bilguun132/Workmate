//
//  OverlayViewController.swift
//  Workmate
//
//  Created by Bilguun Batbold on 3/12/19.
//  Copyright © 2019 Bilguun. All rights reserved.
//

import UIKit

class OverlayViewController: UIViewController {
    
    //MARK: - Variables
    
    var clockInState: ClockInState = .none
    
    weak var delegate: OverlayControllerProtocol?
    
    private var timer: Timer?
    private var bufferTime = 10
    private var progress = 0.0
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        return progressView
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
        return button
    }()

    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    //MARK: - Method
    
    func setup() {
        self.view.backgroundColor = .darkGray
        let guide = view.safeAreaLayoutGuide
        infoLabel.text = clockInState == .none ? "Clocking in..." : "Clocking out..."
        self.view.addSubview(infoLabel)
        self.view.addSubview(progressView)
        self.view.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 32),
            progressView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -32),
            progressView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 16),
            cancelButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            
            infoLabel.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -16),
            infoLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor)
        ])
        
    }
    
    @objc func cancelButtonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func onTimerFires()
    {
        bufferTime -= 1
        progress += 0.1
        progressView.setProgress(Float(progress), animated: true)
        if bufferTime <= 0 {
            timer?.invalidate()
            timer = nil
            delegate?.confirmAction(clockInState: clockInState)
            self.dismiss(animated: true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol OverlayControllerProtocol: class {
    func confirmAction(clockInState: ClockInState)
}
