import Foundation
import Sugar

/**
 Anything that supports hierarchy, say subclassing
*/
public protocol HierarchyType {

  /**
   Return a corresponding subclass
  */
  static func cluster(map: JSONDictionary) -> AnyObject
}
