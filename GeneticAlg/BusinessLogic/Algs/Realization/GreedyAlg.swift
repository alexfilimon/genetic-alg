import Foundation

class GreedyAlg: AnyAlg {
    
    // MARK: - Properties
    
    var state: AnyAlgState = .notStarted
    
    // MARK: - Private Properties
    
    private let matrix: TaskInput
    private weak var debugger: AnyAlgDebugger? {
        didSet {
            updateDebuggerEvents()
        }
    }
    private var onResult: ((TaskOutput) -> Void)?
    
    private var seenIndexes: [Int] = []
    private var currentIndex: Int = -1
    private var currentSolution: [TaskOutput.PathItem] = []
    
    // MARK: - Initializaion
    
    required init(input: TaskInput) {
        self.matrix = input
    }
    
    // MARK: - Methods
    
    func calculate(onResult: ((TaskOutput) -> Void)?) {
        self.onResult = onResult
        state = .started
        
        initializeAlg()
        
        if debugger == nil {
            makeStep(runNextStepSutomatically: true)
        }
    }
    
    func reset() {
        state = .notStarted
    }
    
    func attachDebugger(_ debugger: AnyAlgDebugger) {
        self.debugger = debugger
    }
    
    // MARK: - Private Methods
    
    private func updateDebuggerEvents() {
        debugger?.onNeedNextStep = { [weak self] () -> TaskOutput? in
            guard let self = self else {
                return nil
            }
            switch self.state {
            case .notStarted:
                self.calculate(onResult: nil)
                self.makeStep(runNextStepSutomatically: false)
                return .init(value: 0, path: self.currentSolution)
            case .started:
                self.makeStep(runNextStepSutomatically: false)
                return .init(value: 0, path: self.currentSolution)
            case .finished:
                return .init(value: 0, path: self.currentSolution)
            }
        }
        debugger?.onNeedFinal = { [weak self] () -> TaskOutput? in
            guard let self = self else {
                return nil
            }
            switch self.state {
            case .notStarted:
                self.calculate(onResult: nil)
                self.makeStep(runNextStepSutomatically: true)
                return .init(value: 0, path: self.currentSolution)
            case .started:
                self.makeStep(runNextStepSutomatically: true)
                return .init(value: 0, path: self.currentSolution)
            case .finished:
                return .init(value: 0, path: self.currentSolution)
            }
        }
    }
    
    private func initializeAlg() {
        seenIndexes = [0]
        currentIndex = 0
        currentSolution = []
    }
    
    private func makeStep(runNextStepSutomatically: Bool) {
        guard state == .started else {
            return
        }
        guard
            let minItem = matrix.matrix[currentIndex]
                .enumerated()
                .filter({ $0.offset != currentIndex && !seenIndexes.contains($0.offset) })
                .min(by: { $0.element < $1.element })
        else {
            fatalError("greedy alg error")
        }
        currentSolution.append(.init(from: matrix.points[currentIndex], to: matrix.points[minItem.offset]))
        seenIndexes.append(minItem.offset)
        currentIndex = minItem.offset
        
        if seenIndexes.count == matrix.matrix.count {
            finishAlg()
        } else if runNextStepSutomatically {
            makeStep(runNextStepSutomatically: runNextStepSutomatically)
        }
    }
    
    private func finishAlg() {
        state = .finished
        onResult?(.init(value: 0, path: currentSolution))
    }
    
}
