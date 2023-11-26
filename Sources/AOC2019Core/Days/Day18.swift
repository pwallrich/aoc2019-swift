import Foundation

class Day18: Day {
    var day: Int { 18 }
//    let input: [Point2D: Character]
    let input: [[Character]]
    let keyPositions: Set<Point2D>
    let doorPositions: Set<Point2D>
    let startPoints: [Point2D]
    let target: DoorKey

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """
#############
#DcBa.#.GhKl#
#.###@#@#I###
#e#d#####j#k#
###C#@#@###J#
#fEbA.#.FgHi#
#############
"""
        } else {
            inputString = try InputGetter.getInput(for: 18, part: .second)
        }
        var keyPositions: Set<Point2D> = []
        var doorPositions: Set<Point2D> = []
        var startPoints: [Point2D] = []
        var input: [[Character]] = []
        var target: DoorKey = .init()
        for (y, row) in inputString.split(separator: "\n").enumerated() {
            var res: [Character] = []
            for (x, element) in row.enumerated() {
                res.append(element)
//                input[Point2D(x: x, y: y)] = element
                if element.asciiValue! >= Character("a").asciiValue! && element.asciiValue! <= Character("z").asciiValue! {
                    keyPositions.insert(Point2D(x: x, y: y))
                    target.insert(.init(char: element))
                } else if element.asciiValue! >= Character("A").asciiValue! && element.asciiValue! <= Character("Z").asciiValue! {
                    doorPositions.insert(Point2D(x: x, y: y))
                } else if element == "@" {
                    startPoints.append(Point2D(x: x, y: y))
                }
            }
            input.append(res)
        }
        self.input = input
        self.doorPositions = doorPositions
        self.keyPositions = keyPositions
        self.startPoints = startPoints
        self.target = target
    }

    struct State: Hashable, Comparable {
        static func < (lhs: Day18.State, rhs: Day18.State) -> Bool {
            // make min to max, since we're using maxheap but want to use the minimum
            lhs.priority > rhs.priority
        }

        static func ==(lhs: State, rhs: State) -> Bool {
            lhs.current == rhs.current
            //            && lhs.before == rhs.before
            && lhs.collected == rhs.collected
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(current)
            //            hasher.combine(before)
            hasher.combine(collected)
        }

        let current: Point2D
        let before: Point2D?
        //        let path: [Point2D]
        let collected: Set<Character>
        let priority: Int
        let pathCount: Int
        let didCollect: Bool
    }



    func runPart1() throws {
        let states: MaxHeap<State> = .init()
        states.insert(State(current: startPoints[0], before: nil, collected: [], priority: 0, pathCount: 0, didCollect: false))

        var seen: [State: Int] = [:]
        var i = 0
        var currentBest = Int.max
        while !states.isEmpty {
            let state = states.remove()!
            if i % 100_000 == 0 {
                print("next step \(i), \(states.count), \(state.collected.count), \(state.pathCount), \(seen.count), \(currentBest)")
            }
            if let prev = seen[state] {
                if prev < state.pathCount {
                    continue
                }
            }
            seen[state] = state.pathCount

            if state.pathCount >= currentBest {
                continue
            }
            for nextPoint in state.current.adjacentPoints() {
                guard nextPoint.y < input.count, nextPoint.x < input[nextPoint.y].count else { continue }
                guard input[nextPoint.y][nextPoint.x] != "#" else { continue }

                if let before = state.before {
                    // no need to go back and forth, if nothing was collected
                    if !state.didCollect && nextPoint == before {
                        continue
                    }
                }

                let curr = input[nextPoint.y][nextPoint.x]
                let currAscii = curr.asciiValue!

                if currAscii >= Character("A").asciiValue! && currAscii <= Character("Z").asciiValue! {
                    if !state.collected.contains(String(curr).lowercased().first!) {
                        // Key not yet found
                        continue
                    }
                }

                var collected = state.collected
                if currAscii >= Character("a").asciiValue! && currAscii <= Character("z").asciiValue! {
                    collected.insert(curr)
                }

                if collected.count == keyPositions.count {
                    if state.pathCount + 1 < currentBest {
                        print("collected all \(state.pathCount + 1)")
                    }
                    currentBest = min(state.pathCount + 1, currentBest)

                    continue
                }

                let prio = state.pathCount + (keyPositions.count - collected.count) * 10000

                let nextState = State(current: nextPoint,
                                      before: state.current,
                                      collected: collected,
                                      priority: prio,
                                      pathCount: state.pathCount + 1,
                                      didCollect:  collected.count > state.collected.count)
                if let prev = seen[nextState] {
                    if prev < nextState.pathCount {
                        continue
                    }
                }
                seen[nextState] = nextState.pathCount

                states.insert(nextState)

            }
            i += 1
        }
        print(currentBest)
    }

    struct Path2CacheKey: Hashable {
        let point: [Point2D]
        let keys: DoorKey
    }

    struct StatePart2: Hashable {
        let current: [Point2D]
        let keys: DoorKey
        let pathCount: Int
    }

    func runDijkstra(startPoint: Point2D, toFind: Set<Character>) -> Int {
        let states: MaxHeap<State> = .init()
        states.insert(State(current: startPoint, before: nil, collected: [], priority: 0, pathCount: 0, didCollect: false))

        var seen: [State: Int] = [:]
        var i = 0
        var currentBest = Int.max
        while !states.isEmpty {
            let state = states.remove()!
//            if i % 100_000 == 0 {
                print("next step \(i), \(states.count), \(state.collected.count), \(state.pathCount), \(seen.count), \(currentBest)")
//            }
            if let prev = seen[state] {
                if prev < state.pathCount {
                    continue
                }
            }
            seen[state] = state.pathCount

            if state.pathCount >= currentBest {
                continue
            }
            for nextPoint in state.current.adjacentPoints() {
                guard nextPoint.y < input.count, nextPoint.x < input[nextPoint.y].count else { continue }
                guard input[nextPoint.y][nextPoint.x] != "#" else { continue }

                let curr = input[nextPoint.y][nextPoint.x]
                let currAscii = curr.asciiValue!

                if currAscii >= Character("A").asciiValue! && currAscii <= Character("Z").asciiValue! {
                    let lowerCased = String(curr).lowercased().first!
                    if toFind.contains(lowerCased) && !state.collected.contains(String(curr).lowercased().first!) {
                        // keys not found yet
                        continue
                    }
                }

                var collected = state.collected
                if currAscii >= Character("a").asciiValue! && currAscii <= Character("z").asciiValue! {
                    collected.insert(curr)
                }

                if collected == toFind {
                    if state.pathCount + 1 < currentBest {
                        print("collected all \(state.pathCount + 1)")
                    }
                    currentBest = min(state.pathCount + 1, currentBest)

                    continue
                }

                let prio = 1
//                state.pathCount + (keyPositions.count - collected.count) * 1

                let nextState = State(current: nextPoint,
                                      before: state.current,
                                      collected: collected,
                                      priority: prio,
                                      pathCount: state.pathCount + 1,
                                      didCollect:  collected.count > state.collected.count)
                if let prev = seen[nextState] {
                    if prev < nextState.pathCount {
                        continue
                    }
                }
                seen[nextState] = nextState.pathCount

                states.insert(nextState)

            }
            i += 1
        }
        return currentBest
//        print(currentBest)
    }

    func findLabels(yRange: Range<Int>, xRange: Range<Int>) -> Set<Character> {
        let lowerA = Character("a").asciiValue!
        let lowerZ = Character("z").asciiValue!
        let upperA = Character("A").asciiValue!
        let upperZ = Character("Z").asciiValue!

        var foundUpper: Set<Character> = []
        var foundLower: Set<Character> = []
        for y in yRange {
            for x in xRange {
                let val = input[y][x]
                if val.asciiValue! >= lowerA && val.asciiValue! <= lowerZ {
                    foundLower.insert(val)
                } else if val.asciiValue! >= upperA && val.asciiValue! <= upperZ {
                    foundUpper.insert(val)
                }
            }
        }
        return foundLower
    }



    func runPart2() throws {
        print(startPoints)
        let labels: [Set<Character>] = (0..<4).map {
            switch $0 {
            case 0: return findLabels(yRange: 0..<startPoints[0].y, xRange: 0..<startPoints[0].x)
            case 1: return findLabels(yRange: 0..<startPoints[1].y, xRange: startPoints[1].x..<input[0].count)
            case 2: return findLabels(yRange: startPoints[2].y..<input.count, xRange: 0..<startPoints[2].x)
            case 3: return findLabels(yRange: startPoints[3].y..<input.count, xRange: startPoints[3].x..<input[0].count)
            default: fatalError()
            }
        }
        var res = 0
        for (idx, bot) in startPoints.enumerated() {
            print("Running for bot \(idx)")
            let curr = runDijkstra(startPoint: bot, toFind: labels[idx])
            res += curr
        }
        print(res)

        return
    }
}

