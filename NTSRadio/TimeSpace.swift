//
//  TimeSpace.swift
//  NTSRadio
//
//  Created by Артмеий Шлесберг on 18/03/2018.
//  Copyright © 2018 Shlesberg. All rights reserved.
//

import Foundation

protocol TimeSpace {
    var startDate: Date { get }
    var endDate: Date { get }
    func asString() -> String
}

class TimeSpaceFrom: TimeSpace {
    var startDate: Date
    var endDate: Date
    
    init(startDate: Date, duration: TimeInterval) {
        self.startDate = startDate
        self.endDate = startDate.addingTimeInterval(duration)
    }

    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func asString() -> String {
        return "\(startDate.shortTimeString) - \(endDate.shortTimeString)"
    }
    
    
}
