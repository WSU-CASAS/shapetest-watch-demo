//
//  TestResultInterfaceController.swift
//  ShapeTestDemo WatchKit Extension
//
//  Created by Bryan on 2024-09-19.
//  Copyright © 2024 CASAS. All rights reserved.
//

import Foundation
import WatchKit

class TestResultInterfaceController: WKInterfaceController {
    @IBOutlet weak var stampLabel: WKInterfaceLabel!
    @IBOutlet weak var scoreLabel: WKInterfaceLabel!
    @IBOutlet weak var durationLabel: WKInterfaceLabel!
    
    @IBOutlet weak var shapeResultsGroup: WKInterfaceGroup!
    @IBOutlet weak var shapesTable: WKInterfaceTable!
    
    private var testResult: TestResult?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let testResult = context as? TestResult {
            self.testResult = testResult
        }
        
        updateInterface()
    }
    
    func updateInterface() {
        if let testResult = testResult {
            stampLabel.setText(testResult.finishStamp.formatted(date: .numeric, time: .shortened))
            scoreLabel.setText("Score: \(testResult.score)/\(testResult.numAttempted)")
            durationLabel.setText("Duration: \(String(format: "%.0f", testResult.testDuration))s")
            
            shapesTable.setNumberOfRows(testResult.shapes.count, withRowType: "ShapeResultRow")
            
            for (index, result) in testResult.shapes.enumerated() {
                let row = shapesTable.rowController(at: index) as! ShapeResultRowController
                
                row.setUp(forResult: result)
            }
        } else {
            stampLabel.setText("MISSING TEST")
            
            scoreLabel.setHidden(true)
            durationLabel.setHidden(true)
            shapeResultsGroup.setHidden(true)
        }
    }
}

class ShapeResultRowController: NSObject {
    @IBOutlet weak var previousShapeLabel: WKInterfaceLabel!
    @IBOutlet weak var shapeLabel: WKInterfaceLabel!
    @IBOutlet weak var correctLabel: WKInterfaceLabel!
    @IBOutlet weak var reactionLabel: WKInterfaceLabel!
    
    func setUp(forResult result: ShapeResult) {
        previousShapeLabel.setText(result.previousShapeName)
        shapeLabel.setText(result.shapeName)
        correctLabel.setText(result.score > 0 ? "CORRECT (1)" : "WRONG (0)")
        reactionLabel.setText("Reaction: \(String(format: "%.2f", result.reactionTime))s")
    }
}
