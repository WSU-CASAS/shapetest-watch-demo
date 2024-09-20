//
//  ShapeTestPromptInterfaceController.swift
//  ShapeTestDemo WatchKit Extension
//
//  Created by Bryan Minor on 8/6/21.
//  Copyright © 2021 CASAS. All rights reserved.
//

import Foundation
import WatchKit

class ShapeTestPromptInterfaceController: WKInterfaceController {
    /// Interface specifically for showing the shape test prompt
    
    @IBOutlet weak var shapeGroup: WKInterfaceGroup!
    @IBOutlet weak var countdownLabel: WKInterfaceLabel!
    
    @IBOutlet weak var buttonsGroup: WKInterfaceGroup!
    @IBOutlet weak var yesButton: WKInterfaceButton!
    @IBOutlet weak var noButton: WKInterfaceButton!
    
    private var language: ShapeTestLanguage = .english
    
    private var shapeResults: [ShapeResult] = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let language = context as? ShapeTestLanguage {
            self.language = language
        }
        
        setupShapeTest()
    }
    
    override func didAppear() {
        super.didAppear()
        
        // Start the timer/test:
        startShapeTest()
    }
    
    override func willDisappear() {
        super.willDisappear()
        
        // Clear the timer:
        countdownTimer.invalidate()
    }
    
    // Countdown times for shape test:
    private var startTimeLeft: Int = 3
    private var mainTestTimeLeft: Int = 45
    
    // Which part of the test we're in:
    private var inMainTest: Bool = false
    
    /// Time to show on the screen (depends on if in start or main test):
    private var currentTimeLeft: Int {
        if inMainTest {
            return mainTestTimeLeft
        } else {
            return startTimeLeft
        }
    }
    
    private var countdownTimer = Timer()
    
    // List of shapes we can use:
    private var shapesList: [String] {
        return [
            "Circle",
            "Diamond",
            "Triangle"
        ]
    }
    
    // Hold the current and previous shapes shown:
    private var currentShapeIndex: Int = -1
    private var previousShapeIndex: Int = -1
    
    private var currentShapeName: String {
        return shapesList[currentShapeIndex]
    }
    private var previousShapeName: String {
        return shapesList[previousShapeIndex]
    }
    
    // Log when the current shape was started:
    private var currentShapeStart: Date = Date()
    
    /// Set up the shape test:
    private func setupShapeTest() {
        // Pick the initial shape:
        showNewShape()
        
        updateTimeLeft()
        
        switch language {
        case .spanish:
            yesButton.setTitle("SÍ")
            noButton.setTitle("NO")
        default:
            yesButton.setTitle("YES")
            noButton.setTitle("NO")
        }
        
        setupTestStartVisibility()
    }
    
    /// Actually start the shape test (e.g. start the starting countdown):
    private func startShapeTest() {
        countdownTimer = Timer.scheduledTimer(
            withTimeInterval: 1.0, // tick every second
            repeats: true,
            block: {
                (timer) in
                self.timerTick()
            }
        )
    }
    
    /// Start the main part of the test:
    private func switchToMainPartOfTest() {
        showNewShapeAfterDelay()
        
        showButtons()
        
        inMainTest = true
    }
    
    /// Show a new shape with a short delay:
    private func showNewShapeAfterDelay() {
        hideShapeAndButtons()
        
        // Call the showNewShape() method after waiting the specified number of seconds:
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showNewShape()
            self.showButtons()
        }
    }
    
    /// Randomly pick and then show a new shape:
    private func showNewShape() {
        var nextShapeIndex = pickNewShapeIndex()
        
        // Don't show same shape more than twice in a row:
        while previousShapeIndex == currentShapeIndex && currentShapeIndex == nextShapeIndex {
            nextShapeIndex = pickNewShapeIndex()
        }
        
        previousShapeIndex = currentShapeIndex
        currentShapeIndex = nextShapeIndex
        
        updateCurrentShape()
        
        currentShapeStart = Date()
    }
    
    /// Randomly pick index of a shape:
    private func pickNewShapeIndex() -> Int {
        return Int.random(in: 0..<shapesList.count)
    }
    
    /// Show the currently-selected shape:
    private func updateCurrentShape() {
        // Set the background image of the shape area:
        shapeGroup.setBackgroundImageNamed(currentShapeName)
        
        // Set the countdown text to black so it shows up on the shape:
        countdownLabel.setTextColor(.black)
    }
    
    /// Update the timer label to show the current time left:
    private func updateTimeLeft() {
        countdownLabel.setText(String(currentTimeLeft))
    }
    
    /// Set up element visibility for start of shape test:
    private func setupTestStartVisibility() {
        // Hide the buttons:
        yesButton.setHidden(true)
        noButton.setHidden(true)
    }
    
    private func hideShapeAndButtons() {
        // Clear ("hide") the shape image:
        shapeGroup.setBackgroundImage(nil)
        
        // Set the countdown text to white so it shows up with no shape:
        countdownLabel.setTextColor(.white)
        
        // Hide the buttons:
        yesButton.setHidden(true)
        noButton.setHidden(true)
    }
    
    private func showButtons() {
        // Show the buttons:
        yesButton.setHidden(false)
        noButton.setHidden(false)
    }
    
    /// Called when the timer "ticks" every second:
    func timerTick() {
        // Decrement the two countdowns:
        startTimeLeft -= 1
        
        if inMainTest {
            mainTestTimeLeft -= 1
        }
        
        // Check if it's time to start the main test:
        if !inMainTest && startTimeLeft <= 0 {
            switchToMainPartOfTest()
        }
        
        // Update the countdown display:
        updateTimeLeft()
        
        // Check if we've ended the main test:
        if inMainTest && mainTestTimeLeft <= 0 {
            finishTest()
        }
    }
    
    @IBAction func yesButtonPushed() {
        handleButtonPress(pressedYes: true)
    }
    
    @IBAction func noButtonPushed() {
        handleButtonPress(pressedYes: false)
    }
    
    /// Handle button press (passinf in whether they pushed the "YES" buton):
    private func handleButtonPress(pressedYes answeredShapeIsSame: Bool) {
        let currentShapeEnd = Date()
        let shapeReactionTime = currentShapeEnd.timeIntervalSince(currentShapeStart)
        
        var score = 0
        
        if currentShapeIndex == previousShapeIndex {
            // Shape is the same, so give a point if the user says so:
            score = answeredShapeIsSame ? 1 : 0
        } else {
            // Shape is different, so give a point if the user says they're not the same:
            score = answeredShapeIsSame ? 0 : 1
        }
        
        shapeResults.append(
            ShapeResult(
                previousShapeName: previousShapeName,
                shapeName: currentShapeName,
                score: score,
                reactionTime: shapeReactionTime
            )
        )
        
        showNewShapeAfterDelay()
    }
    
    /// Finish the test and save results:
    private func finishTest() {
        print("Finishing test")
        
        // Clear the timer:
        countdownTimer.invalidate()
        
        // Calculate duration of test and tell prompt we're finished:
        let testDuration = TimeInterval(45 - mainTestTimeLeft)
        let finishStamp = Date.now
        
        ShapeTestResultStorage.shared.addResult(
            TestResult(
                shapes: shapeResults,
                testDuration: testDuration,
                finishStamp: finishStamp
            )
        )
        
        dismiss()
    }
}
