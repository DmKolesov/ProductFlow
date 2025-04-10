//
//  DateFormatter+Ext.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 10.04.2025.
//

import Foundation

extension DateFormatter {
    static let newsDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
}
