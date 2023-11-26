import Foundation

class Day5: Day {
    var day: Int { 5 }
    let input: [Int]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"
        } else {
            inputString = try InputGetter.getInput(for: 5, part: .first)
        }
        self.input = inputString
            .split(separator: ",")
            .map { Int($0)! }
    }

    func runPart1() throws {
        var curr = input
        curr.runAdvancedIntcode {
            1
        } outputs: { output in
            print(output)
        }

    }

    func runPart2() throws {
        var curr = input
        curr.runAdvancedIntcode {
            5
        } outputs: { output in
            print(output)
        }
    }
}


extension Array where Element == Int {
    mutating func runAdvancedIntcode(input: () -> Int, outputs: (Int) -> Void) {
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
                let value = input()
                self[toStore] = value
                ip += 2
            case 4:
                let firstValue = getValueOrRelative(modes: pModes, ip: ip, idx: 0)
                outputs(firstValue)
                ip += 2

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
    }
}
