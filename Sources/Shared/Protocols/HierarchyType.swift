import Foundation

/**
 Anything that supports hierarchy, say subclassing
*/
public protocol HierarchyType {

  /**
   Return a corresponding subclass
  */
  static func cluster(map: [String : AnyObject]) -> AnyObject
}
