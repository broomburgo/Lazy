/// Simple redeclaration of some of the Swift's compositional functions on sequences, but lazy

import Foundation

/// empty sequence
public func empty <A> () -> AnySequence<A> {
    return AnySequence(GeneratorOfOne(nil))
}

/// adds to sequences: during generation, after generating the first, it starts with the second
public func + <T> (lhs: AnySequence<T>, rhs: AnySequence<T>) -> AnySequence<T> {
    return AnySequence { _ -> AnyGenerator<T> in
        let leftGenerator = lhs.generate()
        let rightGenerator = rhs.generate()
        return anyGenerator {
            if let left = leftGenerator.next() {
                return left
            }
            else if let right = rightGenerator.next() {
                return right
            }
            else {
                return nil
            }
        }
    }
}

/// find an element at a certain index, without generating the whole sequence
public func elementAtIndex <T> (sequence: AnySequence<T>, index: Int) -> T? {
    var count = 0
    for element in sequence {
        if count == index {
            return element
        }
        count += 1
    }
    return nil
}

/// currently (Swift 1.2) 'map' on Sequence generates an Array
public func mapLazy <T,U> (sequence: AnySequence<T>, change: T -> U) -> AnySequence<U> {
    let generator = sequence.generate()
    return AnySequence {
        return anyGenerator {
            if let nextElement = generator.next() {
                return change(nextElement)
            }
            else {
                return nil
            }
        }
    }
}

/// this generates a new Sequence with equal of lower count than the original one
public func filterLazy <T> (sequence: AnySequence<T>, _ check: T -> Bool) -> AnySequence<T> {
    let generator = sequence.generate()
    return AnySequence {
        return anyGenerator {
            return nextElementPassingCheck(generator, check: check)
        }
    }
}

///MARK: - internal
func nextElementPassingCheck<T> (generator: AnyGenerator<T>, check: T -> Bool) -> T? {
    if let nextElement = generator.next() {
        if check(nextElement) {
            return nextElement
        }
        else {
            return nextElementPassingCheck(generator, check: check)
        }
    }
    else {
        return nil
    }
}
