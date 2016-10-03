import XCTest
import Tailor

struct Book: Mappable {
  let name: String
  let pageCount: Int
  let website: URL?

  init(_ map: [String : Any]) {
    name = <?map.property("name")
    pageCount = <?map.property("page_count")
    website = map.transform("website_url", transformer: URL.init(string: ))
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
    ] as [String : Any]

    let book = Book(json as [String : Any])
    XCTAssertEqual(book.name, "Advanced Swift")
    XCTAssertEqual(book.pageCount, 400)
    XCTAssertEqual(book.website, URL(string: "https://www.objc.io/books/advanced-swift/"))
  }
}
