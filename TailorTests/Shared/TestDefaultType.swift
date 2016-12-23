import Tailor
import Quick
import Nimble


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

class TestDefaultType: QuickSpec {

    override func spec() {

        describe("operator") {

            context("string") {
                var string: String!

                beforeEach {
                    string = <?(nil as String?)
                }

                it("is equal to empty string") {
                    expect(string).to(equal(""))
                }

            }

            context("int") {
                var int: Int!

                beforeEach {
                    int = <?(nil as Int?)
                }

                it("is equal to 0") {
                    expect(int).to(equal(0))
                }

            }

        }

        describe("default type") {
            var json: [String : Any]!
            var book: Book!

            beforeEach {
                json = [
                    "name": "Advanced Swift",
                    "page_count": 400,
                    "website_url": "https://www.objc.io/books/advanced-swift/"
                ]
                book = Book(json)
            }

            it("has the correct name") {
                expect(book.name).to(equal("Advanced Swift"))
            }

            it("has the correct page count") {
                expect(book.pageCount).to(equal(400))
            }

            it("has the correct website") {
                expect(book.website).to(equal(URL(string: "https://www.objc.io/books/advanced-swift/")))
            }
        }
    }
}
