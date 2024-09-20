//
//  ShapeTestResultStorage.swift
//  ShapeTestDemo WatchKit Extension
//
//  Created by Bryan on 2024-09-19.
//  Copyright © 2024 CASAS. All rights reserved.
//

import Foundation

class ShapeTestResultStorage {
    static let shared = ShapeTestResultStorage()
    
    var results: [TestResult]
    
    init() {
        if let resultData = UserDefaults.standard.data(forKey: "test_results"),
           let results = try? PropertyListDecoder().decode([TestResult].self, from: resultData) {
            self.results = results
        } else {
            self.results = []
        }
    }
    
    func addResult(_ newTest: TestResult) {
        results.append(newTest)
        
        results.sort {
            $0.finishStamp < $1.finishStamp
        }
        
        if let resultsData = try? PropertyListEncoder().encode(results) {
            UserDefaults.standard.set(resultsData, forKey: "test_results")
        }
    }
    
    func clearResults() {
        results.removeAll()
        
        UserDefaults.standard.removeObject(forKey: "test_results")
    }
}
