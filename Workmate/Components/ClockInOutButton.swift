//
//  ClockInOutButton.swift
//  Workmate
//
//  Created by Bilguun Batbold on 3/12/19.
//  Copyright © 2019 Bilguun. All rights reserved.
//

import UIKit

class ClockInOutButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 15
        self.backgroundColor = .lightGray
    }
}
