//
//  Time.swift
//  ST Ecommerce
//
//  Created by Ku Ku Zan on 7/1/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation

struct Time {
    let start: TimeInterval
    let end: TimeInterval
    let interval: TimeInterval

    init(start: TimeInterval, interval: TimeInterval, end: TimeInterval) {
        self.start = start
        self.interval = interval
        self.end = end
    }

    init(startHour: TimeInterval, intervalMinutes: TimeInterval, endHour: TimeInterval) {
        self.start = startHour * 60 * 60
        self.end = endHour * 60 * 60
        self.interval = intervalMinutes * 60
    }

    var timeRepresentations: [String] {
        let dateComponentFormatter = DateComponentsFormatter()
        dateComponentFormatter.unitsStyle = .positional
        dateComponentFormatter.allowedUnits = [.minute, .hour]

        var dateComponent = DateComponents()
        return timeIntervals.map { timeInterval in
            dateComponent.second = Int(timeInterval)
            return dateComponentFormatter.string(from: dateComponent)!
        }
    }

    var timeIntervals: [TimeInterval]{
        return Array(stride(from: start, through: end, by: interval))
    }
}
