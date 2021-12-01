import Foundation

class Day16: Day {
    static func part1(_ input: String) -> String {
        let nearbyTickets = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "nearby tickets:\n")[1].split(separator: "\n").compactMap { $0.split(separator: ",").compactMap { Int($0) } }
        let ruleStrings = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n\n")[0]
            .split(separator: "\n")
        
        var rules = [((Int, Int), (Int, Int))]()
        
        for rule in ruleStrings {
            let tokens = rule.components(separatedBy: ": ")[1].components(separatedBy: " or ").compactMap {
                $0.split(separator: "-").compactMap { Int($0) }
            }
            rules.append(((tokens[0][0], tokens[0][1]),(tokens[1][0], tokens[1][1])))
        }
        
        var invalidNums = [Int]()
        for ticket in nearbyTickets {
            for value in ticket {
                if matchingRules(value, rules).count == 0 {
                    invalidNums.append(value)
                }
            }
        }
        
        let res = invalidNums.reduce(0, +)
        return "\(res)"
    }
    
    static func part2(_ input: String) -> String {
        let nearbyTickets = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "nearby tickets:\n")[1].split(separator: "\n").compactMap { $0.split(separator: ",").compactMap { Int($0) } }
        let ruleStrings = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n\n")[0]
            .split(separator: "\n")
        let myTicket = input.components(separatedBy: "your ticket:\n")[1].split(separator: "\n")[0].split(separator: ",").compactMap { Int($0) }
        
        var rules = [((Int, Int), (Int, Int))]()
        var fieldNames = [String]()
        
        for rule in ruleStrings {
            let tokens = rule.components(separatedBy: ": ")[1].components(separatedBy: " or ").compactMap {
                $0.split(separator: "-").compactMap { Int($0) }
            }
            rules.append(((tokens[0][0], tokens[0][1]),(tokens[1][0], tokens[1][1])))
            fieldNames.append(rule.components(separatedBy: ": ")[0])
        }
        
        let valueCount = nearbyTickets[0].count
        let validTickets = nearbyTickets.filter {$0.allSatisfy {matchingRules($0, rules).count > 0}}
        
        // Build intial candidate mappings [ValueIndex:SetOfPossibleFields]
        var candidateMapping = [Int:Set<Int>]()
        let baseSet = Set(0..<rules.count)
        for valIx in 0..<valueCount {
            candidateMapping[valIx] = validTickets.reduce(into: baseSet, { (set, ticket) in
                set.formIntersection(matchingRules(ticket[valIx], rules))
            })
        }
        
        // Lock in values with a single candidate field
        var assigned = [Int]()
        var notAssigned = Set(candidateMapping.keys)
        while notAssigned.count > 0 {
            for (_, value) in notAssigned.enumerated() {
                if candidateMapping[value]!.count == 1,
                   let rule = candidateMapping[value]?.first {
                    assigned.append(value)
                    notAssigned.remove(value)
                    for value2 in notAssigned {
                        candidateMapping[value2]!.remove(rule)
                    }
                    break
                }
            }
        }
        
        var prod = 1
        for (ix, val) in myTicket.enumerated() {
            let fieldIx = candidateMapping[ix]!.first!
            if fieldNames[fieldIx].starts(with: "departure") {
                prod *= val
            }
        }
            
        return "\(prod)"
    }
    
    static func matchingRules(_ value: Int, _ rules: [((Int, Int), (Int, Int))]) -> [Int] {
        return rules.enumerated().filter { matchesRule(value, $0.element) }.map { $0.offset }
    }
    
    static func matchesRule(_ value: Int, _ rule: ((Int, Int), (Int, Int))) -> Bool {
        return (value >= rule.0.0 && value <= rule.0.1 || value >= rule.1.0 && value <= rule.1.1)
    }
}
