import Foundation

class Day12: Day {
    var day: Int { 12 }
    let input: [Point3D]

    init(testInput: Bool) throws {
        if testInput {
            input = [
                .init(x: -8, y: -10, z: 0),
                .init(x: 5, y: 5, z: 10),
                .init(x: 2, y: -7, z: 3),
                .init(x: 9, y: -8, z: -3),
            ]
        } else {
            input = [
                .init(x: -7, y: -1, z: 6),
                .init(x: 6, y: -9, z: -9),
                .init(x: -12, y: 2, z: -7),
                .init(x: 4, y: -17, z: -12),
            ]
        }
    }

    func runPart1() throws {
        var velocities = Array(repeating: Point3D(x: 0, y: 0, z: 0), count: input.count)
        var moons = input
        for i in 0..<1000 {
            print("iteration \(i)")
            for comb in (velocities.indices).combinations(ofCount: 2) {
                if moons[comb[0]].x < moons[comb[1]].x {
                    velocities[comb[0]].x += 1
                    velocities[comb[1]].x -= 1
                } else if moons[comb[0]].x > moons[comb[1]].x {
                    velocities[comb[0]].x -= 1
                    velocities[comb[1]].x += 1
                }
                if moons[comb[0]].y < moons[comb[1]].y {
                    velocities[comb[0]].y += 1
                    velocities[comb[1]].y -= 1
                } else if moons[comb[0]].y > moons[comb[1]].y {
                    velocities[comb[0]].y -= 1
                    velocities[comb[1]].y += 1
                }
                if moons[comb[0]].z < moons[comb[1]].z {
                    velocities[comb[0]].z += 1
                    velocities[comb[1]].z -= 1
                } else if moons[comb[0]].z > moons[comb[1]].z {
                    velocities[comb[0]].z -= 1
                    velocities[comb[1]].z += 1
                }
            }
            for idx in moons.indices {
                moons[idx].adding(other: velocities[idx])
            }
//            print(zip(moons, velocities))
        }

        var res = 0
        for idx in moons.indices {
            let pot = moons[idx].manhattan(to: Point3D(x: 0, y: 0, z: 0))
            let kin = velocities[idx].manhattan(to: Point3D(x: 0, y: 0, z: 0))
            let total = pot * kin
            res += total
        }
        print(res)
    }

    struct State: Hashable {
        var position: Point3D
        var velocity: Point3D
    }

    struct Axis: Hashable {
        let positions: [Int]
        let velocities: [Int]
    }

    func runPart2() throws {
        var moons: [State] = input.map { .init(position: $0, velocity: .init(x: 0, y: 0, z: 0)) }

        var seen: Set<[State]> = []
        var seenAxis: [[Axis: Int]] = [[:], [:], [:]]
//        var seenIndividual: [Set<Point3D>] = moons.map { [$0.position] }

        var i = 0
        var xOsc: Int?
        var yOsc: Int?
        var zOsc: Int?
        while xOsc == nil || yOsc == nil || zOsc == nil {
            if i % 100 == 0 {
                print("iteration \(i)")
            }
            seen.insert(moons)
            for comb in (moons.indices).combinations(ofCount: 2) {
                if moons[comb[0]].position.x < moons[comb[1]].position.x {
                    moons[comb[0]].velocity.x += 1
                    moons[comb[1]].velocity.x -= 1
                } else if moons[comb[0]].position.x > moons[comb[1]].position.x {
                    moons[comb[0]].velocity.x -= 1
                    moons[comb[1]].velocity.x += 1
                }
                if moons[comb[0]].position.y < moons[comb[1]].position.y {
                    moons[comb[0]].velocity.y += 1
                    moons[comb[1]].velocity.y -= 1
                } else if moons[comb[0]].position.y > moons[comb[1]].position.y {
                    moons[comb[0]].velocity.y -= 1
                    moons[comb[1]].velocity.y += 1
                }
                if moons[comb[0]].position.z < moons[comb[1]].position.z {
                    moons[comb[0]].velocity.z += 1
                    moons[comb[1]].velocity.z -= 1
                } else if moons[comb[0]].position.z > moons[comb[1]].position.z {
                    moons[comb[0]].velocity.z -= 1
                    moons[comb[1]].velocity.z += 1
                }
            }
            for idx in moons.indices {
                moons[idx].position.adding(other: moons[idx].velocity)
//                if seenIndividual[idx].contains(moons[idx].position) {
//                    print("\(idx) seen before")
//                }
//                seenIndividual[idx].insert(moons[idx].position)
            }
            let xAxis = Axis(positions: moons.map(\.position.x), velocities: moons.map(\.velocity.x))
            let yAxis = Axis(positions: moons.map(\.position.y), velocities: moons.map(\.velocity.y))
            let zAxis = Axis(positions: moons.map(\.position.z), velocities: moons.map(\.velocity.z))
            if seenAxis[0][xAxis] != nil && xOsc == nil {
                print("x oscilitating after: \(i - seenAxis[0][xAxis]!)")
                xOsc = i - seenAxis[0][xAxis]!
            } else if xOsc == nil {
                seenAxis[0][xAxis] = i
            }
            if seenAxis[1][yAxis] != nil && yOsc == nil {
                print("y oscilitating after: \(i - seenAxis[1][yAxis]!)")
                yOsc = i - seenAxis[1][yAxis]!
            } else if yOsc == nil {
                seenAxis[1][yAxis] = i
            }
            if seenAxis[2][zAxis] != nil && zOsc == nil {
                print("z oscilitating after: \(i - seenAxis[2][zAxis]!)")
                zOsc = i - seenAxis[2][zAxis]!
            } else if zOsc == nil {
                seenAxis[2][zAxis] = i
            }
            i += 1
//            for moon in moons {
//                print(moon)
//            }
        }
        print(xOsc! * yOsc! * zOsc!)
        print(leastCommonMultiple(numbers: [xOsc!, yOsc!, zOsc!]))
        print(i)
    }
}

func leastCommonMultiple(numbers: [Int]) -> Int {
    guard let primes = findPrimesUntil(limit: numbers.max()!) else {
        return numbers.reduce(1, *)
    }
    var values = numbers
    var res = 1
    var currPrimeIdx = 0
    while values.contains(where: { $0 != 1 }) {
        var found = false
        for (idx, value) in values.enumerated() {
            if value % primes[currPrimeIdx] == 0 {
                values[idx] /= primes[currPrimeIdx]
                found = true
            }
        }
        if !found {
            currPrimeIdx += 1
        } else {
            res *= primes[currPrimeIdx]
        }
    }
    return res
}

func findPrimesUntil(limit: Int) -> [Int]? {
    guard limit > 1 else {
        return nil
    }

    var primes =  [Bool](repeating: true, count: limit+1)

    for i in 0..<2 {
        primes[i] = false
    }

    for j in 2..<primes.count where primes[j] {
        var k = 2
        while k * j < primes.count {
            primes[k * j] = false
            k += 1
        }
    }

    return primes.enumerated().compactMap { (index: Int, element: Bool) -> Int? in
        if element {
            return index
        }
        return nil
    }
}

struct Point3D: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int
    var z: Int

    func manhattan(to other: Point3D) -> Int {
        abs(x - other.x) + abs(y - other.y) + abs(z - other.z)
    }

    mutating func adding(other: Point3D) {
        x += other.x
        y += other.y
        z += other.z
    }

    var description: String {
        "(x:\(x), y:\(y), z:\(z))"
    }
}
