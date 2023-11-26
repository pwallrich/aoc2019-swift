import Foundation

class Day4: Day {
    var day: Int { 4 }
    let input: ClosedRange<Int>

    init(testInput: Bool) throws {
        if testInput {
            input = 1...2
        } else {
            input = 137683...596253
        }
    }

    func runPart1() throws {
        let res = input.map { isValid(password: $0) }.filter { $0 }
        print(res.count)
//        print(isValid(password: 111111))
//        print(isValid(password: 223450))
//        print(isValid(password: 123789))
//        print(isValid(password: 111234))
    }

    func runPart2() throws {
        let res = input.map { isValidPart2(password: $0) }.filter { $0 }
        print(res.count)
//        print(isValidPart2(password: 112233))
//        print(isValidPart2(password: 123444))
//        print(isValidPart2(password: 111122))
    }

    func isValid(password: Int) -> Bool {
        var adjSame = false
        var onlyIncreasing = true

        var last = password % 10
        var value = password / 10
        while value > 0 {
            let next = value % 10
            value /= 10
            if last == next {
                adjSame = true
            }
            if last < next {
                onlyIncreasing = false
            }
            last = next
        }
        return adjSame && onlyIncreasing
    }

    func isValidPart2(password: Int) -> Bool {
        var adjSame = false
        var values: [Int] = []
        var value = password
        while value > 0 {
            values.append(value % 10)
            value /= 10
        }
        var last: Int?
        var sameCount: Int = 0
        for i in (0..<values.count).reversed() {
            if values[i] < last ?? 0 {
                return false
            }
            if values[i] == last {
                sameCount += 1
            } else if sameCount == 1 {
                adjSame = true
                sameCount = 0
            } else {
                sameCount = 0
            }
            last = values[i]
        }
        if sameCount == 1 {
            adjSame = true
        }

        return adjSame
    }
}
