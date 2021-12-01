import Foundation

class Day13: Day {
    static func part1(_ input: String) -> String {
        let lines = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
        let earliest = Int(lines[0])!
        let buses = lines[1].split(separator: ",").compactMap { Int($0) }
        
        var lowest = Int.max
        var lowestId = 0
        for bus in buses {
            let mod = earliest % bus
            if bus - mod < lowest {
                lowest = bus - mod
                lowestId = bus
            }
        }
        return "\(lowestId * lowest)"
    }


    static func part2(_ input: String) -> String {
        let lines = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
        let buses = lines[1].split(separator: ",")
        
        var delay = 0
        var remainders = [Int]()
        var busIds = [Int]()
        for bus in buses {
            if bus != "x" {
                remainders.append(-delay)
                busIds.append(Int(bus)!)
            }
            delay += 1
        }
                    
        return  "\(CRT(remainders, busIds))"
    }
}
