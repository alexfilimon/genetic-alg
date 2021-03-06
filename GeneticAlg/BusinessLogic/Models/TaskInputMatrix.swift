//
//  GeneticAlgMatrix.swift
//  GeneticAlg
//
//  Created by al.filimonov on 06.03.2021.
//

import Foundation

struct TaskInput {
    
    // MARK: - Properties
    
    let points: [TaskPoint]
    let matrix: [[Double]]
    
    // MARK: - Methods
    
    func getDistanceBeetwen(firstPoint first: TaskPoint, andSecondPoint second: TaskPoint) -> Double? {
        guard
            let firstIndex = points.firstIndex(of: first),
            let secondIndex = points.firstIndex(of: second),
            firstIndex != secondIndex
        else {
            return nil
        }
        return matrix[firstIndex][secondIndex]
    }
    
}
