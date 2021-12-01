//
//  Day3.swift
//  AdventOfCode2020
//
//  Created by Lukas Capkovic on 02/12/2020.
//  Copyright © 2020 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day3: Day {
    static func part1(_ input: String) -> String {
        let map = input.split(separator: "\n").compactMap { Array($0) }
        let rowLen = map[0].count
        
        var loc = Vec(r: 0, c: 0)
        var treeCount = 0
        while loc.r < map.count {
            if map[loc.r][loc.c % rowLen] == "#" {
                treeCount += 1
            }
            loc = Vec(r: loc.r + 1, c: loc.c + 3)
        }

        return "\(treeCount)"
    }
    
    static func part2(_ input: String) -> String {
        let map = input.split(separator: "\n").compactMap { Array($0) }
        let rowLen = map[0].count
        
        let slopes = [Vec(r: 1, c: 1), Vec(r: 1, c: 3), Vec(r: 1, c: 5), Vec(r: 1, c: 7), Vec(r: 2, c: 1)]
        var result = 1
        
        for slope in slopes {
            var treeCount = 0
            var loc = Vec(r: 0, c: 0)
            while loc.r < map.count {
                if map[loc.r][loc.c % rowLen] == "#" {
                    treeCount += 1
                }
                loc = Vec(r: loc.r + slope.r, c: loc.c + slope.c)
            }
            
            result *= treeCount
        }

        return "\(result)"
    }
}
