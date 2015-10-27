/// Simple redeclaration of some of the Swift's compositional functions on sequences, but lazy

import Foundation

public extension SequenceType
{
  /// empty sequence
  public static func empty () -> AnySequence<Generator.Element>
  {
    return AnySequence { anyGenerator { nil } }
  }
    
  /// currently (Swift 2.1) 'map' on Sequence generates an Array
  public func mapLazy <T> (change: Generator.Element -> T) -> AnySequence<T>
  {
    var generator = generate()
    return AnySequence { anyGenerator { generator.next().map(change) } }
  }
  
  /// this generates a new Sequence with equal or lower count than the original one
  public func filterLazy (check: Generator.Element -> Bool) -> AnySequence<Generator.Element>
  {
    let generator = generate()
    return AnySequence { anyGenerator { nextElementPassingCheck(generator, check) } }
  }
}

/// adds to sequences: during generation, after generating the first, it starts with the second
public func + <T> (lhs: AnySequence<T>, rhs: AnySequence<T>) -> AnySequence<T>
{
  let leftGenerator = lhs.generate()
  let rightGenerator = rhs.generate()
  return AnySequence { anyGenerator { leftGenerator.next() ?? rightGenerator.next() } }
}

/// reducer to generate a sequence by reducing a SequenceType
public func anySequenceReducer<T> () -> (AnySequence<T>, T) -> AnySequence<T>
{
  return { accumulator, element in
    return AnySequence(accumulator) + AnySequence { GeneratorOfOne (element) }
  }
}

///MARK: - internal
func nextElementPassingCheck <G: GeneratorType, T where T == G.Element> (var generator: G, _ check: T -> Bool) -> T?
{
  return generator.next().flatMap { check($0) ? $0 : nextElementPassingCheck(generator, check) }
}
