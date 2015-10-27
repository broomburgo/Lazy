import UIKit
import XCTest

@testable import Lazy

class LazyTests: XCTestCase
{
  var sequence1 = AnySequence<Int>.empty()
  var sequence2 = AnySequence<Int>.empty()
  
  override func setUp() {
    super.setUp()
    
    var index1 = 0
    let maxIndex1 = 10
    sequence1 = AnySequence {
      anyGenerator {
        let currentIndex = index1
        index1 += 1
        return currentIndex < maxIndex1 ? currentIndex : nil
      }
    }
    
    var index2 = 0
    let maxIndex2 = 10
    sequence2 = AnySequence {
      anyGenerator {
        let currentIndex = index2
        index2 += 1
        return currentIndex < maxIndex2 ? currentIndex : nil
      }
    }

  }
  
  func testEmptySequence()
  {
    let emptySequence = AnySequence<Int>.empty()
    for _ in emptySequence
    {
      XCTAssertTrue(false)
    }
  }
  
  func testMapLazy()
  {
    let sequenceOfHundreds = sequence1.mapLazy { $0*100 }
    let arrayOfHundreds = Array(sequenceOfHundreds)
    let expectedArrayOfHundreds = [0,100,200,300,400,500,600,700,800,900]
    XCTAssertEqual(arrayOfHundreds, expectedArrayOfHundreds)
  }
  
  func testFilterLazy()
  {
    let sequenceOfEvens = sequence1.filterLazy { $0%2 == 0 }
    let arrayOfEvens = Array(sequenceOfEvens)
    let expectedArrayOfEvens = [0,2,4,6,8]
    XCTAssertEqual(arrayOfEvens, expectedArrayOfEvens)
  }
  
  func testAdd()
  {
    let sequenceOfEvens = sequence1.filterLazy { $0%2 == 0 }
    let sequenceOfOdds = sequence2.filterLazy { $0%2 != 0 }
    let summedSequence = sequenceOfEvens + sequenceOfOdds
    let summedArray = Array(summedSequence)
    let expectedSummedArray = [0,2,4,6,8,1,3,5,7,9]
    XCTAssertEqual(summedArray, expectedSummedArray)
  }
  
  func testReducer()
  {
    let array1 = [0,1,2,3,4,5,6,7,8,9]
    let reducedSequence = array1.reduce(AnySequence<Int>.empty(), combine: anySequenceReducer())
    let array2 = Array(reducedSequence)
    XCTAssertEqual(array1, array2)
  }
}







