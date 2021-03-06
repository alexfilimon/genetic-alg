//
//  AnyAlgDebugger.swift
//  GeneticAlg
//
//  Created by al.filimonov on 06.03.2021.
//

import Foundation

protocol AnyAlgDebugger: AnyObject {
    
    var onNeedNextStep: (() -> TaskOutput?)? { get set }
    var onNeedFinal: (() -> TaskOutput?)? { get set }
    
}
