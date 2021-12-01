import Foundation

class Day24: Day {
    static func part1(_ input: String) -> String {
        let lines = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
        
        let N = 1000
        var map = [[Bool]](repeating: [Bool](repeating: false, count: N), count: N)
        
        
        for line in lines {
            var pos = Vec(r: N/2, c: N/2)
            let cmdArray = Array(line)
            var ix = 0
            while ix < cmdArray.count {
                if cmdArray[ix] == "w" {
                    pos.c = pos.c - 1
                } else if cmdArray[ix] == "e" {
                    pos.c = pos.c + 1
                } else if cmdArray[ix] == "n" {
                    pos.r = pos.r-1
                    if cmdArray[ix+1] == "w" {
                        pos.c = pos.c-1
                    }
                    ix += 1
                } else if cmdArray[ix] == "s" {
                    pos.r = pos.r+1
                    if cmdArray[ix+1] == "e" {
                        pos.c = pos.c+1
                    }
                    ix += 1
                }
                ix += 1
            }
            map[pos.r][pos.c].toggle()
        }
        
        var blackCount = 0
        for row in map {
            for tile in row {
                if tile {
                    blackCount += 1
                }
            }
        }
        return "\(blackCount)"
    }

    static func part2(_ input: String) -> String {
        let lines = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
        
        let N = 1000
        var map = [[Bool]](repeating: [Bool](repeating: false, count: N), count: N)
        
        
        for line in lines {
            var pos = Vec(r: N/2, c: N/2)
            let cmdArray = Array(line)
            var ix = 0
            while ix < cmdArray.count {
                if cmdArray[ix] == "w" {
                    pos.c = pos.c - 1
                } else if cmdArray[ix] == "e" {
                    pos.c = pos.c + 1
                } else if cmdArray[ix] == "n" {
                    pos.r = pos.r-1
                    if cmdArray[ix+1] == "w" {
                        pos.c = pos.c-1
                    }
                    ix += 1
                } else if cmdArray[ix] == "s" {
                    pos.r = pos.r+1
                    if cmdArray[ix+1] == "e" {
                        pos.c = pos.c+1
                    }
                    ix += 1
                }
                ix += 1
            }
            map[pos.r][pos.c].toggle()
        }
        let deltas: [Vec] = [[-1,-1],[-1,0],[0,-1],[0,1],[1,1], [1,0]]
        
        for _ in 0..<100 {
            var newMap = map
            for row in 1..<map.count-1 {
                for col in 1..<map[row].count-1 {
                    var adjBlack = 0
                    let pos = Vec(r: row, c: col)
                    let posVal = map[pos.r][pos.c]
                    for delta in deltas {
                        let neigh = pos + delta
                        if map[neigh.r][neigh.c] {
                            adjBlack += 1
                        }
                    }
                    if (posVal && (adjBlack == 0 || adjBlack > 2)) ||
                        (!posVal && adjBlack == 2) {
                        newMap[pos.r][pos.c].toggle()
                    }
                }
            }
            map = newMap
        }

        var blackCount = 0
        for row in map {
            for tile in row {
                if tile {
                    blackCount += 1
                }
            }
        }
        
        return "\(blackCount)"
    }
}
