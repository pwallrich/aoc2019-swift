import Foundation

class Day21: Day {
    var day: Int { 21 }
    let input: [Int]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "foo"
        } else {
            inputString = try InputGetter.getInput(for: 21, part: .first)
        }
        self.input = inputString.split(separator: ",").map { Int($0)! }
    }

    func runPart1() throws {
        var i = 0
//        while true {

            for combination in ["NOT A J", "NOT B J", "NOT C J", "NOT D J", "NOT T J", "NOT J J", "OR A J", "OR B J", "OR C J", "OR D J", "OR T J", "OR J J", "AND A J", "AND B J", "AND C J", "AND D J", "AND T J", "AND J J"].permutations(ofCount: 4) {
                print("iteration \(i)")
                i += 1
                let program = IntcodeComputer(program: input)
                let temp = (combination.joined(by: "\n") + "\nWALK\n")
                var commands = temp.map { Int($0.asciiValue!) }

                var res: IntcodeComputer.IntCodeReturnType!
                repeat {
                    res = program.run(input: {
                        commands.removeFirst()
                    })
                    switch res {
                    case .output(output: let output):
//                        print(UnicodeScalar(output)!, terminator: "")
                        if output > 127 {
                            print(output)
                            fatalError()
                        }
                    default: break
                    }
                } while res != .exitCode
            }
            
//        }
    }

    func runPart2() throws {
        let program = IntcodeComputer(program: input)
        let command = "NOT B J\nNOT C T\nOR T J\nAND D J\nNOT E T\nNOT T T\nOR H T\nAND T J\nNOT A T\nOR T J\nRUN\n"
        var commands = command.map { Int($0.asciiValue!) }

        var res: IntcodeComputer.IntCodeReturnType!
        repeat {
            res = program.run(input: {
                commands.removeFirst()
            })
            switch res {
            case .output(output: let output):
                if output > 127 {
                    print(output)
                    fatalError()
                }
            default: break
            }
        } while res != .exitCode
    }
}
