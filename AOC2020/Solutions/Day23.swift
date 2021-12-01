import Foundation

class Node {
    var next: Node!
    var value: Int!
}

class Day23: Day {
    static func part1(_ input: String) -> String {
        let numStr = input.trimmingCharacters(in: .whitespacesAndNewlines)
        var circle = Array(numStr).compactMap { Int(String($0)) }
        var curIx = 0
        
        for _ in 0..<100 {
            var hand = [Int]()
            let curLabel = circle[curIx]
            for _ in 1...3 {
                let ix = (curIx + 1) % circle.count
                
                hand.append(circle.remove(at: ix))
                if ix < curIx {
                    curIx -= 1
                }
            }
            var destCup = curLabel
            repeat {
                destCup -= 1
                if destCup == 0 {
                    destCup = circle.max()!
                }
            } while hand.contains(destCup)
            let destCupIx = (circle.firstIndex(of: destCup)! + 1) % circle.count
            circle.insert(contentsOf: hand, at: destCupIx)
            curIx = (circle.firstIndex(of: curLabel)! + 1) % circle.count
        }
        curIx = (circle.firstIndex(of: 1)! + 1) % circle.count
        var result = [Int]()
        for _ in 0..<circle.count-1 {
            result.append(circle[curIx])
            curIx = (curIx + 1) % circle.count
        }

        return "\(result.compactMap { String($0) }.joined())"
    }

    static func part2(_ input: String) -> String {
        let numStr = input.trimmingCharacters(in: .whitespacesAndNewlines)
        let initialNumbers = Array(numStr).compactMap { Int(String($0)) }
        let N = 1000000
        var circleStore = [Node]()
        for _ in 0...N {
            circleStore.append(Node())
        }
        for ix in 0..<initialNumbers.count-1 {
            circleStore[initialNumbers[ix]].next = circleStore[initialNumbers[ix+1]]
            circleStore[initialNumbers[ix]].value = initialNumbers[ix]
        }
        let maxNum = initialNumbers.max()!
        circleStore[initialNumbers.last!].next = circleStore[maxNum+1]
        circleStore[initialNumbers.last!].value = initialNumbers.last!
        for i in (maxNum+1)..<N {
            circleStore[i].next = circleStore[i+1]
            circleStore[i].value = i
        }
        circleStore[N].next = circleStore[initialNumbers.first!]
        circleStore[N].value = N
        
        
        let iters = 10000000
        var currentCupNode = circleStore[initialNumbers.first!]
        for _ in 0..<iters {
            let currentLabel = currentCupNode.value!
            let hand: [Node] = [currentCupNode.next, currentCupNode.next.next, currentCupNode.next.next.next]
            let handValues = [hand[0].value, hand[1].value, hand[2].value]
            currentCupNode.next = hand[2].next
            
            var destLabel = currentLabel
            repeat {
                destLabel -= 1
                if destLabel == 0 {
                    destLabel = N
                }
            } while handValues.contains(destLabel)
            let destCup = circleStore[destLabel]
            let destNext = destCup.next
            
            destCup.next = hand[0]
            hand[2].next = destNext
            currentCupNode = currentCupNode.next
        }
        let val1 = circleStore[1].next.value!
        let val2 = circleStore[1].next.next.value!
        
        return "\(val1*val2)"
    }
}
