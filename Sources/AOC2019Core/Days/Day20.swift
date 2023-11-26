import Foundation

class Day20: Day {

    var day: Int { 20 }
    let input: Set<Point2D>
    let start: Point2D
    let finish: Point2D
    let portals: [Point2D: Point2D]

    let portalNames: [Point2D: Character]

    let outerPortals: [Point2D: Point2D]
    let innerPortals: [Point2D: Point2D]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
            inputString = """


             Z B C D       E
  ###########.#.#.#.#######.###############
  #...#.......#.#.......#.#.......#.#.#...#
  ###.#.#.#.#.#.#.#.###.#.#.#######.#.#.###
  #.#...#.#.#...#.#.#...#...#...#.#.......#
  #.###.#######.###.###.#.###.###.#.#######
  #...#.......#.#...#...#.............#...#
  #.#########.#######.#.#######.#######.###
  #...#.#    F       G H       I    #.#.#.#
  #.###.#                           #.#.#.#
  #.#...#                           #...#.#
  #.###.#                           #.###.#
  #.#....J                         D..#.#..I
  #.###.#                           #.#.#.#
 K......#                           #.....#
  #######                           #######
  #.#....E                          #......H
  #.###.#                           #.###.#
  #.....#                           #...#.#
  ###.###                           #.#.#.#
 L....#.#                          M..#.#.#
  #####.#                           #######
  #......K                         N..#...#
  ###.#.#                           #.###.#
 G....#.#                           #......M
  ###.###                           #.#.#.#
  #.....#        L   C       B      #.#.#.#
  ###.###########.###.#######.#########.###
  #.....#...#.....#.......#...#.....#.#...#
  #####.#.###.#######.#######.###.###.#.#.#
  #.......#.......#.#.#.#.#...#...#...#.#.#
  #####.###.#####.#.#.#.#.###.###.#.###.###
  #.......#.....#.#...#...............#...#
  #############.#.#.###.###################
               A J F   N


"""
        } else {
            inputString = try InputGetter.getInput(for: 20, part: .first)
        }
        var portalsLookup: [Character: [Point2D]] = [:]
        var input: Set<Point2D> = []
        for (y, row) in inputString.split(separator: "\n").enumerated() {
            for (x, char) in row.enumerated() where char == "." {
                if char == "." {
                    input.insert(Point2D(x: x, y: y))
                    continue
                }
            }
        }
        let minX = input.map(\.x).min()!
        let maxX = input.map(\.x).max()!
        let minY = input.map(\.y).min()!
        let maxY = input.map(\.y).max()!

        for (y, row) in inputString.split(separator: "\n").enumerated() {
            for (x, char) in row.enumerated() where (char.asciiValue! >= Character("A").asciiValue!  && char.asciiValue! <= Character("Z").asciiValue!) || (char.asciiValue! >= Character("a").asciiValue!  && char.asciiValue! <= Character("z").asciiValue!) {
                for offset in Point2D.adjacentOffsets() {
                    if input.contains(Point2D(x: x + offset.x, y: y + offset.y)) {
                        portalsLookup[char, default: []].append(Point2D(x: x + offset.x, y: y + offset.y))
                    }
                }
            }
        }

        var portals: [Point2D: Point2D] = [:]
        var portalNames: [Point2D: Character] = [:]
        var start: Point2D!
        var finish: Point2D!
        for element in portalsLookup {
            if element.key == "A" {
                assert(element.value.count == 1)
                start = element.value[0]
            } else if element.key == "Z" {
                assert(element.value.count == 1)
                finish = element.value[0]
            } else {
                assert(element.value.count == 2)
                portals[element.value[0]] = element.value[1]
                portals[element.value[1]] = element.value[0]
                portalNames[element.value[0]] = element.key
                portalNames[element.value[1]] = element.key
            }
        }

        var outerPortals: [Point2D: Point2D] = [:]
        var innerPortals: [Point2D: Point2D] = [:]

        for portal in portals {
            if portal.key.x == maxX || portal.key.x == minX || portal.key.y == maxY || portal.key.y == minY {
                outerPortals[portal.key] = portal.value
                innerPortals[portal.value] = portal.key
            }
        }

        self.input = input
        self.portals = portals
        self.start = start
        self.finish = finish

        self.outerPortals = outerPortals
        self.innerPortals = innerPortals
        self.portalNames = portalNames
    }

    func runPart1() throws {
        var states = [start]
        var seen: Set<Point2D> = []
        var i = 0
        while !states.isEmpty {
            var temp: [Point2D] = []
            print("iteration \(i), \(states.count)")
            for state in states {
                if state == finish {
                    print("Found after \(i)")
                    return
                }
                for adj in state.adjacentPoints() {
                    guard input.contains(adj) else { continue }
                    guard !seen.contains(adj) else { continue }
                    seen.insert(adj)
                    temp.append(adj)
                }
                if let next = portals[state] {
                    guard !seen.contains(next) else { continue }
                    seen.insert(next)
                    temp.append(next)
                }
            }
            states = temp
            i += 1
        }
        fatalError()
    }

    var seen: [Set<Point2D>] = [[]]

    struct Path: Hashable {
        let start: Character
        let end: Character
    }

    struct State: Hashable {
        let curr: Point2D
        let level: Int
        let path: [Point2D]
    }

    func runPart2() throws {
        var states = [State(curr: start, level: 0, path: [])]
        var seen: [Int: Set<Point2D>] = [:]
        var i = 0
        while !states.isEmpty {
            var temp: [State] = []
            print("iteration \(i), \(states.count)")
            for state in states {
                if state.curr == finish && state.level == 0 {
                    print("Found after \(i)")
                    return
                }
                for adj in state.curr.adjacentPoints() {
                    guard input.contains(adj) else { continue }
                    guard !seen[state.level, default: []].contains(adj) else { continue }
                    seen[state.level, default: []].insert(adj)
                    temp.append(State(curr: adj, level: state.level, path: state.path + [adj]))
                }

                if state.level != 0, let next = outerPortals[state.curr] {
                    if !seen[state.level - 1, default: []].contains(next) {
                        let state = State(curr: next, level: state.level - 1, path: state.path + [next])
                        temp.append(state)
                    }
                }
                if let next = innerPortals[state.curr] {
                    if !seen[state.level + 1, default: []].contains(next) {
                        let state = State(curr: next, level: state.level + 1, path: state.path + [next])
                        temp.append(state)
                    }
                }
            }
            states = temp
            i += 1
        }
    }
}
