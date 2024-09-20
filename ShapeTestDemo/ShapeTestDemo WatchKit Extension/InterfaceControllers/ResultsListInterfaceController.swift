//
//  ResultsListInterfaceController.swift
//  ShapeTestDemo WatchKit Extension
//
//  Created by Bryan on 2024-09-19.
//  Copyright © 2024 CASAS. All rights reserved.
//

import Foundation
import WatchKit

class ResultsListInterfaceController: WKInterfaceController {
    @IBOutlet weak var resultsTable: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        updateInterface()
    }
    
    func updateInterface() {
        resultsTable.setNumberOfRows(ShapeTestResultStorage.shared.results.count, withRowType: "TestResultRow")
        
        for (index, result) in ShapeTestResultStorage.shared.results.enumerated() {
            let row = resultsTable.rowController(at: index) as! TestResultRowController
            
            row.setUp(forResult: result)
        }
    }
    
    @IBAction func clearResultsPushed() {
        ShapeTestResultStorage.shared.clearResults()
        
        updateInterface()
    }
}

class TestResultRowController: NSObject {
    @IBOutlet weak var stampLabel: WKInterfaceLabel!
    @IBOutlet weak var scoreLabel: WKInterfaceLabel!
    @IBOutlet weak var durationLabel: WKInterfaceLabel!
    
    func setUp(forResult result: TestResult) {
        stampLabel.setText(result.finishStamp.formatted(date: .numeric, time: .shortened))
        scoreLabel.setText("Score: \(result.score)/\(result.numAttempted)")
        durationLabel.setText("Duration: \(String(format: "%.0f", result.testDuration))s")
    }
}
