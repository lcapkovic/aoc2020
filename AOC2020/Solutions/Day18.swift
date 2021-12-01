import Foundation

class Day18: Day {
    static func part1(_ input: String) -> String {
        let newInput = input.replacingOccurrences(of: "(", with: "( ").replacingOccurrences(of: ")", with: " )")
        let expressions = newInput.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n").map { $0.components(separatedBy: " ") }

        var sum = 0
        for e in expressions {
            var ix = 0
            sum += evalExpression1(e, &ix)
        }

        return "\(sum)"
    }

    static func part2(_ input: String) -> String {
        let newInput = input.replacingOccurrences(of: "(", with: "( ").replacingOccurrences(of: ")", with: " )")
        let expressions = newInput.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n").map { ["("] + $0.components(separatedBy: " ") + [")"] }

        var sum = 0
        for e in expressions {
            sum += evalExpression2(e)
        }
        return "\(sum)"
    }

    static func evalExpression1(_ expr: [String], _ ix: inout Int) -> Int {
        var val = 0
        var op = 0
        while ix < expr.count {
            let c = expr[ix]
            if let x = Int(c) {
                if op == 0 {
                    val += x
                } else {
                    val *= x
                }
            } else if c == "*" {
                op = 1
            } else if c == "+" {
                op = 0
            } else if c == "(" {
                ix += 1
                if op == 0 {
                    val += evalExpression1(expr, &ix)
                } else {
                    val *= evalExpression1(expr, &ix)
                }
            } else if c == ")" {
                break
            }
            ix += 1
        }
        return val
    }

    static func evalExpression2(_ e: [String]) -> Int {
        // -1: +   -2: *   -3: (
        var stack = [Int]()
        for c in e {
            if let x = Int(c) {
                let top = stack.last!
                if top == -2 || top == -3 {
                    stack.append(x)
                } else if top == -1 {
                    stack.removeLast()
                    let left = stack.removeLast()
                    stack.append(left + x)
                }
            } else if c == ")" {
                // Eval until (
                var prod = 1
                while let top = stack.popLast(), top != -3 {
                    if top >= 0 {
                        prod *= top
                    }
                }

                // Peek if we should add to a value that was "waiting" for the () eval
                if let top = stack.last, top == -1 {
                    stack.removeLast()
                    let left = stack.removeLast()
                    stack.append(left + prod)
                } else {
                    stack.append(prod)
                }

            } else if c == "+" {
                stack.append(-1)
            } else if c == "*" {
                stack.append(-2)
            } else if c == "(" {
                stack.append(-3)
            }

        }

        return stack.last!
    }


}
