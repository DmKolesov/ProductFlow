//
//  DTOMapper.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 10.04.2025.
//

import Foundation

protocol DTOMapper {
    associatedtype Domain
    associatedtype DTO
    
    static func mapToDomain(_ dto: DTO) -> Domain
    static func mapToDTO(_ domain: Domain) -> DTO
}
