import Foundation

class Day25: Day {
    static func part1(_ input: String) -> String {
        let publicKeys = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n").compactMap { Int($0) }
        print(publicKeys)
        
        let subject = 7
        let loopNumbers = publicKeys.map { (key: Int) -> Int in
            var curVal = 1
            for loopNumber in 1..<10000000 {
                curVal = (curVal * subject) % 20201227
                if curVal == key {
                    print(loopNumber)
                    return loopNumber
                }
            }
            return 0
        }
        
        var curVal = 1
        let subject2 = publicKeys[0]
        for _ in 0..<loopNumbers[1] {
            curVal = (curVal * subject2) % 20201227
        }
        print(curVal)
        curVal = 1
        let subject3 = publicKeys[1]
        for _ in 0..<loopNumbers[0] {
            curVal = (curVal * subject3) % 20201227
        }
        print(curVal)

        return ""
    }
    
    

    static func part2(_ input: String) -> String {
        return ""
    }
}
