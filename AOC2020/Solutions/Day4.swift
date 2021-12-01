//
//  Day3.swift
//  AdventOfCode2020
//
//  Created by Lukas Capkovic on 02/12/2020.
//  Copyright © 2020 Lukas Capkovic. All rights reserved.
//

import Foundation

class Day4: Day {
    static func part1(_ input: String) -> String {
        let passports = input.components(separatedBy: "\n\n")
        let required = ["byr","iyr","eyr", "hgt", "hcl", "ecl", "pid"]
                
        return String(passports.reduce(0) { count, pass in
            return required.contains(where: { !pass.contains($0) }) ? count : count + 1
        })
    }
    
    static func part2(_ input: String) -> String {
        let passports = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n\n")
        
        let required = ["byr","iyr","eyr", "hgt", "hcl", "ecl", "pid"]
        let acceptedColorChars = CharacterSet(charactersIn: "0123456789abcdef")
        let eyeColors = ["amb", "blu", "brn", "gry" ,"grn", "hzl", "oth"]
        
        var count = 0
        for pass in passports {
            var bad = false
            if required.contains(where: { !pass.contains($0) }) {
                continue
            }
            
            for field in pass.components(separatedBy: ["\n"," "]) {
                let key = field.split(separator: ":")[0]
                let val = field.split(separator: ":")[1]
                
                bad = true
                switch key {
                case "byr":
                    if let intVal = Int(val), (intVal >= 1920 && intVal <= 2002) {
                        bad = false
                    }
                case "iyr":
                    if let intVal = Int(val), (intVal >= 2010 && intVal <= 2020) {
                        bad = false
                    }
                case "eyr":
                    if let intVal = Int(val), (intVal >= 2020 && intVal <= 2030) {
                        bad = false
                    }
                case "hgt":
                    if val.contains("cm") {
                        if let intVal = Int(val.dropLast(2)), (intVal >= 150 && intVal <= 193) {
                            bad = false
                        }
                    } else if val.contains("in") {
                        if let intVal = Int(val.dropLast(2)), (intVal >= 59 && intVal <= 76) {
                            bad = false
                        }
                    }
                case "hcl":
                    if val.first == "#" &&
                        val.dropFirst().count == 6 &&
                        CharacterSet(charactersIn: String(val.dropFirst())).isSubset(of: acceptedColorChars)
                    {
                        bad = false
                    }
                case "ecl":
                    if eyeColors.contains(String(val)) {
                        bad = false
                    }
                case "pid":
                    if val.count == 9 && Int(val) != nil {
                        bad = false
                    }
                default:
                    bad = false
                }
                
                if bad {
                    break
                }
            }
            if !bad {
                count += 1
            }
        }
        
        return "\(count)"
    }
}
