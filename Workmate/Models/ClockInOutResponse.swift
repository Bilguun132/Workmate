//
//  ClockInResponse.swift
//  Workmate
//
//  Created by Bilguun Batbold on 3/12/19.
//  Copyright © 2019 Bilguun. All rights reserved.
//

import Foundation

struct ClockInResponse: Decodable {
    let clockInTime: Date
    let clockOutTime: Date
    let code: String
    let detail: String
    
    
}

struct ClockOutResponse: Decodable {
    let clockInTime: String
    let clockOutTime: String
    
    enum CodingKeys: String, CodingKey {
        case timesheet = "timesheet"
        case clockInTime = "clockInTime"
        case clockOutTime = "clockOutTime"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let response = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .timesheet)
        clockInTime = try response.decode(String.self, forKey: .clockInTime)
        clockOutTime = try response.decode(String.self, forKey: .clockOutTime)
    }
}
