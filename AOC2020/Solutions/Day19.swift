import Foundation

class Day19: Day {
    static func part1(_ input: String) -> String {
        let lines = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n\n")
        
        var letterRules = [Int:String]()
        var rules = [Int:[[Int]]]()
        for rule in lines[0].components(separatedBy: "\n") {
            let tokens = rule.components(separatedBy: ": ")
            let key = Int(tokens[0])!
            var matches = [[Int]]()
            for match in tokens[1].components(separatedBy: " | ") {
                if match.first! == "\"" {
                    letterRules[key] = String(match.dropFirst().first!)
                } else {
                    matches.append(match.split(separator: " ").map { Int($0)! })
                }
            }
            if matches.count > 0 {
                rules[key] = matches
            }
        }
        
        let goodOnes = Set(evalRule(0, rules, letterRules))
        
        var matching = 0
        for str in lines[1].split(separator: "\n") {
            if goodOnes.contains(String(str)) {
                matching += 1
            }
        }
        return "\(matching)"
    }
    
    static var memo = [Int:[String]]()
    
    static func evalRule(_ rule: Int, _ rules: [Int:[[Int]]], _ letterRules: [Int:String]) -> [String] {
        if let s = letterRules[rule] {
            return [s]
        }
        
        if let memoized = memo[rule] {
            return memoized
        }
        
        let matches = rules[rule]!
        var returnStrings = [String]()
        for match in matches {
            let subStrings = match.map { evalRule($0, rules, letterRules) }
            returnStrings.append(contentsOf: combineStringMatches(subStrings))
        }
        
        memo[rule] = returnStrings
        return returnStrings
    }
    
    static func combineStringMatches(_ arr:[[String]]) -> [String] {
        if arr.count == 1 {
            return arr[0]
        }
        
        var result = [String]()
        let rest = Array(arr.dropFirst())
        for l in arr[0] {
            for r in combineStringMatches(rest) {
                result.append(l+r)
            }
        }
        return result
    }

    static func part2(_ input: String) -> String {
        let lines = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n\n")
        
        var letterRules = [Int:String]()
        var rules = [Int:[[Int]]]()
        for rule in lines[0].components(separatedBy: "\n") {
            let tokens = rule.components(separatedBy: ": ")
            let key = Int(tokens[0])!
            var matches = [[Int]]()
            for match in tokens[1].components(separatedBy: " | ") {
                if match.first! == "\"" {
                    letterRules[key] = String(match.dropFirst().first!)
                } else {
                    matches.append(match.split(separator: " ").map { Int($0)! })
                }
            }
            if matches.count > 0 {
                rules[key] = matches
            }
        }
        
        // 0: 8 11
        // 0: (42+) (42 31)|(42 42 31 31) | (42 42 42 31 31 31) ...
        
        rules[8] = [[42], [42, 8]]
        rules[11] = [[42, 31], [42, 11, 31]]
        
        let matches42 = evalRule(42, rules, letterRules)
        let matches31 = evalRule(31, rules, letterRules)
        
        // we just assume all of them are the same length
        let patternSize = matches42[0].count
        var matchCount = 0
        
        for str in lines[1].split(separator: "\n") {
            var startIx = str.startIndex
            var endIx = str.index(startIx, offsetBy: patternSize)
            
            var count42 = 0
            while endIx.utf16Offset(in: str) <= str.count, matches42.contains(String(str[startIx..<endIx])) {
                count42 += 1
                startIx = str.index(startIx, offsetBy: patternSize)
                if startIx.utf16Offset(in: str) >= str.count {
                    break
                }
                endIx = str.index(startIx, offsetBy: patternSize)
            }
            
            var count31 = 0
            while endIx.utf16Offset(in: str) <= str.count, matches31.contains(String(str[startIx..<endIx])) {
                count31 += 1
                startIx = str.index(startIx, offsetBy: patternSize)
                if startIx.utf16Offset(in: str) >= str.count {
                    break
                }
                endIx = str.index(startIx, offsetBy: patternSize)
            }
            
            if  count42 > 0 && count31 > 0 &&
                count31 <= count42-1 && ((count42 + count31) * patternSize) == str.count{
                matchCount += 1
            }
        }
        return "\(matchCount)"
    }
}
