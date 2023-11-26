import Foundation

class Day15: Day {
    var day: Int { 15 }
    let input: [Int]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "4,4,4,4,3,3,3,3"
        } else {
            inputString = try InputGetter.getInput(for: 15, part: .first)
        }
        self.input = inputString
            .split(separator: ",")
            .map { Int($0)! }
    }

    func runPart1() throws {
        func turnRight(curr: Int) -> Int {
            switch curr {
            case 1: return 4
            case 2: return 3
            case 3: return 1
            case 4: return 2
            default: fatalError()
            }
        }
        func nextPositon(current: Point2D, direction: Int) -> Point2D {
            switch direction {
            case 1: Point2D(x: current.x, y: current.y + 1)
            case 2: Point2D(x: current.x, y: current.y - 1)
            case 3: Point2D(x: current.x - 1, y: current.y)
            case 4: Point2D(x: current.x + 1, y: current.y)
            default: fatalError()
            }
        }
        let program = IntcodeComputer(program: input)

        var grid: [Point2D: Int] = [:]
        var iter = 0

        var next: [(program: IntcodeComputer, point: Point2D)] = [(program, Point2D(x: 0, y: 0))]
        while !next.isEmpty {
            var temp: [(program: IntcodeComputer, point: Point2D)] = []
            for step in next {
                for direction in [1, 2, 3, 4] {
                    let nextPos = nextPositon(current: step.point, direction: direction)
                    let program = step.program.copy()
                    let res = program.run {
                        direction
                    }
                    if grid[nextPos] != nil {
                        continue
                    }
                    switch res {
                    case .exitCode: fatalError()
                    case let .output(output: output) where output == 0:
                        grid[nextPos] = 0
                        continue
                    case let .output(output: output) where output == 1:
                        grid[nextPos] = 1
                    case let .output(output: output) where output == 2:
                        grid[nextPos] = 2
                    case .output: fatalError()
                    }
                    temp.append((program.copy(), nextPos))
                }
            }
            next = temp
            iter += 1
        }
        grid.prettyPrintDay15()
        // find shortestPath
        var i = 0
        var states: [(Point2D, [Point2D])] = [(Point2D(x:0, y:0), [Point2D(x:0, y:0)])]
        var seen: Set<Point2D> = [states[0].0]
        while true {
            print("iteration: \(i)", states.count)
            var next: [(Point2D, [Point2D])] = []
            for state in states {
                for offset in [Point2D(x: 0, y: 1), Point2D(x: 0, y: -1), Point2D(x: 1, y: 0), Point2D(x: -1, y: 0)] {
                    let nextPos = Point2D(x: state.0.x + offset.x, y: state.0.y + offset.y)
                    if state.1.contains(nextPos) {
                        continue
                    }
                    if seen.contains(nextPos) {
                        continue
                    }
                    seen.insert(nextPos)
                    if grid[nextPos] == 2 {
                        print("found \(i - 1)")
                        fatalError()
                    }
                    next.append((nextPos, state.1 + [nextPos]))
                }
            }
            states = next
            i += 1
        }
    }

    func runPart2() throws {
        func turnRight(curr: Int) -> Int {
            switch curr {
            case 1: return 4
            case 2: return 3
            case 3: return 1
            case 4: return 2
            default: fatalError()
            }
        }
        func nextPositon(current: Point2D, direction: Int) -> Point2D {
            switch direction {
            case 1: Point2D(x: current.x, y: current.y + 1)
            case 2: Point2D(x: current.x, y: current.y - 1)
            case 3: Point2D(x: current.x - 1, y: current.y)
            case 4: Point2D(x: current.x + 1, y: current.y)
            default: fatalError()
            }
        }
        let program = IntcodeComputer(program: input)

        var grid: [Point2D: Int] = [:]
        var iter = 0

        var next: [(program: IntcodeComputer, point: Point2D)] = [(program, Point2D(x: 0, y: 0))]
        while !next.isEmpty {
            var temp: [(program: IntcodeComputer, point: Point2D)] = []
            for step in next {
                for direction in [1, 2, 3, 4] {
                    let nextPos = nextPositon(current: step.point, direction: direction)
                    let program = step.program.copy()
                    let res = program.run {
                        direction
                    }
                    if grid[nextPos] != nil {
                        continue
                    }
                    switch res {
                    case .exitCode: fatalError()
                    case let .output(output: output) where output == 0:
                        grid[nextPos] = 0
                        continue
                    case let .output(output: output) where output == 1:
                        grid[nextPos] = 1
                    case let .output(output: output) where output == 2:
                        grid[nextPos] = 2
                    case .output: fatalError()
                    }
                    temp.append((program.copy(), nextPos))
                }
            }
            next = temp
            iter += 1
        }
        grid.prettyPrintDay15()
        // find shortestPath
        let res = fillWithOxygen(grid: grid)
        print(res)
    }

    func fillWithOxygen(grid: [Point2D: Int]) -> Int {
        var i = 0
        let numberOfOpenPoints = grid.values.filter { $0 == 1 || $0 == 2 }.count
        let startPoint = grid.first { $0.value == 2}!.key
        var states: [Point2D] = [startPoint]
        var seen: Set<Point2D> = [startPoint]
        while seen.count < numberOfOpenPoints {
            print("iteration: \(i)", states.count)
            var next: [Point2D] = []
            for state in states {
                for offset in [Point2D(x: 0, y: 1), Point2D(x: 0, y: -1), Point2D(x: 1, y: 0), Point2D(x: -1, y: 0)] {
                    let nextPos = Point2D(x: state.x + offset.x, y: state.y + offset.y)
                    guard let value = grid[nextPos], value == 1 || value == 2 else {
                        continue

                    }
                    if seen.contains(nextPos) {
                        continue
                    }
                    seen.insert(nextPos)
                    next.append(nextPos)
                }
            }
            states = next
            i += 1
        }
        return i
    }
}

fileprivate extension Dictionary where Key == Point2D, Value == Int {
    func prettyPrintDay15() {
        let minX = keys.map(\.x).min()!
        let maxX = keys.map(\.x).max()!
        let minY = keys.map(\.y).min()!
        let maxY = keys.map(\.y).max()!
        for y in (minY...maxY).reversed() {
            for x in minX...maxX {
                switch self[Point2D(x: x, y: y)] {
                case 0:
                    print("#", terminator: "")
                case 1:
                    print(".", terminator: "")
                case 2:
                    print("S", terminator: "")
                default:
                    print(" ", terminator: "")
                }
            }
            print()
        }
        print()
    }
}