extension Point2D {
    static func adjacentOffsets() -> [Point2D] {
        [Point2D(x: 1, y: 0), Point2D(x: -1, y: 0), Point2D(x: 0, y: 1), Point2D(x: 0, y: -1)]
    }

    func adjacentPoints() -> [Point2D] {
        Self.adjacentOffsets()
            .map { self.adding(other: $0) }
    }

    func adding(other: Point2D) -> Point2D {
        Point2D(x: x + other.x, y: y + other.y)
    }
}

struct DoorKey: OptionSet, Hashable {
    let rawValue: UInt32

    private static let lowerA = Int(Character("a").asciiValue!)

    static let a = DoorKey(rawValue: 1 << 0)
    static let b = DoorKey(rawValue: 1 << 1)
    static let c = DoorKey(rawValue: 1 << 2)
    static let d = DoorKey(rawValue: 1 << 3)
    static let e = DoorKey(rawValue: 1 << 4)
    static let f = DoorKey(rawValue: 1 << 5)
    static let g = DoorKey(rawValue: 1 << 6)
    static let h = DoorKey(rawValue: 1 << 7)
    static let i = DoorKey(rawValue: 1 << 8)
    static let j = DoorKey(rawValue: 1 << 9)
    static let k = DoorKey(rawValue: 1 << 10)
    static let l = DoorKey(rawValue: 1 << 11)
    static let m = DoorKey(rawValue: 1 << 12)
    static let n = DoorKey(rawValue: 1 << 13)
    static let o = DoorKey(rawValue: 1 << 14)
    static let p = DoorKey(rawValue: 1 << 15)
    static let q = DoorKey(rawValue: 1 << 16)
    static let r = DoorKey(rawValue: 1 << 17)
    static let s = DoorKey(rawValue: 1 << 18)
    static let t = DoorKey(rawValue: 1 << 19)
    static let u = DoorKey(rawValue: 1 << 20)
    static let v = DoorKey(rawValue: 1 << 21)
    static let w = DoorKey(rawValue: 1 << 22)
    static let x = DoorKey(rawValue: 1 << 23)
    static let y = DoorKey(rawValue: 1 << 24)
    static let z = DoorKey(rawValue: 1 << 25)

    static let result: DoorKey = [.a, .b, .c, .d, .e, .f, .g, .h, .i, .j, .k, .l, .m, .n, .o, .p, .q, .r, .s, .t, .u, .v, .w, .x, .y, .z]
}

extension DoorKey {
    init(char: Character) {
        let ascii = Int(char.asciiValue!)
        self.init(rawValue: 1 << (ascii - Self.lowerA) )
    }
}
