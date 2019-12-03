//
//  User.swift
//  Workmate
//
//  Created by Bilguun Batbold on 3/12/19.
//  Copyright © 2019 Bilguun. All rights reserved.
//

import Foundation

struct LoginResponse: Decodable {
    let key: String
}
/// Only specific fields are decoded as required by the template

struct User: Decodable {
    let positionName: String
    let clientName: String
    let wageAmount: String
    let locationStreet: String
    let managerName: String
    let managerNumber: String
    let wageType: String
    
    enum CodingKeys: String, CodingKey {
        case location = "location"
        case position = "position"
        case address = "address"
        case street = "street1"
        case client = "client"
        case name = "name"
        case wageAmount = "wageAmount"
        case manager = "manager"
        case phone = "phone"
        case wageType = "wageType"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let client = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .client)
        let position = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .position)
        let location = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .location)
        let locationAddress = try location.nestedContainer(keyedBy: CodingKeys.self, forKey: .address)
        let manager = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .manager)
        managerName = try manager.decode(String.self, forKey: .name)
        managerNumber = try manager.decode(String.self, forKey: .phone)
        locationStreet = try locationAddress.decode(String.self, forKey: .street)
        positionName = try position.decode(String.self, forKey: .name)
        clientName = try client.decode(String.self, forKey: .name)
        wageAmount = try container.decode(String.self, forKey: .wageAmount)
        wageType = try container.decode(String.self, forKey: .wageType)
    }
    
}
