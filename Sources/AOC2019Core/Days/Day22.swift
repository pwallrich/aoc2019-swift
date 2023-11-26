import Foundation

class Day22: Day {
    var day: Int { 22 }
    let input: [String.SubSequence]
    let initial: [Int]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            initial = (0..<10).map { $0 }
            inputString = """
deal into new stack
cut -2
deal with increment 7
cut 8
cut -4
deal with increment 7
cut 3
deal with increment 9
deal with increment 3
cut -1
cut -11
"""
        } else {
            inputString = try InputGetter.getInput(for: 22, part: .first)
            initial = (0..<10007).map { $0 }
        }
        self.input = inputString.split(separator: "\n")
    }

    func runPart1() throws {
        var curr = initial
        for (idx, row) in input.enumerated() {
            print("iteration \(idx) of \(input.count)")
            let commands = row.split(separator: " ")
            switch (commands[0], commands[1]) {
            case ("cut", _):
                let amount = Int(commands.last!)!
                if amount > 0 {
                    let idx = amount % curr.count
                    curr = Array(curr[idx...] + curr[..<idx])
                } else {
                    let idx = amount % curr.count
                    curr = Array(curr[(curr.count + idx)...] + curr[..<(curr.count + idx)])
                }
            case ("deal", "with"):
                let number = Int(commands.last!)!
                var idx = 0
                var new = curr
                for i in 0..<curr.count {
                    new[idx] = curr[i]
                    idx = (idx + number) % new.count
                }
                curr = new
            case ("deal", "into"):
                curr = curr.reversed()
            default:
                fatalError()
            }
        }
        print(curr.firstIndex(of: 2019)!)
    }

    func runPart2() throws {
    }
}
