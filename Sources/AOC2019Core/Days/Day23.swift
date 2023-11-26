import Foundation
import Collections

class Day23: Day {
    var day: Int { 23 }
    let input: [Int]

    init(testInput: Bool) async throws {
        let inputString: String

        if testInput {
            inputString = "foo"
        } else {
            inputString = try InputGetter.getInput(for: 23, part: .first)
        }
        self.input = inputString.split(separator: ",").map { Int($0)! }
    }

    // TODO: REFACTOR TO USE ASYNC / AWAIT
    func getMessage(at idx: Int) -> Int {
        let value = messages[idx].popFirst() ?? -1
        let current = CFAbsoluteTimeGetCurrent()
        if current - (lastWrite ?? current) >= 0.05, messages[0].isEmpty {
            lastWrite = nil
            if self.nat.contains(natCache[1]) {
                print(natCache)
                fatalError()
            }
            self.nat.insert(natCache[1])
            messages[0].append(contentsOf: natCache)
//            natCache = []
        }
        return value
    }

    func setMessage(at idx: Int, value: Int) {
        messages[idx].append(value)
        lastWrite = CFAbsoluteTimeGetCurrent()
    }
    
    var lastWrite: CFAbsoluteTime?

    var messages: [Deque<Int>] = (0..<51).map { [$0] }
    var lock: NSLock = .init()
    var nat: Set<Int> = []
    var natCache: [Int] = []
    func runComputers() async {
        await withCheckedContinuation { continuation in
            let programs = (0..<50).map { _ in IntcodeComputer(program: input) }
            var continuing = false
            for (idx, program) in programs.enumerated() {
                DispatchQueue(label: "computer-idx").async {
                    var res: IntcodeComputer.IntCodeReturnType!
                    var values: [Int] = []
                    repeat {
                        res = program.run {
                            self.lock.lock()
                            let value = self.getMessage(at: idx)
                            self.lock.unlock()
                            if value != -1 {
                                print("\(idx) received input \(value)")
                            }

                            return value
                        }
                        switch res {
                        case .output(output: let o):
                            self.lock.lock()
                            if o == 22391 {
                                print("here")
                            }
                            print("\(idx) got output \(o)")
                            values.append(o)
                            if values.count == 3 {
                                if values[0] == 255 {
                                    print(values)
//                                    self.lock.lock()
                                    self.natCache = [values[1], values[2]]
//                                    self.lock.unlock()
                                    values = []
                                } else {
                                    //                                self.lock.lock()
                                    let address = values[0]
                                    self.setMessage(at: address, value: values[1])
                                    self.setMessage(at: address, value: values[2])
                                    values = []
                                }
                            }
                            self.lock.unlock()
                        default:
                            break
                        }
                    } while res != .exitCode
                }
            }
            while !continuing {}
            continuation.resume(returning: "finished")
        }
    }

    func runPart1() async throws {
        await runComputers()
    }

    func runPart2() throws {}
}
