import Foundation

class Day11: Day {
    var day: Int { 11 }
    let input: [Int]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "foo"
        } else {
            inputString = try InputGetter.getInput(for: 11, part: .first)
        }
        self.input = inputString
            .split(separator: ",")
            .map { Int($0)! }
    }

    func runPart1() throws {
        let program = IntcodeComputer(program: input)
        var seen: Set<Point2D> = []
        var white: Set<Point2D> = []
        var current = Point2D(x: 0, y: 0)
        var dir = Point2D(x: 0, y: 1)
        var res: IntcodeComputer.IntCodeReturnType!
        repeat {
            res = program.run(input: {
                white.contains(current) ? 1 : 0
            })
            if res == .exitCode {
                break
            }
            let firstValue = switch res {
            case let .output(output: value): value
            default: fatalError()
            }
            if firstValue == 1 {
                white.insert(current)
            } else {
                white.remove(current)
            }
            seen.insert(current)

            res = program.run(input: {
                white.contains(current) ? 1 : 0
            })
            
            if res == .exitCode {
                break
            }
            let secondValue = switch res {
            case let .output(output: value): value
            default: fatalError()
            }

            if secondValue == 0 {
                // turn left
                dir = switch dir {
                case Point2D(x: 0, y: 1): Point2D(x: -1, y: 0)
                case Point2D(x: -1, y: 0): Point2D(x: 0, y: -1)
                case Point2D(x: 0, y: -1): Point2D(x: 1, y: 0)
                case Point2D(x: 1, y: 0): Point2D(x: 0, y: 1)
                default:
                    fatalError()
                }
            } else if secondValue == 1 {
                dir = switch dir {
                case Point2D(x: 0, y: 1): Point2D(x: 1, y: 0)
                case Point2D(x: -1, y: 0): Point2D(x: 0, y: 1)
                case Point2D(x: 0, y: -1): Point2D(x: -1, y: 0)
                case Point2D(x: 1, y: 0): Point2D(x: 0, y: -1)
                default:
                    fatalError()
                }
            } else {
                fatalError()
            }
            current.x += dir.x
            current.y += dir.y

        } while res != .exitCode

        print(seen.count)
    }

    func runPart2() throws {
        let program = IntcodeComputer(program: input)
        var seen: Set<Point2D> = []
        var current = Point2D(x: 0, y: 0)
        var white: Set<Point2D> = [current]
        var dir = Point2D(x: 0, y: 1)
        var res: IntcodeComputer.IntCodeReturnType!
        repeat {
            res = program.run(input: {
                white.contains(current) ? 1 : 0
            })
            if res == .exitCode {
                break
            }
            let firstValue = switch res {
            case let .output(output: value): value
            default: fatalError()
            }
            if firstValue == 1 {
                white.insert(current)
            } else {
                white.remove(current)
            }
            seen.insert(current)

            res = program.run(input: {
                white.contains(current) ? 1 : 0
            })

            if res == .exitCode {
                break
            }
            let secondValue = switch res {
            case let .output(output: value): value
            default: fatalError()
            }

            if secondValue == 0 {
                // turn left
                dir = switch dir {
                case Point2D(x: 0, y: 1): Point2D(x: -1, y: 0)
                case Point2D(x: -1, y: 0): Point2D(x: 0, y: -1)
                case Point2D(x: 0, y: -1): Point2D(x: 1, y: 0)
                case Point2D(x: 1, y: 0): Point2D(x: 0, y: 1)
                default:
                    fatalError()
                }
            } else if secondValue == 1 {
                dir = switch dir {
                case Point2D(x: 0, y: 1): Point2D(x: 1, y: 0)
                case Point2D(x: -1, y: 0): Point2D(x: 0, y: 1)
                case Point2D(x: 0, y: -1): Point2D(x: -1, y: 0)
                case Point2D(x: 1, y: 0): Point2D(x: 0, y: -1)
                default:
                    fatalError()
                }
            } else {
                fatalError()
            }
            current.x += dir.x
            current.y += dir.y

        } while res != .exitCode

        print(seen.count)
        white.prettyPrint()
    }
}

extension Set where Element == Point2D {
    func prettyPrint(xRange: Range<Int>? = nil, yRange: Range<Int>? = nil) {
        let minX = xRange?.lowerBound ?? self.map(\.x).min()!
        let maxX = xRange?.upperBound ?? self.map(\.x).max()!
        let minY = yRange?.lowerBound ?? self.map(\.y).min()!
        let maxY = yRange?.upperBound ?? self.map(\.y).max()!

        for y in (minY...maxY).reversed() {
            for x in minX...maxX {
                print(self.contains(.init(x: x, y: y)) ? "#" : " ", terminator: "")
            }
            print()
        }
    }
}
