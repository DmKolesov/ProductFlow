//
//  NetworkConfiguration.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 09.04.2025.
//

import Foundation

struct NetworkConfiguration {
    let baseURL: String
    let defaultHeaders: [String: String]
    
    static let `default` = NetworkConfiguration(
        baseURL: "https://webapi.autodoc.ru/api",
        defaultHeaders: [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    )
}
