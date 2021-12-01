import Foundation

class Day8: Day {
    static func part1(_ input: String) -> String {
        let program = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
        
        var visited = [Bool](repeating: false, count: program.count)
        var ip = 0
        var acc = 0
        while true {
            if visited[ip] {
                break
            }
            visited[ip] = true
            
            let line = program[ip].split(separator: " ")
            let ins = line[0]
            let val = Int(line[1])!
            
            if ins == "acc" {
                acc += val
            } else if ins == "jmp" {
                ip += val - 1
            }
            ip += 1
        }
        return "\(acc)"
    }
    
    static func part2(_ input: String) -> String {
        let program = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
        var terminated = false
        var flipped = 0
        var acc = 0
        
        while !terminated {
            // Find the next instruction flip
            while !["jmp", "nop"].contains(program[flipped].prefix(3)) { flipped += 1 }

            // Run the modified program
            var visited = [Bool](repeating: false, count: program.count)
            var ip = 0
            acc = 0
            
            while true {
                if ip >= program.count {
                    terminated = true
                    break
                }
                
                if visited[ip] {
                    break
                }
                visited[ip] = true
                let line = program[ip].split(separator: " ")
                let ins = line[0]
                let val = Int(line[1])!
                
                if ins == "acc" {
                    acc += val
                } else if ins == "jmp" && ip != flipped {
                    ip += val - 1
                } else if ins == "nop" && ip == flipped {
                    ip += val - 1
                }
                ip += 1
            }
            
            flipped += 1
        }

        return "\(acc)"
    }
}
