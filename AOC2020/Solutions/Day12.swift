import Foundation

class Day12: Day {
    static func part1(_ input: String) -> String {
        let commands = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
        
        let headings: [Vec2] = [[1,0], [0,-1], [-1,0], [0,1]]
        var ship = Vec2(x: 0, y: 0)
        var heading = 0
        for command in commands {
            let dir = command.first!
            let val = Int(command.dropFirst())!
            
            if dir == "N" {
                ship.y += val
            } else if dir == "S" {
                ship.y -= val
            } else if dir == "E" {
                ship.x += val
            } else if dir == "W" {
                ship.x -= val
            } else if dir == "F" {
                let heading = headings[heading]
                ship.x += heading.x * val
                ship.y += heading.y * val
            } else if dir == "R" {
                let num = val/90
                heading = (heading + num) % 4
            } else if dir == "L" {
                let num = val/90
                heading = (((heading - num)) + 4) % 4
            }
        }
        
        return "\(abs(ship.x) + abs(ship.y))"
    }


    static func part2(_ input: String) -> String {
        let commands = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
        
        var waypoint = Vec2(x: 10, y: 1)
        var ship = Vec2(x: 0, y: 0)
        for command in commands {
            let dir = command.first!
            let val = Int(command.dropFirst())!
            
            if dir == "N" {
                waypoint.y += val
            } else if dir == "S" {
                waypoint.y -= val
            } else if dir == "E" {
                waypoint.x += val
            } else if dir == "W" {
                waypoint.x -= val
            } else if dir == "F" {
                ship.x += waypoint.x * val
                ship.y += waypoint.y * val
            } else if dir == "R" {
                let num = val/90
                for _ in 0..<num {
                    let oldW = waypoint
                    waypoint.x = oldW.y
                    waypoint.y = -oldW.x
                }
            } else if dir == "L" {
                let num = val/90
                for _ in 0..<num {
                    let oldW = waypoint
                    waypoint.x = -oldW.y
                    waypoint.y = oldW.x
                }
            }
        }
        return  "\(abs(ship.x) + abs(ship.y))"
    }
}
