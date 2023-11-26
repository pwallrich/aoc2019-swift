import Foundation

class Day3: Day {
    var day: Int { 3 }
    let input: String

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """
R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83
"""
        } else {
            inputString = try InputGetter.getInput(for: 1, part: .first)
        }
        self.input = inputString
    }

    func runPart1() throws {
        var cables: [Set<Point2D>] = []
        for row in input.split(separator: "\n") {
            var line: Set<Point2D> = []
            var start = Point2D(x: 0, y: 0)
            let instructions = row.split(separator: ",")
            for instruction in instructions {
                let dir = instruction.first!
                let value = Int(String(instruction.dropFirst()))!
                for _ in 0..<value {
                    switch dir {
                    case "R":
                        start = Point2D(x: start.x + 1, y: start.y)
                    case "D":
                        start = Point2D(x: start.x, y: start.y - 1)
                    case "U":
                        start = Point2D(x: start.x, y: start.y + 1)
                    case "L":
                        start = Point2D(x: start.x - 1, y: start.y)
                    default:
                        fatalError()
                    }
                    line.insert(start);
                }
            }
            cables.append(line)
        }
        
        let first = cables[0]
        let second = cables[1]

        let res = first.filter { second.contains($0) }.map { $0.manhattan(to: Point2D(x: 0, y:0))}.min()!
        print(res)

    }

    func runPart2() throws {
        var cables: [Set<Point2D>] = []
        for row in input.split(separator: "\n") {
            var line: Set<Point2D> = []
            var start = Point2D(x: 0, y: 0)
            let instructions = row.split(separator: ",")
            for instruction in instructions {
                let dir = instruction.first!
                let value = Int(String(instruction.dropFirst()))!
                for _ in 0..<value {
                    switch dir {
                    case "R":
                        start = Point2D(x: start.x + 1, y: start.y)
                    case "D":
                        start = Point2D(x: start.x, y: start.y - 1)
                    case "U":
                        start = Point2D(x: start.x, y: start.y + 1)
                    case "L":
                        start = Point2D(x: start.x - 1, y: start.y)
                    default:
                        fatalError()
                    }
                    line.insert(start);
                }
            }
            cables.append(line)
        }
        
        let first = cables[0]
        let second = cables[1]
        let intersections = first.filter { second.contains($0) }
        var stepsForEach: [Point2D: Int] = [:]
        for row in input.split(separator: "\n") {
            var count = 0
            var start = Point2D(x: 0, y: 0)
            let instructions = row.split(separator: ",")
            for instruction in instructions {
                let dir = instruction.first!
                let value = Int(String(instruction.dropFirst()))!
                for _ in 0..<value {
                    count += 1
                    switch dir {
                    case "R":
                        start = Point2D(x: start.x + 1, y: start.y)
                    case "D":
                        start = Point2D(x: start.x, y: start.y - 1)
                    case "U":
                        start = Point2D(x: start.x, y: start.y + 1)
                    case "L":
                        start = Point2D(x: start.x - 1, y: start.y)
                    default:
                        fatalError()
                    }
                    if intersections.contains(start) {
                        stepsForEach[start, default: 0] += count
                    }
                }
            }
        }
        print(stepsForEach.values.min()!)
    }
}

struct Point2D: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int

    func manhattan(to other: Point2D) -> Int {
        abs(x - other.x) + abs(y - other.y)
    }

    var description: String {
        "(\(x), \(y))"
    }
}
