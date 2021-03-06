//
//  GeneticAlgMatrixGenerator.swift
//  GeneticAlg
//
//  Created by al.filimonov on 06.03.2021.
//

import Foundation

class GeneticAlgMatrixGenerator {
    
    // MARK: - Private Properties
    
    private let size: Int
    
    // MARK: - Initializaion
    
    init(size: Int) {
        self.size = size
    }
    
    // MARK: - Methods
    
    func generate() -> TaskInput {
        // generate points
        let points = generatePoints()
        
        // generate matrix
        let matrix = generateMatrix(points: points)
        
        return .init(points: points, matrix: matrix)
    }
    
    // MARK: - Private Methods
    
    private func generatePoints() -> [TaskPoint] {
        let eps = 2.0 / Double(size)
        
        var points: [TaskPoint] = []
        for _ in 0..<size {
            var currentPoint: TaskPoint
            var isGood: Bool
            repeat {
                currentPoint = generatePoint()
                isGood = checkIsGood(points: points,
                                     currentPoint: currentPoint,
                                     eps: eps)
            } while !isGood
            points.append(currentPoint)
        }
        
        return points
    }
    
    private func generatePoint() -> TaskPoint {
        return .init(x: Double.random(in: 0...1),
                     y: Double.random(in: 0...1))
    }
    
    private func checkIsGood(points: [TaskPoint],
                             currentPoint: TaskPoint,
                             eps: Double) -> Bool {
        let minX = currentPoint.x - eps / 2
        let maxX = currentPoint.x + eps / 2
        let minY = currentPoint.y - eps / 2
        let maxY = currentPoint.y + eps / 2
        return !points.contains(where: {
            return $0.x < maxX && $0.x > minX && $0.y < maxY && $0.y > minY
        })
    }
    
    private func generateMatrix(points: [TaskPoint]) -> [[Double]] {
        var matrix: [[Double]] = Array(repeating: Array(repeating: 0, count: size), count: size)
        
        for i in 0..<size {
            for j in i..<size {
                if i == j {
                    matrix[i][j] = -1.0
                } else {
                    let distance = getDistanceBeetwen(firstPoint: points[i],
                                                      andSecondPoint: points[j])
                    matrix[i][j] = distance
                    matrix[j][i] = distance
                }
            }
        }
        
        return matrix
    }
    
    private func getDistanceBeetwen(firstPoint first: TaskPoint,
                                    andSecondPoint second: TaskPoint) -> Double {
        let xSize = first.x - second.x
        let ySize = first.y - second.y
        return sqrt(xSize * xSize + ySize * ySize)
    }
    
}
