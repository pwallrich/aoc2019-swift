import Foundation

class Day24: Day {
    var day: Int { 24 }
    let input: [Character]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """
....#
#..#.
#..##
..#..
#....
"""
        } else {
            inputString = try InputGetter.getInput(for: 24, part: .first)
        }
        self.input = inputString.filter { $0 != "\n" }
    }

    var seen: Set<String> = []

    func adjIndices(at idx: Int) -> [Int] {
        var res: [Int] = []
        // top
        if idx >= 5 {
            res.append(-5)
        }
        // right
        if idx % 5 != 4 {
            res.append(1)
        }
        // down
        if idx < 20 {
            res.append(5)
        }
        // left
        if idx % 5 != 0 {
            res.append(-1)
        }
        return res
    }

    func runPart1() throws {
        let count = 5
        var curr = input
        var i = 0
        while !seen.contains(String(curr)) {
            seen.insert(String(curr))
            var next: [Character] = []
            for (idx, char) in curr.enumerated() {
                // down is plus count, up is minus count
                if char == "#" {
                    var adjCount = 0
                    for offset in adjIndices(at: idx) {
                        adjCount += curr[idx + offset] == "#" ? 1 : 0
                    }
                    next.append(adjCount == 1 ? "#" : ".")
                } else {
                    var adjCount = 0
                    for offset in adjIndices(at: idx) {
                        adjCount += curr[idx + offset] == "#" ? 1 : 0
                    }
                    next.append(adjCount == 1 || adjCount == 2 ? "#" : ".")
                }
            }
            i += 1
            curr = next
            for (idx, char) in curr.enumerated() {
                if idx % 5 == 0 {
                    print()
                }
                print(char, terminator: "")
            }
            print()
        }
        print(i)
        var res = 0
        var multi = 1
        for (idx, char) in curr.enumerated() {
            if char == "#" {
                res += multi
            }
            multi *= 2
        }
        print(res)
    }

    func getOuterAdj(point: Point2D, toMap: Point2D) -> Point2D {
        if toMap.y < 0 {
            return .init(x: 2, y: 1)
        } else if toMap.x < 0 {
            return .init(x: 1, y: 2)
        } else if toMap.x >= 5 {
            return .init(x: 3, y: 2)
        } else if toMap.y >= 5 {
            return .init(x: 2, y: 3)
        }
        fatalError()
    }

    func getInnerAdj(at point: Point2D) -> [Point2D] {
        if point.y == 1 {
            return (0..<5).map { Point2D(x: $0, y: 0) }
        }
        if point.y == 3 {
            return (0..<5).map { Point2D(x: $0, y: 4) }
        }
        if point.x == 1 {
            return (0..<5).map { Point2D(x: 0, y: $0) }
        }
        if point.x == 3 {
            return (0..<5).map { Point2D(x: 4, y: $0) }
        }
        fatalError()
    }

    func runPart2() throws {
        var grids: [Int: Set<Point2D>] = [:]

        for (idx, char) in input.enumerated() where char == "#" {
            let point = Point2D(x: idx % 5, y: idx / 5)
            grids[0, default: []].insert(point)
        }
        grids[0]!.prettyPrintDay24(xRange: 0...4, yRange: 0...4)

        func isNormalIdx(point: Point2D) -> Bool {
            0..<5 ~= point.x && 0..<5 ~= point.y && point != Point2D(x: 2, y: 2)
        }

//        let untouchedPoints: Set<Point2D> = [Point2D(x: 1, y: 1), Point2D(x: 3, y: 1), Point2D(x: 1, y: 3), Point2D(x: 3, y: 3)]
        for i in 0..<200 {
            print("iteration: \(i)")
            var next: [Int: Set<Point2D>] = [:]
            var adjPoints: [Int: [Point2D: Int]] = [:]
            for (gIdx, grid) in grids{
                for point in grid {
                    // check if dead or not
                    var adjCount = 0
                    for adj in point.adjacentPoints() {
                        if isNormalIdx(point: adj) {
                            // normal handling
                            adjCount += (grids[gIdx]?.contains(adj) ?? false) ? 1 : 0
                            adjPoints[gIdx, default: [:]][adj, default: 0] += 1

                        } else if adj == Point2D(x: 2, y: 2) {
                            // inner grid
                            let innerAdj = getInnerAdj(at: point)
                            for adj in innerAdj {
                                adjCount += (grids[gIdx + 1]?.contains(adj) ?? false) ? 1 : 0
                                adjPoints[gIdx + 1, default: [:]][adj, default: 0] += 1
                            }
                        } else {
//                            assert(adj.x == 0 || adj.y == 0 || adj.x == 4 || adj.y == 4)

                            let outerAdj = getOuterAdj(point: point, toMap: adj)
                            adjCount += (grids[gIdx - 1]?.contains(outerAdj) ?? false) ? 1 : 0
                            adjPoints[gIdx - 1, default: [:]][outerAdj, default: 0] += 1
//                            print("outer: \(point) \(adj) \(outerAdj)")
                        }
                    }
                    if adjCount == 1 {
                        next[gIdx, default: []].insert(point)
                    }
                }
            }
            for (idx, grid) in adjPoints {
                for point in grid {
                    guard (point.value == 1 || point.value == 2) else { continue }
                    if grids[idx]?.contains(point.key) ?? false {
                        continue
                    }
                    next[idx, default: []].insert(point.key)
                }
            }
            grids = next
        }
        let res = grids.reduce(0) { $0 + $1.value.count }
        print(res)
    }
}

extension Set where Element == Point2D {
    func prettyPrintDay24(xRange: ClosedRange<Int>? = nil, yRange: ClosedRange<Int>? = nil) {
        let minX = xRange?.lowerBound ?? self.map(\.x).min()!
        let maxX = xRange?.upperBound ?? self.map(\.x).max()!
        let minY = yRange?.lowerBound ?? self.map(\.y).min()!
        let maxY = yRange?.upperBound ?? self.map(\.y).max()!

        for y in minY...maxY {
            for x in minX...maxX {
                print(self.contains(.init(x: x, y: y)) ? "#" : ".", terminator: "")
            }
            print()
        }
    }
}
