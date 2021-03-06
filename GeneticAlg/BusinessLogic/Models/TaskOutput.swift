//
//  TaskOutput.swift
//  GeneticAlg
//
//  Created by al.filimonov on 06.03.2021.
//

import Foundation

struct TaskOutput {
    
    // MARK: - Nested Types
    
    struct PathItem {
        let from: TaskPoint
        let to: TaskPoint
    }
    
    // MARK: - Properties
    
    let value: Double
    let path: [PathItem]
    
}
