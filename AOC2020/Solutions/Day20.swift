import Foundation

enum NeighborDirection {
    case top
    case right
    case bottom
    case left
    case none
}

class Tile {
    var t: [Character]
    var r: [Character]
    var b: [Character]
    var l: [Character]
    var id: Int
    var content: [[Character]]?
    
    init(t: [Character], r: [Character], b: [Character], l: [Character], id: Int) {
        self.t = t
        self.r = r
        self.b = b
        self.l = l
        self.id = id
    }
    
    init(t: [Character], r: [Character], b: [Character], l: [Character], id: Int, neighbors: [Tile]) {
        self.t = t
        self.r = r
        self.b = b
        self.l = l
        self.id = id
        self.neighbors = neighbors
    }
    
    func rotate() {
        let temp = t
        t = l.reversed()
        l = b
        b = r.reversed()
        r = temp
        rot = (rot + 1) % 4
    }

    func flipHorizontal() {
        let temp = t
        t = b
        b = temp
        l = l.reversed()
        r = r.reversed()
        flip = (flip + 1) % 2
    }
    
    func transformedContent() -> [[Character]]? {
        guard let content = self.content else {
            return nil
        }
        var newContent = flip == 1 ? content.reversed() : content
        for _ in 0..<rot {
            newContent = rotate90(arr: newContent)
        }
        return newContent
    }
    
    func fits(_ tile: Tile) -> NeighborDirection {
        if t == tile.b {
            return .top
        } else if b == tile.t {
            return .bottom
        } else if r == tile.l {
            return .right
        } else if l == tile.r {
            return .left
        } else {
            return .none
        }
    }
    
    func setNeighbor(tile: Tile, dir: NeighborDirection) {
        switch dir {
        case .top:
            topN = tile
        case .right:
            rightN = tile
        case .bottom:
            bottomN = tile
        case .left:
            leftN = tile
        case .none:
            break
        }
        neighbors.append(tile)
        
    }
    
    var rot = 0
    var flip = 0
    var neighbors = [Tile]()
    
    var topN: Tile?
    var rightN: Tile?
    var bottomN: Tile?
    var leftN: Tile?
}
class Day20: Day {
    static let monster: [Vec] = [
        [1,0],
        [2,1],
        [2,4],
        [1,5],
        [1,6],
        [2,7],
        [2,10],
        [1,11],
        [1,12],
        [2,13],
        [2,16],
        [1,17],
        [0,18],
        [1,18],
        [1,19]
    ]
    
    static func part1(_ input: String) -> String {
        let tileStrings = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n\n")
        
        var tiles = [Tile]()
        for tileString in tileStrings {
            let lines = tileString.components(separatedBy: "\n")
            let id = Int(lines[0].components(separatedBy: [" ",":"])[1])!
            let t = Array(lines[1])
            let b = Array(lines[10])
            var l = [Character]()
            var r = [Character]()
            
            for ix in 1...10 {
                l.append(lines[ix].first!)
                r.append(lines[ix].last!)
            }
            let tile = Tile(t: t, r: r, b: b, l: l, id: id)
            tile.content = lines.dropFirst().map { Array($0) }
            tiles.append(tile)
        }

        var visited = [Tile]()
        fillNeighbors(for: tiles, from: tiles[0], visited: &visited)
        let prod = tiles.reduce(1) {
            $0 * ($1.neighbors.count == 2 ? $1.id : 1)
        }
        
        var topLeft: Tile?
        for tile in tiles {
            if tile.neighbors.count == 2 {
                if tile.rightN != nil && tile.bottomN != nil {
                    topLeft = tile
                    break
                }
            }
        }
        var map = [[Tile?]](repeating: [Tile?](repeating: nil, count: 12), count: 12)
        fillMap(start: topLeft!, loc: Vec(r: 0, c: 0), map: &map)
        
        let fullMap = buildFullMap(map)
        let hashCount = fullMap.reduce(0) {
            $0 + $1.reduce(0) {$0 + ($1 == "#" ? 1 : 0)}
        }

        var monsterCount = 0
        var rotatedMap = fullMap
        for _ in 0..<4 {
            monsterCount = max(monsterCount, findMonsters(in: rotatedMap))
            rotatedMap = rotate90(arr: rotatedMap)
        }
        rotatedMap = rotatedMap.reversed()
        for _ in 0..<4 {
            monsterCount = max(monsterCount, findMonsters(in: rotatedMap))
            rotatedMap = rotate90(arr: rotatedMap)
        }
        print("Roughness: \(hashCount - monsterCount * monster.count)")
        return "\(prod)"
    }
    
