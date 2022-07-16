protocol FlyerDecoder {
    // The name of our Core Data Entity
    static var EntityName: String { get }
   
}

 
enum SerializationError: Error {

     // We only support structs

     case structRequired

     // The entity does not exist in the Core Data Model

     case unknownEntity(name: String)

     // The provided type cannot be stored in core data

     case unsupportedSubType(label: String?)

}


extension FlyerDecoder {
   
     func toCoreData(context: NSManagedObjectContext) throws -> NSManagedObject {

         let entityName = type(of:self).EntityName



         // Create the Entity Description

         guard let desc = NSEntityDescription.entity(forEntityName: entityName, in: context)

         else { throw SerializationError.unknownEntity(name: entityName)}



         // Create the NSManagedObject

         let managedObject = NSManagedObject(entity: desc, insertInto: context)



         // Create a Mirror

         let mirror = Mirror(reflecting: self)



         // Make sure we're analyzing a struct

         guard mirror.displayStyle == .struct else { throw SerializationError.structRequired }



         for case let (label?, anyValue) in mirror.children {

             managedObject.setValue(anyValue, forKey: label)

         }



         return managedObject

     }

}
