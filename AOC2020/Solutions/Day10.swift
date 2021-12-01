import Foundation

class Day10: Day {
    static func part1(_ input: String) -> String {
        var joltages = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n").compactMap() { Int($0) }
        joltages.sort()
        joltages.append(joltages.last! + 3)
        
        var prev = 0
        var j1count = 0
        var j3count = 0
        for j in joltages {
            if j - prev == 1 {
                j1count += 1
            } else if j - prev == 3 {
                j3count += 1
            }
            prev = j
        }
        
        
        return "\(j1count*j3count)"
    }
    
// The recursive soluton
//    static func compute(nums: [Int], cur: Int) -> Int {
//        if cur == nums.last! {
//            return 1;
//        }
//
//        var sum = 0
//        for x in [1,2,3] {
//            if nums.contains(cur + x) {
//                sum += compute(nums: nums, cur: cur + x)
//            }
//        }
//        return sum
//    }

    static func part2(_ input: String) -> String {
        var joltages = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n").compactMap() { Int($0) }
        joltages.append(0)
        joltages.sort()
        joltages.append(joltages.last! + 3)
                
        var pathsFrom = [Int](repeating: 0, count: joltages.last!+1)
        pathsFrom[joltages.last!] = 1
        
        for joltage in joltages.reversed() {
            for step in [1,2,3] {
                if joltages.contains(joltage+step) {
                    pathsFrom[joltage] += pathsFrom[joltage+step]
                }
            }
        }
        return "\(pathsFrom[joltages.first!])"
    }
}
