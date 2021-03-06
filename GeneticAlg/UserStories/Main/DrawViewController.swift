//
//  DrawViewController.swift
//  GeneticAlg
//
//  Created by al.filimonov on 06.03.2021.
//

import UIKit

final class DrawViewController: UIViewController {
    
    // MARK: - Nested Types
    
    private enum SystemButtonType: String {
        case refresh = "arrow.2.circlepath.circle"
        case next = "arrow.uturn.right.circle"
        case solve = "checkmark.circle"
        case debugger = "number.circle"
    }
    
    // MARK: - Constants
    
    private enum Constants {
        static let buttonContentInsets = UIEdgeInsets(top: 10, left: 3, bottom: 10, right: 3)
    }
    
    // MARK: - Private Properties
    
    private var matrix: TaskInput!
    private var currentSolution: TaskOutput?
    private var alg: AnyAlg!
    private var debugger: AlgDebugger?
    
    private let layerToDraw = CALayer()
    private let debuggerButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    
    private var useDebugger = false
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAllAlgProps(generateNewMatrix: true)
        configureAppearance()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // layout layer for drawinf
        layerToDraw.sublayers?.forEach { $0.removeFromSuperlayer() }
        layerToDraw.frame = view.bounds.inset(by: view.safeAreaInsets)
        layerToDraw.frame = layerToDraw.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0))
        
        // setup global settings for drawing
        let pointSize: CGFloat = 22
        let rectToDisplay = layerToDraw.bounds.insetBy(dx: 12, dy: 20)
        let screenWidth = rectToDisplay.width
        let screenHeight = rectToDisplay.height
        let shouldDrawBorder = false
        
        // draw border
        if (shouldDrawBorder) {
            let rectBezierPath = UIBezierPath(rect: rectToDisplay)
            let rectLayer = CAShapeLayer()
            rectLayer.path = rectBezierPath.cgPath
            rectLayer.strokeColor = UIColor.systemGray.cgColor
            rectLayer.fillColor = UIColor.clear.cgColor
            layerToDraw.addSublayer(rectLayer)
        }
        
        // check solution
        if let solution = currentSolution {
            for pathItem in solution.path {
                let linePath = UIBezierPath()
                linePath.move(to: CGPoint(x: CGFloat(pathItem.from.x) * screenWidth + rectToDisplay.minX,
                                          y: CGFloat(pathItem.from.y) * screenHeight + rectToDisplay.minY))
                linePath.addLine(to: CGPoint(x: CGFloat(pathItem.to.x) * screenWidth + rectToDisplay.minX,
                                             y: CGFloat(pathItem.to.y) * screenHeight + rectToDisplay.minY))
                
                let layer = CAShapeLayer()
                layer.path = linePath.cgPath
                layer.strokeColor = UIColor.systemOrange.cgColor
                layer.lineWidth = 2
                layerToDraw.addSublayer(layer)
            }
        }
        
        // draw points
        for point in matrix.points.enumerated() {
            let dotRect = CGRect(x: CGFloat(point.element.x) * screenWidth - pointSize / 2 + rectToDisplay.minX,
                                 y: CGFloat(point.element.y) * screenHeight - pointSize / 2 + rectToDisplay.minY,
                                 width: pointSize,
                                 height: pointSize)
            let dotPath = UIBezierPath(ovalIn: dotRect)
            let layer = CAShapeLayer()
            layer.path = dotPath.cgPath
            layer.strokeColor = UIColor.systemGreen.cgColor
            layer.lineWidth = 1.5
            layer.fillColor = UIColor.black.cgColor
            layerToDraw.addSublayer(layer)
            
            let textLayer = CATextLayer()
            textLayer.string = "\(point.offset)"
            textLayer.frame = dotRect
            textLayer.fontSize = 17
            textLayer.alignmentMode = .center
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.foregroundColor = UIColor.systemGreen.cgColor
            layerToDraw.addSublayer(textLayer)
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func refreshButtonPressed(_ sender: UIButton) {
        initializeAllAlgProps(generateNewMatrix: true)
        view.setNeedsLayout()
    }
    
    @objc
    private func nextButtonPressed(_ sender: UIButton) {
        if let debugger = debugger {
            currentSolution = debugger.next() ?? currentSolution
            view.setNeedsLayout()
        }
    }
    
    @objc
    private func solveButtonPressed(_ sender: UIButton) {
        if let debugger = debugger {
            currentSolution = debugger.finalize() ?? currentSolution
            view.setNeedsLayout()
        } else {
            alg.calculate(onResult: { [weak self] result in
                self?.currentSolution = result
                self?.view.setNeedsLayout()
            })
        }
    }
    
    @objc
    private func debuggerButtonPressed(_ sender: UIButton) {
        useDebugger.toggle()
        updateDebugButtonAppearance()
        
        initializeAllAlgProps(generateNewMatrix: false)
        view.setNeedsLayout()
    }
    
    // MARK: - Private Methods
    
    private func configureAppearance() {
        let buttonsStackView = UIStackView()
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsStackView)
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.alignment = .center
        buttonsStackView.spacing = 0
        NSLayoutConstraint.activate([
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
        
        let refreshButton = UIButton(type: .system)
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.setImage(getSystemImage(forType: .refresh), for: .normal)
        refreshButton.addTarget(self, action: #selector(refreshButtonPressed(_:)), for: .touchUpInside)
        refreshButton.contentEdgeInsets = Constants.buttonContentInsets
        buttonsStackView.addArrangedSubview(refreshButton)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setImage(getSystemImage(forType: .next), for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonPressed(_:)), for: .touchUpInside)
        nextButton.contentEdgeInsets = Constants.buttonContentInsets
        buttonsStackView.addArrangedSubview(nextButton)
        
        let solveButton = UIButton(type: .system)
        solveButton.translatesAutoresizingMaskIntoConstraints = false
        solveButton.setImage(getSystemImage(forType: .solve), for: .normal)
        solveButton.addTarget(self, action: #selector(solveButtonPressed(_:)), for: .touchUpInside)
        solveButton.contentEdgeInsets = Constants.buttonContentInsets
        buttonsStackView.addArrangedSubview(solveButton)
        
        debuggerButton.translatesAutoresizingMaskIntoConstraints = false
        debuggerButton.setImage(getSystemImage(forType: .debugger), for: .normal)
        debuggerButton.addTarget(self, action: #selector(debuggerButtonPressed(_:)), for: .touchUpInside)
        debuggerButton.contentEdgeInsets = Constants.buttonContentInsets
        buttonsStackView.addArrangedSubview(debuggerButton)
        updateDebugButtonAppearance()
        
        view.layer.addSublayer(layerToDraw)
    }
    
    private func getSystemImage(forType type: SystemButtonType) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let image = UIImage(systemName: type.rawValue, withConfiguration: config)
        return image
    }
    
    private func updateDebugButtonAppearance() {
        debuggerButton.tintColor = useDebugger ? .systemGreen : .systemGray
        nextButton.isEnabled = useDebugger
    }
    
    private func initializeAllAlgProps(generateNewMatrix: Bool) {
        if generateNewMatrix {
            matrix = GeneticAlgMatrixGenerator(size: 10).generate()
        }
        currentSolution = nil
        alg = getNewAlg(matrix: matrix)
        if useDebugger {
            let currentDebugger = AlgDebugger()
            alg.attachDebugger(currentDebugger)
            debugger = currentDebugger
        } else {
            debugger = nil
        }
    }
    
    private func getNewAlg(matrix: TaskInput) -> AnyAlg {
        return GreedyAlg(input: matrix)
    }
    
}
