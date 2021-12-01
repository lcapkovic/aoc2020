import Foundation

class Day9: Day {
    static func canSum(num: Int, with nums: ArraySlice<Int>) -> Bool {
        for x in nums {
            if nums.contains(num - x) {
                return true
            }
        }
        return false
    }
    static func part1(_ input: String) -> String {
        let nums = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n").compactMap() {Int($0)}
                
        var ix = 25
        while canSum(num: nums[ix], with: nums[ix-25..<ix]) {
            ix += 1
        }
        
        let invalid = nums[ix]
        print("Invalid number is: \(invalid)")
        
        var lower = 0
        var upper = 1
        var runningSum = nums[0]+nums[1]
        
        while runningSum != invalid {
            if runningSum < invalid {
                while runningSum < invalid {
                    upper += 1
                    runningSum += nums[upper]
                }
            } else {
                while runningSum > invalid {
                    runningSum -= nums[lower]
                    lower += 1
                }
            }
        }
        let range = nums[lower...upper]
        return "\(range.min()! + range.max()!)"
    }
    
    static func part2(_ input: String) -> String {
        return "See result of part 1 ^^^"
    }
}
