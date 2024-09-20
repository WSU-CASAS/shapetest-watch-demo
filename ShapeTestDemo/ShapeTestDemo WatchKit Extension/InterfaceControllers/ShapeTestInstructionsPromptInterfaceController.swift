//
//  ShapeTestInstructionsPromptInterfaceController.swift
//  ShapeTestDemo WatchKit Extension
//
//  Created by Bryan Minor on 8/11/21.
//  Copyright © 2021 CASAS. All rights reserved.
//

import Foundation
import WatchKit

class ShapeTestInstructionsPromptInterfaceController: WKInterfaceController {
    /// Interface specifically for showing the shape test instructions
    @IBOutlet weak var englishInstructionsGroup: WKInterfaceGroup!
    @IBOutlet weak var spanishInstructionsGroup: WKInterfaceGroup!
    
//    private var prompt: ShapeTestInstructionsPrompt?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
//        if let promptToShow = context as? ShapeTestInstructionsPrompt {
//            prompt = promptToShow
//        }
        
        updateInterface()
    }
    
    private func updateInterface() {
//        switch prompt?.instructionsLanguage {
//        case .spanish:
//            englishInstructionsGroup.setHidden(true)
//            spanishInstructionsGroup.setHidden(false)
//        default:
            englishInstructionsGroup.setHidden(false)
            spanishInstructionsGroup.setHidden(true)
//        }
    }
    
    @IBAction func startButtonPressed() {
//        // Mark prompt as responded to:
//        prompt?.promptResponseTime = Date()
//        
//        // Tell PromptManager to move on to the next prompt:
//        PromptManager.sharedInstance.moveToNextPromptInGroup()
        
        // Dissmiss this prompt:
        dismiss()
    }
}
