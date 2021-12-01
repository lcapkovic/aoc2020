import Foundation

class Day11: Day {
    static func isInBounds(_ pos: Vec, _ limit: Vec) -> Bool {
        if pos.r < 0 || pos.r >= limit.r || pos.c < 0 || pos.c >= limit.c {
                return false
        }
        return true
    }
    
    static let deltas: [Vec] = [[0,1], [0,-1], [1,0], [-1,0], [1,1], [1,-1], [-1, -1], [-1, 1]]
    
    static func advanceStep(input: [[Int]]) -> [[Int]] {
        var output = input
        let limit = Vec(r: input.count, c: input[0].count)
        
        for row in 1..<limit.r-1 {
            for col in 1..<limit.c-1 {
                let curVal = input[row][col]
                if curVal == 0 {
                    continue
                }
                let curPos: Vec = [row, col]
                var occupied = 0
                for delta in deltas {
                    if input[curPos.r + delta.r][curPos.c + delta.c] == 2 {
                        occupied += 1
                        if curVal == 1 {
                            break
                        }
                    }
                }
                
                if curVal == 1 && occupied == 0 {
                    output[row][col] = 2
                } else if curVal == 2 && occupied >= 4 {
                    output[row][col] = 1
                }
            }
        }
        return output
    }
    
    static func part1(_ input: String) -> String {
        // 0: floor, 1: free, 2: occupied
        let map = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
            .compactMap { line in
                ".\(line).".compactMap { char -> Int in
                    return char == "." ? 0 : 1
                }
            }        
        var prevMap = map
        var newMap = advanceStep(input: prevMap)
        while prevMap != newMap {
            prevMap = newMap
            newMap = advanceStep(input: prevMap)
        }
        let count = newMap.reduce(0) { total, array in
            total + array.reduce(0) {
                $0 + ($1 == 2 ? 1 : 0)
            }
        }
        return "\(count)"
    }

    static func part2(_ input: String) -> String {
        // 0: floor, 1: free, 2: occupied
        var map = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
            .compactMap { line in
                ".\(line).".compactMap { char -> Int in
                    return char == "." ? 0 : 1
                }
            }
        
        let limit = Vec(r: map.count, c: map[0].count)
        var changed = true
        while changed {
            changed = false
            var newMap = map
            for row in 1..<map.count-1 {
                for col in 1..<map[0].count-1 {
                    let curVal = map[row][col]
                    if curVal == 0 {
                        continue
                    }
                    
                    var occupied = 0
                    deltaLoop: for delta in deltas {
                        var adj: Vec = [row, col]
                        while true {
                            adj = adj + delta
                            if isInBounds(adj, limit) {
                                if map[adj.r][adj.c] == 2 {
                                    occupied += 1
                                    break
                                } else if map[adj.r][adj.c] == 1 {
                                    break
                                }
                            } else {
                                continue deltaLoop
                            }
                        }
                    }
                    if curVal == 1 && occupied == 0 {
                        newMap[row][col] = 2
                        changed = true
                    } else if curVal == 2 && occupied >= 5 {
                        newMap[row][col] = 1
                        changed = true
                    }
                }
            }
            map = newMap
        }
        var count = 0
        for row in map {
            for seat in row {
                count += seat == 2 ? 1 : 0
            }
        }
        return "\(count)"
    }
}
