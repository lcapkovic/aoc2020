import Foundation

class Day17: Day {
    static func part1(_ input: String) -> String {
        let initialPlane = input.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n").compactMap {
            $0.split(separator: "\n").flatMap {
                $0.compactMap {
                    $0 == "#" ? 1 : 0
                }
            }
        }
        let n = 22
        var map = [[[Int]]](repeating: [[Int]](repeating: [Int](repeating: 0, count: n), count: n), count: n)
        
        for x in 7..<15 {
            for y in 7..<15 {
                map[x][y][11] = initialPlane[x-7][y-7]
            }
        }
        
        for _ in 0..<6 {
            simulateStep(map: &map)
        }
        
        let count = map.reduce(0) {$0 + $1.reduce(0) {$0 + $1.reduce(0) {$0 + $1}} }
        
        return "\(count)"
    }
    
    static func simulateStep(map: inout [[[Int]]]) {
        var mapCopy = map
        for x in 1..<map.count-1 {
            for y in 1..<map.count-1 {
                for z in 1..<map.count-1 {
                    let pos: Vec3 = [x,y,z]
                    let posVal = map[pos.x][pos.y][pos.z]
                    let active = neighbors(pos: pos, map: map).reduce(0) {
                        $0 + map[$1.x][$1.y][$1.z]
                    }
                    
                    if posVal == 0 && active == 3 {
                        mapCopy[pos.x][pos.y][pos.z] = 1
                    } else if posVal == 1 && !(active == 2 || active == 3) {
                        mapCopy[pos.x][pos.y][pos.z] = 0
                    }
                }
            }
        }
        map = mapCopy
    }
    
    static func neighbors(pos: Vec3, map: [[[Int]]]) -> [Vec3] {
        let deltas: [Vec3] = [[-1,-1,0], [-1,0,0], [-1,1,0], [0, -1, 0], [0, 1, 0], [1,-1,0], [1,0,0], [1,1,0],
                              [-1,-1,1], [-1,0,1], [-1,1,1], [0, -1, 1], [0, 1, 1], [1,-1,1], [1,0,1], [1,1,1],
                              [-1,-1,-1], [-1,0,-1], [-1,1,-1], [0, -1, -1], [0, 1, -1], [1,-1,-1], [1,0,-1], [1,1,-1],
                                [0,0,1], [0,0,-1]]
        
        return deltas.map {
            pos + $0
        }
    }
    
    /* ------ Part 2 --------*/
    
    static func gen4DDeltas(positions: inout [Vec4], cur: [Int]) {
        if cur.count == 4 {
            if cur != [0,0,0,0] {
                positions.append([cur[0],cur[1],cur[2],cur[3]])
            }
            return
        }
        
        gen4DDeltas(positions: &positions, cur: cur + [-1])
        gen4DDeltas(positions: &positions, cur: cur + [0])
        gen4DDeltas(positions: &positions, cur: cur + [1])
    }
    
    static func simulateSparseStep(active: inout Set<Vec4>, deltas: [Vec4]) {
        var newActive = Set<Vec4>()
        var visitedInactive = Set<Vec4>()
        
        for cube in active {
            var activeNeighbors = 0
            deltas.map {
                cube + $0
            }.forEach { neighbor in
                if active.contains(neighbor) {
                    activeNeighbors += 1
                } else {
                    visitedInactive.insert(neighbor)
                }
            }
            if activeNeighbors == 2 || activeNeighbors == 3 {
                newActive.insert(cube)
            }
        }
        
        for cube in visitedInactive {
            var activeNeighbors: Int
            if active.count < deltas.count {
                activeNeighbors = active.filter { cube.isAdjacent(to: $0) }.count
            } else {
                activeNeighbors = deltas.map {
                    cube + $0
                }.filter { active.contains($0) }.count
            }

            if activeNeighbors == 3 {
                newActive.insert(cube)
            }
        }
        active = newActive
    }
    
    static func part2(_ input: String) -> String {
        let initialPlane = input.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n").compactMap {
            $0.split(separator: "\n").flatMap {
                $0.compactMap {
                    $0 == "#" ? 1 : 0
                }
            }
        }
        
        var deltas = [Vec4]()
        gen4DDeltas(positions: &deltas, cur: [])
        
        var active = Set<Vec4>()
        for x in 0..<initialPlane.count {
            for y in 0..<initialPlane[0].count {
                if initialPlane[x][y] == 1 {
                    active.insert(Vec4(x: x, y: y, z: 0, w: 0))
                }
            }
        }
        
        let steps = 6
        for _ in 0..<steps {
            simulateSparseStep(active: &active, deltas: deltas)
        }
        return "\(active.count)"
    }
}
