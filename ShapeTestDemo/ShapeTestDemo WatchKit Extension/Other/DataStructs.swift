//
//  DataStructs.swift
//  ShapeTestDemo WatchKit Extension
//
//  Created by Bryan on 2024-09-19.
//  Copyright © 2024 CASAS. All rights reserved.
//

import Foundation

enum ShapeTestLanguage {
    case english
    case spanish
}

/// Result for a single shape:
struct ShapeResult: Codable {
    let previousShapeName: String
    let shapeName: String
    let score: Int
    let reactionTime: TimeInterval
}

/// Results for a full test:
struct TestResult: Codable {
    let shapes: [ShapeResult]
    let testDuration: TimeInterval
    let finishStamp: Date
}
