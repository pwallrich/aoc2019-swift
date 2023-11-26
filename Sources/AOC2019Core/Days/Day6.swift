import Foundation

class Day6: Day {
    var day: Int { 6 }
    let input: [String.SubSequence]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L\nK)YOU\nI)SAN"
        } else {
            inputString = try InputGetter.getInput(for: 6, part: .first)
        }
        self.input = inputString.split(separator: "\n")
    }

    func runPart1() throws {
        var orbits: [String.SubSequence: [String.SubSequence]] = [:]
        for row in input {
            let split = row.split(separator: ")")
            orbits[split[0], default: []].append(split[1])
        }
        print(orbits)
        var count = 0
        for orbit in orbits {
            let res = orbits.countOrbits(startingAt: orbit.key)
            count += res
        }
        print(count)
    }

    func runPart2() throws {
        var orbits: [String.SubSequence: [String.SubSequence]] = [:]
        for row in input {
            let split = row.split(separator: ")")
            orbits[split[0], default: []].append(split[1])
        }

        let start = orbits.first { $0.value.contains("YOU") }!.key

        var visited: Set<String.SubSequence> = [start, "YOU"]
        var possibleMoves: [String.SubSequence] = orbits[start]?.filter { $0 != "YOU" } ?? []
        possibleMoves += orbits.filter { $0.value.contains(start) }.keys.filter { !visited.contains($0) }

        var moves = 0
        while !possibleMoves.contains("SAN") {
            print("At move: \(moves)", possibleMoves.count)
            var temp: [String.SubSequence] = []
            for move in possibleMoves {
                visited.insert(move)
                let next = orbits.filter { $0.value.contains(move) }.keys.filter { !visited.contains($0) }
                temp += next
                let others = orbits[move]?.filter { !visited.contains($0) } ?? []
                temp += others
            }
            
            possibleMoves = temp
            moves += 1
        }
        print(moves)
    }
}

extension Dictionary where Key == String.SubSequence, Value == Array<String.SubSequence> {
    func countOrbits(startingAt: String.SubSequence) -> Int {
        guard let values = self[startingAt] else {
            return 0
        }
        var count = values.count

        for item in values {
            count += countOrbits(startingAt: item)
        }
        return count
    }
}
