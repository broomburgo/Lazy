/// Simple redeclaration of some of the Swift's compositional functions on sequences, but lazy

import Foundation

/// empty sequence
public func empty <A> () -> SequenceOf<A> {
    return SequenceOf(GeneratorOfOne(nil))
}

/// adds to sequences: during generation, after generating the first, it starts with the second
public func + <T> (lhs: SequenceOf<T>, rhs: SequenceOf<T>) -> SequenceOf<T> {
    return SequenceOf { _ -> GeneratorOf<T> in
        var leftGenerator = lhs.generate()
        var rightGenerator = rhs.generate()
        return GeneratorOf {
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
public func elementAtIndex <T> (sequence: SequenceOf<T>, index: Int) -> T? {
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
public func mapLazy <T,U> (sequence: SequenceOf<T>, change: T -> U) -> SequenceOf<U> {
    var generator = sequence.generate()
    return SequenceOf {
        return GeneratorOf {
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
public func filterLazy <T> (sequence: SequenceOf<T>, check: T -> Bool) -> SequenceOf<T> {
    var generator = sequence.generate()
    return SequenceOf {
        return GeneratorOf {
            return nextElementPassingCheck(generator, check)
        }
    }
}

///MARK: - internal
func nextElementPassingCheck<T> (var generator: GeneratorOf<T>, check: T -> Bool) -> T? {
    if let nextElement = generator.next() {
        if check(nextElement) {
            return nextElement
        }
        else {
            return nextElementPassingCheck(generator, check)
        }
    }
    else {
        return nil
    }
}
