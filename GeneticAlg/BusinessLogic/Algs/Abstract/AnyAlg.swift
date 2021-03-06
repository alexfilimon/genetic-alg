//
//  AnyAlg.swift
//  GeneticAlg
//
//  Created by al.filimonov on 06.03.2021.
//

import Foundation

protocol AnyAlg {
    
    var state: AnyAlgState { get }
    
    init(input: TaskInput)
    
    func calculate(onResult: ((TaskOutput) -> Void)?)
    
    func reset()
    
    func attachDebugger(_ debugger: AnyAlgDebugger)
    
}
