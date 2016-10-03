#if os(OSX)
  import Cocoa
#else
  import UIKit
#endif

extension String {

  func split(_ delimiter: String) -> [String] {
    let components = self.components(separatedBy: delimiter)
    return components != [""] ? components : []
  }

  func contains(_ find: String) -> Bool {
    return range(of: find) != nil
  }
}
