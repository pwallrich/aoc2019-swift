import Foundation
import Collections
class Day25: Day {
    var day: Int { 25 }
    let input: [Int]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "foo"
        } else {
            inputString = try InputGetter.getInput(for: 25, part: .first)
        }
        self.input = inputString.split(separator: ",").map { Int($0)! }
    }

    func runPart1() throws {
        for (idx, combination) in ["dark matter", "candy cane", "hologram", "astrolabe", "whirled peas", "tambourine", "klein bottle"].combinations(ofCount: 1...8).enumerated() {
            print(idx, combination)
        }
    }

    func runPart2() throws {}
}
