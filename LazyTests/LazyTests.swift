import UIKit
import XCTest

@testable import Lazy

class LazyTests: XCTestCase
{
  var sequence = AnySequence<Int>.empty()
  
  override func setUp() {
    super.setUp()
    
    var index = 0
    let maxIndex = 10
    sequence = AnySequence {
      anyGenerator {
        let currentIndex = index
        index += 1
        return currentIndex < maxIndex ? currentIndex : nil
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
    let sequenceOfHundreds = sequence.mapLazy { $0*100 }
    let arrayOfHundreds = Array(sequenceOfHundreds)
    let expectedArrayOfHundreds = [0,100,200,300,400,500,600,700,800,900]
    XCTAssertEqual(arrayOfHundreds, expectedArrayOfHundreds)
  }
  
  func testFilterLazy()
  {
    let sequenceOfEvens = sequence.filterLazy { $0%2 == 0 }
    let arrayOfEvens = Array(sequenceOfEvens)
    let expectedArrayOfEvens = [0,2,4,6,8]
    XCTAssertEqual(arrayOfEvens, expectedArrayOfEvens)
  }
}
