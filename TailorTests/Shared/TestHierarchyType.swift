import Quick
import Nimble
import Tailor

class Event: Mappable {
  var name: String = ""

  required init(_ map: [String : Any]) {
    self.name <- map.property("name")
  }
}

class PushEvent: Event {
  var SHA: String = ""

  required init(_ map: [String : Any]) {
    super.init(map)

    self.SHA <- map.property("sha")
  }
}

class IssueEvent: Event {
  var number: Int = 0

  required init(_ map: [String : Any]) {
    super.init(map)

    self.number <- map.property("number")
  }
}

extension Event: HierarchyType {
  static func cluster(_ map: [String : Any]) -> AnyObject {
    let kinds: [String: Event.Type] = [
      "push": PushEvent.self,
      "issue": IssueEvent.self
    ]

    if let kind = map["type"] as? String, let type = kinds[kind] {
      return type.init(map)
    } else {
      return self.init(map)
    }
  }
}

class Notification: Mappable {
  var events: [Event] = []

  required init(_ map: [String : Any]) {
    self.events <- map.relationsHierarchically("events")
  }
}

class TestHierarchyType: QuickSpec {
    override func spec() {

        describe("hierarchy type") {

            var json: [String : Any]!
            var notification: Notification!
            var issue: IssueEvent!
            var push: PushEvent!

            beforeEach {
                json = [
                    "events": [
                        [
                            "type": "push",
                            "name": "Update README",
                            "sha": "a8037a7bda800c51ee1aae557729a9b16e8e57fe"
                        ],
                        [
                            "type": "issue",
                            "name": "Add HierarchyType",
                            "number": 3
                        ]
                    ]
                ]
                notification = Notification(json as [String : Any])
                push = notification.events[0] as! PushEvent
                issue = notification.events[1] as! IssueEvent
            }

            context("push") {

                it("has the correct push name") {
                    expect(push.name).to(equal("Update README"))
                }

                it("has the correct push SHA") {
                    expect(push.SHA).to(equal("a8037a7bda800c51ee1aae557729a9b16e8e57fe"))
                }

            }

            context("issue") {

                it("has the correct issue name") {
                    expect(issue.name).to(equal("Add HierarchyType"))
                }

                it("has the correct issue number") {
                    expect(issue.number).to(equal(3))
                }

            }

        }

    }
}
