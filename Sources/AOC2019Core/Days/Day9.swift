import Foundation

class Day9: Day {
    var day: Int { 9 }
    let input: [Int]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"
        } else {
            inputString = try InputGetter.getInput(for: 9, part: .first)
        }
        self.input = inputString
            .split(separator: ",")
            .map { Int($0)! }
    }

    func runPart1() throws {
        let program = IntcodeComputer(program: input)
        var res: IntcodeComputer.IntCodeReturnType
        repeat {
            res = program.run(input: {
                2
            })
            print(res)
        } while res != .exitCode

    }

    func runPart2() throws {}
}
