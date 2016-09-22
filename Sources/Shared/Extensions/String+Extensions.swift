#if os(OSX)
  import Cocoa
#else
  import UIKit
#endif

extension String {

  func split(delimiter: String) -> [String] {
    let components = componentsSeparatedByString(delimiter)
    return components != [""] ? components : []
  }

  func contains(find: String) -> Bool {
    return rangeOfString(find) != nil
  }
}