    static func fillMap(start tile: Tile, loc: Vec, map: inout [[Tile?]]) {
        if map[loc.r][loc.c] != nil {
            return
        }
        map[loc.r][loc.c] = tile
        
        if let top = tile.topN {
            fillMap(start: top, loc: Vec(r:loc.r-1,c: loc.c), map: &map)
        }
        if let right = tile.rightN {
            fillMap(start: right, loc: Vec(r:loc.r, c: loc.c+1), map: &map)
        }
        if let bottom = tile.bottomN {
            fillMap(start: bottom, loc: Vec(r:loc.r+1, c:loc.c), map: &map)
        }
        if let left = tile.leftN {
            fillMap(start: left, loc: Vec(r:loc.r, c:loc.c-1), map: &map)
        }
    }
    
    static func reverseDirection(dir: NeighborDirection) -> NeighborDirection {
        switch dir {
        case .top:
            return .bottom
        case .right:
            return .left
        case .bottom:
            return .top
        case .left:
            return .right
        case .none:
            return .none
        }
    }
    
    static func fillNeighbors(for tiles: [Tile], from tile1: Tile, visited: inout [Tile]) {
        if visited.contains(where: { $0.id == tile1.id }) {
            return
        }
        visited.append(tile1)
        tile2Loop: for tile2 in tiles {
            if tile1.id == tile2.id {
                continue
            }
            
            if tile2.neighbors.contains(where: { $0.id == tile1.id }) {
                continue
            }
            for _ in 0..<4 {
                let neighborDirection = tile1.fits(tile2)
                if neighborDirection != .none {
                    tile1.setNeighbor(tile: tile2, dir: neighborDirection)
                    tile2.setNeighbor(tile: tile1, dir: reverseDirection(dir: neighborDirection))
                    continue tile2Loop
                } else {
                    tile2.rotate()
                }
            }
            tile2.flipHorizontal()
            for _ in 0..<4 {
                let neighborDirection = tile1.fits(tile2)
                if neighborDirection != .none {
                    tile1.setNeighbor(tile: tile2, dir: neighborDirection)
                    tile2.setNeighbor(tile: tile1, dir: reverseDirection(dir: neighborDirection))
                    continue tile2Loop
                } else {
                    tile2.rotate()
                }
            }
            tile2.flipHorizontal()
        }
        for neighbor in tile1.neighbors {
            fillNeighbors(for: tiles, from: neighbor, visited: &visited)
        }
    }
    
    static func buildFullMap(_ map: [[Tile?]]) -> [[Character]] {
        var tileContents = [[[[Character]]]]()
        for tileRow in map {
            tileContents.append(tileRow.reduce(into: [[[Character]]](), { (result, tile) in
                result.append(tile!.transformedContent()!)
            }))
        }
        let tileN = map[0][0]!.transformedContent()!.count
        var finalMap = [[Character]]()
        
        for tileRow in tileContents {
            for row in 1..<tileN-1 {
                finalMap.append(tileRow.reduce(into: [Character](), { (result, tile) in
                    result = result + tile[row][1..<tileN-1]
                }))
            }
        }

        return Array(finalMap)
    }
    
    static func printFullMap(map: [[Character]]) {
        for row in map {
            for c in row {
                print(c, terminator: "")
            }
            print()
        }
    }
    
    static func findMonsters(in map:[[Character]]) -> Int {
        var monsterCount = 0
        for originRow in 0..<map.count-3 {

            for originCol in 0..<map[0].count-20 {
                var hasMonster = true
                let origin: Vec = [originRow, originCol]
                for bodyPart in monster {
                    let loc = origin + bodyPart
                    if map[loc.r][loc.c] != "#" {
                        hasMonster = false
                        break
                    }
                }
                if hasMonster {
                    monsterCount += 1
                }
            }
        }
        return monsterCount
    }
    
    static func part2(_ input: String) -> String {
        return "Both parts calculated in part 1 ^^^"
    }
}
