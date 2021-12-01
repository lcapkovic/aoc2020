//
//  Day.swift
//  AdventOfCode2016
//
//  Created by Lukas Capkovic on 27/11/2019.
//  Copyright © 2019 Lukas Capkovic. All rights reserved.
//

import Foundation

protocol Day {
    static func part1(_ input: String) -> String
    
    static func part2(_ input: String) -> String
}

extension Day {
    static func solvePart1(with input: String) {
        guard let inputStr = try? Input.get(input) else {
            print("Could not load the file \(input)")
            return
        }
        
        print("Solving \(Self.self) part 1 on \(input)")
        let start = CFAbsoluteTimeGetCurrent()
        print("\(part1(inputStr))")
        
        let end = CFAbsoluteTimeGetCurrent()
        let elapsed = (end - start) * 1000
        
        let formatted = String(format: "%.5f", elapsed)
        
        print("Execution time: \(formatted)ms.")
    }
    
    static func solvePart2(with input: String) {
        guard let inputStr = try? Input.get(input) else {
            print("Could not load the file \(input)")
            return
        }
        
        print("Solving \(Self.self) part 2 on \(input)")
        let start = CFAbsoluteTimeGetCurrent()
        print("\(part2(inputStr))")
        
        let end = CFAbsoluteTimeGetCurrent()
        let elapsed = (end - start) * 1000
        
        let formatted = String(format: "%.5f", elapsed)
        
        print("Execution time: \(formatted)ms.")
    }
    static func solve(with input: String) {
        solvePart1(with: input)
        solvePart2(with: input)
    }
}
