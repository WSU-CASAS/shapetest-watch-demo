//
//  InterfaceController.swift
//  ShapeTestDemo WatchKit Extension
//
//  Created by Bryan on 5/21/19.
//  Copyright © 2019 CASAS. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBAction func englishTestPushed() {
        presentController(withName: "ShapeTestInstructionsPromptInterface", context: ShapeTestLanguage.english)
    }
    
    @IBAction func spanishTestPushed() {
        presentController(withName: "ShapeTestInstructionsPromptInterface", context: ShapeTestLanguage.spanish)
    }
}
