import XCTest
import Tailor
import Sugar

struct Book: Mappable {
  let name: String
  let pageCount: Int
  let website: NSURL?

  init(_ map: JSONDictionary) {
    name = <?map.property("name")
    pageCount = <?map.property("page_count")
    website = map.transform("website_url", transformer: NSURL.init(string: ))
  }
}

class TestDefaultType: XCTestCase {
  func testOperator() {
    let string = <?(nil as String?)
    XCTAssertEqual(string, "")

    let int = <?(nil as Int?)
    XCTAssertEqual(int, 0)
  }

  func testDefaultType() {
    let json = [
      "name": "Advanced Swift",
      "page_count": 400,
      "website_url": "https://www.objc.io/books/advanced-swift/"
    ]

    let book = Book(json)
    XCTAssertEqual(book.name, "Advanced Swift")
    XCTAssertEqual(book.pageCount, 400)
    XCTAssertEqual(book.website, NSURL(string: "https://www.objc.io/books/advanced-swift/"))
  }
}
