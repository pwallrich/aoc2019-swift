import Foundation

class Day8: Day {
    var day: Int { 8 }
    let width: Int
    let height: Int
    let input: String

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            width = 2
            height = 2
            inputString = "0222112222120000"
        } else {
            width = 25
            height = 6
            inputString = try InputGetter.getInput(for: 8, part: .first)
        }
        self.input = inputString
    }

    func runPart1() throws {
        let layers = input.chunks(ofCount: width * height)
        let resLayer = layers.map { layer -> [Character: Int] in
            var res: [Character: Int] = [:]
            for char in layer {
                res[char, default: 0] += 1
            }
            return res
        }.min { $0["0"] ?? 0 < $1["0"] ?? 0}!

        print(resLayer["1"]! * resLayer["2"]!)
    }

    func runPart2() throws {
        let layers = input
            .chunks(ofCount: width * height)
            .map { val -> [Character] in Array(val) }

        var result: [Bool] = Array(repeating: false, count: width*height)
        for i in 0..<(width * height) {
            // 0 is black, 1 is white, 2 is transparent
            for layer in layers {
                guard layer[i] != "2" else {
                    continue
                }
                result[i] = layer[i] == "1"
                break
            }
        }
        result.prettyPrint(width: width, height: height)
    }
}

extension Array where Element == Bool {
    func prettyPrint(width: Int, height: Int) {
        for (idx, val) in self.enumerated() {
            if idx % width == 0 {
                print()
            }
            print(val ? "#" : " ", terminator: " ")
        }
        print()
    }
}
