import Foundation

class Day14: Day {
    static func part1(_ input: String) -> String {
        let lines = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")

        var zeroMask: Int = 0
        var oneMask: Int = 0
        var memory = [Int:Int]()
        for line in lines {
            let tokens = line.components(separatedBy: " = ")
            if tokens[0] == "mask" {
                let bin = String(tokens[1].map {
                    return $0 == "X" ? "0" : $0
                })
                let bin2 = String(tokens[1].map {
                    return $0 == "X" ? "1" : $0
                })
                oneMask = Int(bin, radix: 2)!
                zeroMask = Int(bin2, radix: 2)!
            } else {
                let memLoc = Int(tokens[0].components(separatedBy: ["[","]"])[1])!
                let val = Int(tokens[1])!
                memory[memLoc] = val | oneMask & zeroMask
            }
        }
        
        var prod = 0
        for val in memory.values {
            prod += val
        }
        return "\(prod)"
    }
    
    static func genCombos(_ n: Int) -> [String] {
        let N = Int(pow(2.0,Double(n)))
        var nums = [String]()
        
        for i in 0..<N {
            var num = String(i, radix: 2)
            if num.count < n {
                num = repeatElement("0", count: n-num.count) + num
            }
            nums.append(num)
        }
        return nums
    }
    
    static func genLocs(_ mask: String) -> [Int] {
        let N = mask.reduce(0) {
            $0 + ($1 == "X" ? 1 : 0)
        }
        let combos = genCombos(N)
        var locs = [Int]()
        for combo in combos {
            var comboIx = 0
            let arrCombo = Array(combo)
            var newMask = Array(mask)
            for ix in 0..<newMask.count {
                if newMask[ix] == "X" {
                    newMask[ix] = arrCombo[comboIx]
                    comboIx += 1
                }
            }
            locs.append(Int(String(newMask), radix: 2)!)
        }
        return locs
    }


    static func part2(_ input: String) -> String {
        let lines = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
        
        var memory = [Int:Int]()
        var curMask = [String.Element]()
        for line in lines {
            let tokens = line.components(separatedBy: " = ")
            if tokens[0] == "mask" {
                curMask = Array(tokens[1])
            } else {
                let memLoc = Int(tokens[0].components(separatedBy: ["[","]"])[1])!
                var memLocBin = Array(String(memLoc, radix: 2))
                if memLocBin.count < curMask.count {
                    memLocBin = repeatElement("0", count: curMask.count-memLocBin.count) + memLocBin
                }
                
                var floatingLoc = curMask
                for ix in 0..<curMask.count {
                    if curMask[ix] == "0" {
                        floatingLoc[ix] = memLocBin[ix]
                    }
                }
                
                let val = Int(tokens[1])!
                let locs = genLocs(String(floatingLoc))
                for loc in locs {
                    memory[loc] = val
                }
            }
        }

        var sum = 0
        for val in memory.values {
            sum += val
        }
        return "\(sum)"
    }
}
