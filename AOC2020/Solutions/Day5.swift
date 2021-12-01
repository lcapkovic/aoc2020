//
//  Day3.swift
//  AdventOfCode2020
//
//  Created by Lukas Capkovic on 02/12/2020.
//  Copyright © 2020 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day5: Day {
    static func part1(_ input: String) -> String {
        let seats = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n").compactMap() { Array($0) }

        var highest = 0
        var ids = [Int]()
        for seat in seats {
            var lb = 0
            var ub = 128
            for i in 0..<7 {
                if seat[i] == "F" {
                    ub = ub - (ub-lb)/2
                } else {
                    lb = lb + (ub-lb)/2
                }
            }
            
            let row = lb
            lb = 0
            ub = 8
            
            for i in 7..<10 {
                if seat[i] == "L" {
                    ub = ub - (ub-lb)/2
                } else {
                    lb = lb + (ub-lb)/2
                }
            }
            let col = lb
            let id = row * 8 + col
            ids.append(id)
            highest = max(highest, id)
        }
        
        for id in 8..<1016 {
            if ids.contains(id+1) && ids.contains(id-1) && !ids.contains(id) {
                print("My seat id is: \(id)")
                break
            }
        }
        return "Highest id: \(highest)"
    }
    
    static func part2(_ input: String) -> String {
        return "See part 1 for both answers ^^^"
    }
}
