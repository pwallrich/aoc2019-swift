import Foundation

class Day17: Day {
    var day: Int { 17 }
    let input: [Int]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "foo"
        } else {
            inputString = try InputGetter.getInput(for: 17, part: .first)
        }
        self.input = inputString.split(separator: ",").map { Int($0)! }
    }

    func generateGrid() -> [Point2D: Character] {
        var x = 0
        var y = 0

        let program = IntcodeComputer(program: input)

        var output: IntcodeComputer.IntCodeReturnType!
        var grid: [Point2D: Character] = [:]
        repeat {
            output = program.run(input: {
                fatalError()
            })
            switch output {
            case let .output(output: o):
                if o == 10 {
                    y += 1
                    x = 0
                    continue
                }
                grid[Point2D(x: x, y: y)] = Character(UnicodeScalar(o)!)
                x += 1
            default: break
            }
        } while output != .exitCode
        return grid
    }

    func runPart1() throws {

        let grid: [Point2D: Character] = generateGrid()

        grid.prettyPrint()
        var res = 0
        for point in grid where point.value == "#" {
            var isIntersection = true
            for adj in [Point2D(x: 0, y: 1), Point2D(x: 0, y: -1), Point2D(x: 1, y: 0), Point2D(x: -1, y: 0)] {

                let next = Point2D(x: point.key.x + adj.x, y: point.key.y + adj.y)
                if grid[next] != "#" {
                    isIntersection = false
                    break
                }
            }
            guard isIntersection else { continue }
            res += point.key.x * point.key.y
        }
        print(res)
    }

    func runPart2() throws {
//        let grid = generateGrid()

        let program = IntcodeComputer(program: input)
        program.program[0] = 2
        
        var output: IntcodeComputer.IntCodeReturnType!
        let inputString =
            "A,B,A,C,A,B,C,A,B,C\n" +
            "R,8,R,10,R,10\n" +
            "R,4,R,8,R,10,R,12\n" +
            "R,12,R,4,L,12,L,12\n" +
            "n\n"
        let inputs = inputString.map(\.asciiValue!)
        var inputIdx = 0

        repeat {
            output = program.run(input: {
                let val = Int(inputs[inputIdx])
                inputIdx += 1
                return val
            })
            switch output {
            case let .output(output: o):
                if o > 127 {
                    print(o)
                } else {
                    print(UnicodeScalar(o)!, terminator: "")
                }
            default: break
            }
        } while output != .exitCode

    }
}

extension Dictionary where Key == Point2D, Value == Character {
    func prettyPrint() {
        let minX = keys.map(\.x).min()!
        let maxX = keys.map(\.x).max()!
        let minY = keys.map(\.y).min()!
        let maxY = keys.map(\.y).max()!
        for y in minY...maxY {
            for x in minX...maxX {
                print(self[Point2D(x: x, y: y)]!, terminator: "")
            }
            print()
        }
    }
}
