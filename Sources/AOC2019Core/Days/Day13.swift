import Foundation

class Day13: Day {
    var day: Int { 13 }
    let input: [Int]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "1,2,3,6,5,4"
        } else {
            inputString = try InputGetter.getInput(for: 13, part: .first)
        }
        self.input = inputString
            .split(separator: ",")
            .map { Int($0)! }
    }

    func runPart1() throws {
        let programm = IntcodeComputer(program: input)
        var tiles: [Point2D: Int] = [:]
        while true {
            let xRes = programm.run(input: {
                fatalError()
            })
            if xRes == .exitCode { break }

            let yRes = programm.run(input: {
                fatalError()
            })
            if yRes == .exitCode { break }

            let zRes = programm.run(input: {
                fatalError()
            })
            if zRes == .exitCode { break }

            let xValue = xRes.outputValue!
            let yValue = yRes.outputValue!
            let zValue = zRes.outputValue!

            tiles[Point2D(x: xValue, y: yValue)] = zValue
        }

        print(tiles.values.filter { $0 == 2 }.count)
    }

    func runPart2() throws {
        let programm = IntcodeComputer(program: input)
        programm.program[0] = 2
        var tiles: [Point2D: Int] = [:]
        while true {
            let xRes = programm.run(input: {
                0
            })
            if xRes == .exitCode { break }

            let yRes = programm.run(input: {
                fatalError()
            })
            if yRes == .exitCode { break }

            let zRes = programm.run(input: {
                fatalError()
            })
            if zRes == .exitCode { break }

            let xValue = xRes.outputValue!
            let yValue = yRes.outputValue!
            let zValue = zRes.outputValue!

            if xValue == -1 && yValue == 0 {
                print("score: \(zValue)")
            }

            tiles[Point2D(x: xValue, y: yValue)] = zValue
            if tiles.count == 741 {
                break
            }
        }
        tiles.prettyPrint()
        var i = 1
        var score = 0
        while true {
            if !tiles.contains(where: { $0.value == 2 }) {
                print(score)
                return
            }
            while true {

//                print("input: ")
                let xRes = programm.run(input: {
                    guard let ball = tiles.first(where: { $0.value == 4 }),
                          let paddle = tiles.first(where: {$0.value == 3 })
                    else {
                        return 0
                    }
                    if ball.key.x < paddle.key.x { return -1 }
                    if ball.key.x > paddle.key.x { return 1 }
                    return 0

                })
                if xRes == .exitCode { break }

                let yRes = programm.run(input: {
                    fatalError()
                })
                if yRes == .exitCode { break }

                let zRes = programm.run(input: {
                    fatalError()
                })
                if zRes == .exitCode { break }

                let xValue = xRes.outputValue!
                let yValue = yRes.outputValue!
                let zValue = zRes.outputValue!

                if xValue == -1 && yValue == 0 {
                    print("score: \(zValue)")
                    score = zValue
                }

                tiles[Point2D(x: xValue, y: yValue)] = zValue
//                if i % 2 == 0 {
                if i % 10 == 0 {
                    tiles.prettyPrint()
                }
                print()
//                }
                i += 1
            }
            programm.ip = 0
        }

        tiles.prettyPrint()

        print(score)
    }
}

extension Dictionary where Key == Point2D, Value == Int {
    func prettyPrint() {
        let minX = keys.map(\.x).min()!
        let maxX = keys.map(\.x).max()!
        let minY = keys.map(\.y).min()!
        let maxY = keys.map(\.y).max()!
        for y in minY...maxY {
            for x in minX...maxX {
                switch self[Point2D(x: x, y: y)] {
                case 0:
                    print(" ", terminator: "")
                case 1:
                    print("#", terminator: "")
                case 2:
                    print("U", terminator: "")
                case 3:
                    print("-", terminator: "")
                case 4:
                    print("o", terminator: "")
                default:
                    break
                }
            }
            print()
        }
    }
}
