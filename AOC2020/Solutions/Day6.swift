import Foundation

class Day6: Day {
    static func part1(_ input: String) -> String {
        let parsed = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n\n").compactMap() {Set($0) }
        
        var total = 0
        for group in parsed {
            total += group.count
            if group.contains("\n") {
                total -= 1
            }
        }
        return "\(total)"
    }
    
    static func part2(_ input: String) -> String {
        let groups = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n\n")
        
        var total = 0
        for group in groups {
            let people = group.split(separator: "\n").compactMap { Set($0) }
            let intersection = people.reduce(Set(group)) { $0.intersection(Set($1)) }
            
            total += intersection.count
            
            if intersection.contains("\n") {
                total -= 1
            }
        }

        return "\(total)"
    }
}
