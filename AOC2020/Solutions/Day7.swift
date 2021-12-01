import Foundation

struct BagEntry {
    var name: String
    var count: Int
}

class Day7: Day {
    static func possibleContainerBags(of bag: String, dict: [String:Set<String>]) -> Set<String> {
        guard let direct = dict[bag] else {
            return []
        }
        
        var indirect = Set<String>()
        for b in direct {
            indirect = indirect.union(possibleContainerBags(of: b, dict: dict))
        }
        
        return direct.union(indirect)
    }
    
    static func part1(_ input: String) -> String {
        let lines = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
        
        var dict = [String:Set<String>]()
        for line in lines {
            if line.contains("no other") {
                continue
            }
            
            let split = line.components(separatedBy: " bags contain ")
            let left = split[0].split(separator: " ").joined()
            let containedBags = split[1].dropLast().components(separatedBy: ", ")
            
            for containedBag in containedBags {
                let bagKey = containedBag.split(separator: " ")[1...2].joined()
                if dict[bagKey] != nil {
                    dict[bagKey]!.insert(left)
                } else {
                    dict[bagKey] = Set([left])
                }
            }
        }

        return "\(possibleContainerBags(of: "shinygold", dict: dict).count)"
    }
    
    static func calculateContained(in bag: String, dict: [String:[BagEntry]]) -> Int {
        if dict[bag]!.count == 0 {
            return 0
        }
        
        var total = 0
        for bagEntry in dict[bag]! {
            total += bagEntry.count + bagEntry.count * calculateContained(in: bagEntry.name, dict: dict)
        }
        
        return total
    }
    
    static func part2(_ input: String) -> String {
        let lines = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
        var dict = [String:[BagEntry]]()
        
        for line in lines {
            let split = line.components(separatedBy: " bags contain ")
            let left = split[0].split(separator: " ").joined()
            dict[left] = []
            
            if line.contains("no other") {
                continue
            }
            
            let containedBags = split[1].trimmingCharacters(in: .punctuationCharacters).components(separatedBy: ", ")
            
            for containedBag in containedBags {
                let tokens = containedBag.split(separator: " ")
                let bagCount = Int(tokens[0])!
                let bagKey = tokens[1...2].joined()
                
                dict[left]!.append(BagEntry(name: bagKey, count: bagCount))
            }
        }
        
        return "\(calculateContained(in: "shinygold", dict: dict))"
    }
}
