import Foundation

struct Winner {
    let playerID: Int
    let cards: [Int]
}
class Day22: Day {
    static func part1(_ input: String) -> String {
        let p1p2 = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n\n")
        var cardsP1 = p1p2[0].components(separatedBy: "\n").dropFirst().compactMap { Int($0) }
        var cardsP2 = p1p2[1].components(separatedBy: "\n").dropFirst().compactMap { Int($0) }
        
        while cardsP1.count > 0 && cardsP2.count > 0 {
            if cardsP1.first! > cardsP2.first! {
                let c1 = cardsP1.removeFirst()
                let c2 = cardsP2.removeFirst()
                cardsP1.append(c1)
                cardsP1.append(c2)
            } else {
                let c1 = cardsP1.removeFirst()
                let c2 = cardsP2.removeFirst()
                cardsP2.append(c2)
                cardsP2.append(c1)
            }
        }
        var sum = 0
        let winner = cardsP1.count == 0 ? cardsP2 : cardsP1
        for (ix, c) in winner.enumerated() {
            sum += c * (winner.count - ix)
        }
        return "\(sum)"
    }

    static func part2(_ input: String) -> String {
        let p1p2 = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n\n")
        let p1Cards = p1p2[0].components(separatedBy: "\n").dropFirst().compactMap { Int($0) }
        let p2Cards = p1p2[1].components(separatedBy: "\n").dropFirst().compactMap { Int($0) }
        
        let winnerCards = recursiveCombat(p1: p1Cards, p2: p2Cards).cards
        var sum = 0
        for (ix, c) in winnerCards.enumerated() {
            sum += c * (winnerCards.count - ix)
        }
        return "\(sum)"
    }
    
    static func recursiveCombat(p1: [Int], p2: [Int]) -> Winner {
        var seenStates = Set<Int>()
        var p1Cards = p1
        var p2Cards = p2
        while p1Cards.count > 0 && p2Cards.count > 0 {
            if seenStates.contains(p1Cards.hashValue) || seenStates.contains(p2Cards.hashValue) {
                return Winner(playerID: 1, cards: p1Cards)
            }
            seenStates.insert(p1Cards.hashValue)
            seenStates.insert(p2Cards.hashValue)
            
            let t1 = p1Cards.removeFirst()
            let t2 = p2Cards.removeFirst()
            
            var p1Wins = false
            if p1Cards.count >= t1 && p2Cards.count >= t2 {
                let winner = recursiveCombat(p1: Array(p1Cards.prefix(t1)), p2: Array(p2Cards.prefix(t2)))
                p1Wins = winner.playerID == 1
            } else {
                if t1 > t2 {
                    p1Wins = true
                }
            }
            
            if p1Wins {
                p1Cards.append(t1)
                p1Cards.append(t2)
            } else {
                p2Cards.append(t2)
                p2Cards.append(t1)
            }
        }
        if p1Cards.count == 0 {
            return Winner(playerID: 2, cards: p2Cards)
        } else {
            return Winner(playerID: 1, cards: p1Cards)
        }
    }
}
