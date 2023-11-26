import Foundation

class Day10: Day {
    var day: Int { 10 }
    let input: Set<Point2D>
    let width: Int
    let height: Int
    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """
.#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##
"""
        } else {
            inputString = try InputGetter.getInput(for: 10, part: .first)
        }
        let rows = inputString
            .split(separator: "\n")
        var input: Set<Point2D> = []
        for (y, row) in rows.enumerated() {
            let vals = Array(row)
            for (x, char) in vals.enumerated() {
                guard char == "#" else { continue }
                input.insert(Point2D(x: x, y: y))
            }
        }
        self.input = input
        height = rows.count
        width = rows[0].count
    }

    func runPart1() throws {
        var seen: [Point2D: Int] = [:]
        for point in input {
            var canSee = input.filter { $0 != point }
            for other in input where other != point {
                let xDiff = other.x - point.x
                let yDiff = other.y - point.y
                let gcd = abs(findGCD(num1: xDiff, num2: yDiff))

                let stepsX = xDiff / gcd
                let stepsY = yDiff / gcd

                var start = point
                start.x += stepsX
                start.y += stepsY
                while start != other {
//                    print(point, other, start, stepsX, stepsY)
                    if input.contains(start) {
                        // there's something in the way
                        canSee.remove(other)
                    }
                    start.x += stepsX
                    start.y += stepsY
                }
            }
            seen[point] = canSee.count
        }
        print(seen.values.max()!)
    }

    func runPart2() throws {
        var seen: [Point2D: Int] = [:]

        for point in input {
            var canSee = input.filter { $0 != point }
            for other in input where other != point {
                let xDiff = other.x - point.x
                let yDiff = other.y - point.y
                let gcd = abs(findGCD(num1: xDiff, num2: yDiff))

                let stepsX = xDiff / gcd
                let stepsY = yDiff / gcd

                var start = point
                start.x += stepsX
                start.y += stepsY
                while start != other {
//                    print(point, other, start, stepsX, stepsY)
                    if input.contains(start) {
                        // there's something in the way
                        canSee.remove(other)
                    }
                    start.x += stepsX
                    start.y += stepsY
                }
            }
            seen[point] = canSee.count
        }
        let best = seen.max { $0.value < $1.value }!
//        print(seen.max { $0.value < $1.value })

        var angles: [Point2D: (r: Double, angle: Double)] = [:]
        for other in input where other != best.key {
            let xRelative = other.x - best.key.x
            let yRelative = -(other.y - best.key.y)

            let r = sqrt(Double(xRelative * xRelative + yRelative * yRelative))
            var angle = if xRelative > 0 {
                atan(Double(yRelative) / Double(xRelative))
            } else if xRelative < 0 && yRelative >= 0 {
                atan(Double(yRelative) / Double(xRelative)) + Double.pi
            } else if xRelative < 0 && yRelative < 0 {
                atan(Double(yRelative) / Double(xRelative)) - Double.pi
            } else if xRelative == 0 && yRelative > 0 {
                Double.pi / 2
            } else if xRelative == 0 && yRelative < 0 {
                -Double.pi / 2
            } else {
                fatalError()
            }
            if angle < 0 {
                angle += 2 * Double.pi
            }

            angles[other] = (r, angle)
        }
        // grid is 25 by 25
        var angle = Double.pi / 2

        var removed: [Point2D] = []
        while removed.count < 200 {
            let next = angles.filter { $0.value.angle == angle }.min { $0.value.r < $1.value.r }
            if let next {
                angles[next.key] = nil
                removed.append(next.key)
                print("removed \(next.key) as \(removed.count) value")
            }
            angle = getNextAngle(after: angle, angles: angles)
        }

        print(removed.last!.x * 100 + removed.last!.y)
    }

    func getNextAngle(after: Double, angles: [Point2D: (r: Double, angle: Double)]) -> Double {
        let candidates = angles.filter { $0.value.angle < after }
        let next = candidates.max { lhs, rhs in lhs.value.angle < rhs.value.angle }
        if let next {
            return next.value.angle
        }
        return angles.max { $0.value.angle < $1.value.angle }!.value.angle
    }


}

// Function to find gcd of two numbers
func findGCD(num1: Int, num2: Int) -> Int {
   var x = 0

   // Finding maximum number
   var y: Int = max(num1, num2)

   // Finding minimum number
   var z: Int = min(num1, num2)

   while z != 0 {
      x = y
      y = z
      z = x % y
   }
   return y
}
