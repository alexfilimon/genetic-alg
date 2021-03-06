//
//  AlgDebugger.swift
//  GeneticAlg
//
//  Created by al.filimonov on 06.03.2021.
//

import Foundation

class AlgDebugger: AnyAlgDebugger {
    
    // MARK: - AnyAlgDebugger
    
    var onNeedNextStep: (() -> TaskOutput?)?
    var onNeedFinal: (() -> TaskOutput?)?
    
    // MARK: - Methods
    
    func next() -> TaskOutput? {
        return onNeedNextStep?()
    }
    
    func finalize() -> TaskOutput? {
        return onNeedFinal?()
    }
    
}
