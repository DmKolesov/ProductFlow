//
//  ModuleBuilder.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 08.04.2025.
//

import Foundation

protocol ModuleBuilder {
    associatedtype Input
    associatedtype Output
    
    func build(with input: Input) -> Output
}

extension ModuleBuilder where Input == Void {
    func build() -> Output {
        build(with: ())
    }
}

protocol ModuleBuilderFactory {
    func makeNewsModuleBuilder() -> NewsModuleBuilder
}

final class DefaultModuleBuilderFactory: ModuleBuilderFactory {
    func makeNewsModuleBuilder() -> NewsModuleBuilder {
        return NewsModuleBuilder()
    }
}
