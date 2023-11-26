import Foundation

class Day16: Day {
    var day: Int { 16 }
    let input: [Int]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
//            inputString = "12345678"
            inputString = "03081770884921959731165446850517"
        } else {
            inputString = try InputGetter.getInput(for: 16, part: .first)
        }
        self.input = inputString.map { Int(String($0))! }
    }

    func indices(for digit: Int, count: Int) -> [(idx: Int, sign: Int)] {
        var res: [(idx: Int, sign: Int)] = []
        res.reserveCapacity(count / 2)
        var idx = digit
        var iteration = 0
        while idx < count {
            for i in 0..<(digit + 1) {
                let sign = iteration % 2 == 0 ? 1 : -1
                if idx + i < count {
                    res.append((idx + i, sign))
                }
            }
            idx += 2 * (digit + 1)
            iteration += 1
        }

        return res
    }

    func runPart1() throws {
        var curr = input
        for iter in 0..<100 {
            print("at iteration \(iter)")
            var next: [Int] = []
            for (numberIdx, _) in curr.enumerated() {
                var res = 0
                var sign = 1
                for idx in stride(from: numberIdx, to: curr.count, by: (numberIdx + 1) * 2) {
                    var currIdx = idx
                    let target = idx + numberIdx + 1
                    while currIdx < curr.count && currIdx < target {
                        res += curr[currIdx] * sign
                        currIdx += 1
                    }
                    sign *= -1
                    if iter == 0 {
                        print(numberIdx, idx)
                    }
                }
                next.append(abs(res % 10))
            }
            curr = next
        }
        print(curr.prefix(8).map { String($0) }.joined())
    }

    func runPart2() throws {
        let input = Array(repeating: input, count: 10_000).flatMap { $0 }


        let offset = Int(input[0..<7].map { String($0) }.joined())!
        var curr = Array(input[offset...])
        for iter in 0..<100 {
            print("at iteration \(iter)")
            var next: [Int] = []
            var res = 0
            for val in curr.reversed() {
                res += val
                next.append(res % 10)
            }
            curr = next.reversed()
        }

        print(curr.prefix(8).map { String($0) }.joined())
//        print(curr.prefix(8).map { String($0) }.joined())
    }
}
