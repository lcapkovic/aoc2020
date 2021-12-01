import Foundation

class Day21: Day {
    static func part1(_ input: String) -> String {
        let lines = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")

        var alMap = [String: Set<String>]()
        var allIngredients = Set<String>()
        var ingredientLists = [[String]]()
        for line in lines {
            let lr = line.components(separatedBy: " (contains ")
            let ingredients = lr[0].components(separatedBy: " ")
            let allergens = lr[1].dropLast().components(separatedBy: ", ")
            
            ingredientLists.append(ingredients)
            allIngredients.formUnion(ingredients)
            for allergen in allergens {
                if alMap[allergen] == nil {
                    alMap[allergen] = Set(ingredients)
                } else {
                    alMap[allergen]?.formIntersection(ingredients)
                }
            }
        }
        let possibleAllergens = alMap.values.reduce(into: Set<String>()) { $0.formUnion($1) }
        let notAllergens = allIngredients.subtracting(possibleAllergens)
        print("Part 1: \(ingredientLists.joined().filter({ notAllergens.contains($0)}).count)")
        
        var doneCount = 0
        var done = Set<String>()
        while done.count < alMap.count {
            var copy = alMap
            for key in alMap.keys {
                if alMap[key]!.count == 1 && !done.contains(key) {
                    for otherKey in alMap.keys {
                        if key == otherKey {
                            continue
                        }
                        copy[otherKey]?.remove((alMap[key]?.first!)!)
                    }
                    doneCount += 1
                    done.insert(key)
                }
            }
            alMap = copy
        }
        let sorted = alMap.sorted(by: { $0.key < $1.key }).map { $0.value.first! }
        print("Part 2: \(sorted.joined(separator: ","))")
        return ""
    }

    static func part2(_ input: String) -> String {

        return ""
    }
}
