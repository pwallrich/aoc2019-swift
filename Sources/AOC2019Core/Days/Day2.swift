import Foundation

class Day2: Day {
    var day: Int { 2 }
    let input: String

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "1,9,10,3,2,3,11,0,99,30,40,50"
        } else {
            inputString = try InputGetter.getInput(for: 2, part: .first)
        }
        self.input = inputString
    }

    func runPart1() throws {
        var commands = input
            .split(separator: ",")
            .map { Int($0)! }
        commands[1] = 12
        commands[2] = 2
        commands.runIntcode()
        print(commands[0])
    }

    func runPart2() throws {}
}

extension Array where Element == Int {
    mutating func runIntcode() {
        var ip = 0
        while ip < count && self[ip] != 99 {
            let firstValue = self[self[ip + 1]]
            let secondValue = self[self[ip + 2]]

            let res = switch self[ip] {
            case 1: firstValue + secondValue
            case 2: firstValue * secondValue
            default: fatalError()
            }

            self[self[ip + 3]] = res


            ip += 4
        }
    }
}
