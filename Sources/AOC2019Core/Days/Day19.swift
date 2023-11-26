import Foundation

class Day19: Day {
    var day: Int { 19 }
    let input: [Int]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = "foo"
        } else {
            inputString = try InputGetter.getInput(for: 19, part: .first)
        }
        self.input = inputString
            .split(separator: ",")
            .map { Int($0)! }
    }

    func runPart1() throws {

        var count = 0
        for y in 0..<50 {
            for x in 0..<50 {
                let program = IntcodeComputer(program: input)
                var input = [y, x]
                let res = program.run {
                    input.popLast()!
                }
                switch res {
                case .output(let output):
                    assert(output == 0 || output == 1)
                    count += output
                case .exitCode:
                    fatalError()
                }
            }
        }
        print(count)
    }

    func isPartOfBeam(x: Int, y: Int) -> Bool {
        let program = IntcodeComputer(program: input)
        var input = [y, x]
        let res = program.run {
            input.popLast()!
        }
        switch res {
        case .output(let output):
            assert(output == 0 || output == 1)
            return output == 1
        case .exitCode:
            fatalError()
        }
    }

    func printGrid(xRange: Range<Int>, yRange: Range<Int>) {
        for y in yRange {
            for x in xRange {
                let val = isPartOfBeam(x: x, y: y)
                print(val ? "#" : ".", terminator: "")
            }
            print()
        }
    }

    func doesRectangleFit(lowerX: Int, upperX: Int, lowerY: Int) -> (Int, Int)? {
        let upperY = lowerY + 99

        var lower = lowerX - 10
        while lower + 100 <= upperX + 10 {
            guard isPartOfBeam(x: lower, y: lowerY), isPartOfBeam(x: lower + 99, y: lowerY),
                    isPartOfBeam(x: lower, y: upperY), isPartOfBeam(x: lower + 99, y: upperY) else {
                lower += 1
                continue
            }
            return (lower, lower + 99)
        }
        return nil
    }

    func runPart2() throws {
//        printGrid(xRange: 700..<900, yRange: 990..<1100)
//        return
        var lowerX = 8
        var upperX = 9
        var currY = 11
        while true {
            currY += 1
            let newLowerX = {
                var curr = lowerX - 20
                while true {
                    let isPart = isPartOfBeam(x: curr, y: currY)
                    if isPart { break }
                    curr += 1
                }
                return curr
            }()
            let newUpperX = {
                var curr = upperX + 20
                while true {
                    let isPart = isPartOfBeam(x: curr, y: currY)
                    if isPart { break }
                    curr -= 1
                }
                return curr
            }()
            print(newLowerX, newUpperX)
            if currY == 994 {
                print("foo")
            }
            if newUpperX - newLowerX >= 100 {
                print("found \(newUpperX), \(newLowerX)")
                let isPart = doesRectangleFit(lowerX: newLowerX, upperX: newUpperX, lowerY: currY)
                if let isPart {
                    lowerX = isPart.0
                    upperX = isPart.1
                    break
                }
//                print(isPart)
            }
            lowerX = newLowerX
            upperX = newUpperX
        }
        // 4 89 => y 994, x => 789
        print(min(lowerX, upperX) * 10000 + currY)
    }
}
