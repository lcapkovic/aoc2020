import Foundation

class Day15: Day {
    static func solve(to turns: Int, with startingNums: [Int]) -> Int {
        var spokenDict = startingNums.enumerated().reduce(into: [Int: (Int, Int)]()) {
            $0[$1.element] = (-1, $1.offset+1)
        }
        
        var turn = startingNums.count + 1
        var last = startingNums.last!
        while turn <= turns {
            if let spoken = spokenDict[last] {
                if spoken.0 == -1 {
                    last = 0
                } else {
                    last = max(spoken.0,spoken.1) - min(spoken.0,spoken.1)
                }
                spokenDict[last] = (spokenDict[last, default: (-1, -1)].1, turn)

                if turn % 1000000 == 0 {
                    print("Turn \(turn)")
                }
                turn += 1
            } else {
                print("BAD STATE!")
                break
            }
        }
        
        return last
    }
    
    static func part1(_ input: String) -> String {
        let startingNums = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ",")
            .compactMap { Int($0) }
        
        return "\(solve(to: 2020, with: startingNums))"
    }
    
    static func part2(_ input: String) -> String {
        let startingNums = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ",")
            .compactMap { Int($0) }
        
        return "\(solve(to: 30000000, with: startingNums))"
    }
}
