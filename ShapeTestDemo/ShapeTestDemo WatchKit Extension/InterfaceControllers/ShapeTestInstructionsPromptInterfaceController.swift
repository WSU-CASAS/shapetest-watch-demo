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
    
    private var language: ShapeTestLanguage = .english
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let language = context as? ShapeTestLanguage {
            self.language = language
        }
        
        updateInterface()
    }
    
    private func updateInterface() {
        switch language {
        case .spanish:
            englishInstructionsGroup.setHidden(true)
            spanishInstructionsGroup.setHidden(false)
        default:
            englishInstructionsGroup.setHidden(false)
            spanishInstructionsGroup.setHidden(true)
        }
    }
    
    @IBAction func startButtonPressed() {
        // Dissmiss this prompt:
        dismiss()
        
        WKExtension.shared().rootInterfaceController?.presentController(withName: "ShapeTestPromptInterface", context: language)
    }
}
