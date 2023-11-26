import Foundation
import Algorithms

class Day7: Day {
    var day: Int { 7 }
    let input: [Int]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10"
        } else {
            inputString = try InputGetter.getInput(for: 7, part: .first)
        }
        self.input = inputString
            .split(separator: ",")
            .map { Int($0)! }
    }

    func runPart1() throws {
        let values = [0, 1, 2, 3, 4]
        var maxValue: Int = .min

        for value in values.permutations(ofCount: 5) {
            var res = 0
            for i in 0..<5 {
                var program = input
                res = program.runAdvancedIntcodeDay7(input: [value[i], res])
            }
            maxValue = max(maxValue, res)
        }
        print(maxValue)
    }

    func runPart2() async throws {
        let values = 5...9
        var maxValue: Int = .min

        for value in values.permutations(ofCount: 5) {
            let programs = (0..<5).map { _ in IntcodeComputer(program: input) }
            print("Testing value: \(value)")
            var inputs: [[Int]] = [
                [value[0], 0],
                [value[1]],
                [value[2]],
                [value[3]],
                [value[4]]
            ]
            var hasFinished = false
            while !hasFinished {
                for i in 0..<5 {
//                    print("running program \(i)")
                    let res = programs[i].run {
                        inputs[i].removeFirst()
                    }

                    switch res {
                    case let .output(output: output):
                        let idx = (i + 1) % 5
                        inputs[idx].append(output)
                    case .exitCode:
                        hasFinished = true
                    }
                }
            }
            print(inputs.map(\.last))
            maxValue = max(maxValue, inputs[0].last!)
        }
        print(maxValue)
    }
}

extension Array where Element == Int {
    mutating func runAdvancedIntcodeDay7(input: [Int]) -> Int {
        var inputIdx = 0
        func splitOpcode(value: Int) -> (opcode: Int, parameterModes: [Int]) {
            let opcode = value % 100
            var temp = value / 100
            var parameters: [Int] = []
            while temp > 0 {
                parameters.append(temp % 10)
                temp /= 10
            }
            return (opcode, parameters)
        }
        func getValueOrRelative(modes: [Int], ip: Int, idx: Int) -> Int {
            guard modes.count > idx else {
                return self[self[ip + idx + 1]]
            }
            if modes[idx] == 0 {
                return self[self[ip + idx + 1]]
            } else {
                return self[ip + idx + 1]
            }
        }
        var ip = 0
        while ip < count && self[ip] != 99 {
            let (opCode, pModes) = splitOpcode(value: self[ip])
            switch opCode {
            case 1:
                let firstValue = getValueOrRelative(modes: pModes, ip: ip, idx: 0)
                let secondValue = getValueOrRelative(modes: pModes, ip: ip, idx: 1)
                let res = firstValue + secondValue
                self[self[ip + 3]] = res
                ip += 4
            case 2:
                let firstValue = getValueOrRelative(modes: pModes, ip: ip, idx: 0)
                let secondValue = getValueOrRelative(modes: pModes, ip: ip, idx: 1)
                let res = firstValue * secondValue
                self[self[ip + 3]] = res
                ip += 4
            case 3:
                let toStore = self[ip + 1]
                let value = input
                self[toStore] = value[inputIdx]
                inputIdx += 1
                ip += 2
            case 4:
                let firstValue = getValueOrRelative(modes: pModes, ip: ip, idx: 0)
                return firstValue
//                outputs(firstValue)
//                ip += 2

            case 5: // jump if true
                let firstValue = getValueOrRelative(modes: pModes, ip: ip, idx: 0)
                let secondValue = getValueOrRelative(modes: pModes, ip: ip, idx: 1)
                if firstValue != 0 {
                    ip = secondValue
                } else {
                    ip += 3
                }

            case 6: // jump if false
                let firstValue = getValueOrRelative(modes: pModes, ip: ip, idx: 0)
                let secondValue = getValueOrRelative(modes: pModes, ip: ip, idx: 1)
                if firstValue == 0 {
                    ip = secondValue
                } else {
                    ip += 3
                }

            case 7: // less than
                let firstValue = getValueOrRelative(modes: pModes, ip: ip, idx: 0)
                let secondValue = getValueOrRelative(modes: pModes, ip: ip, idx: 1)
                self[self[ip + 3]] = firstValue < secondValue ? 1 : 0
                ip += 4

            case 8: // equals
                let firstValue = getValueOrRelative(modes: pModes, ip: ip, idx: 0)
                let secondValue = getValueOrRelative(modes: pModes, ip: ip, idx: 1)
                self[self[ip + 3]] = firstValue == secondValue ? 1 : 0
                ip += 4
            default:
                fatalError()
            }
        }
        fatalError()
    }
}
