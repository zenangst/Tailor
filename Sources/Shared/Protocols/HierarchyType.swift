/**
 Anything that supports hierarchy, say subclassing
*/
public protocol HierarchyType {

  /**
   Return a corresponding subclass
  */
  static func cluster(_ map: [String : Any]) -> AnyObject
}
