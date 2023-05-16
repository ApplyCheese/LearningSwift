//
//  Jsonable.swift
//  Test_ScatterManager
//
//  Created by Todd Sleeman on 1/21/23.
//

import Foundation
import SwiftUI // CGImage
import CryptoKit


/// Tuple with the Function called and the Error thrown.
struct Error_Detailed: Error{
    var errors: (fuction: Error, Swift: Error)
}


fileprivate enum ErrorCodes: Error{
    case error_getDataFromURL
    case error_decodeDataTo
    case error_encodeDataToJsonString
    case error_WriteJsonStringToFile
    case error_getURLofMainBundleAsset
    case error_JSONassetToData
    
    func withSwiftError(_ swiftError: Error) -> Error_Detailed{
        switch self {
            
        case .error_getDataFromURL:
            return Error_Detailed(errors: (jsonCraftingError.error_getDataFromURL, swiftError))
        case .error_decodeDataTo:
            return Error_Detailed(errors: (jsonCraftingError.error_decodeDataTo, swiftError))
        case .error_encodeDataToJsonString:
            return Error_Detailed(errors: (fuction: jsonCraftingError.error_encodeDataToJsonString, Swift: swiftError))
        case .error_WriteJsonStringToFile:
            return Error_Detailed(errors: (fuction: jsonCraftingError.error_WriteJsonStringToFile, Swift: swiftError))
        case .error_getURLofMainBundleAsset:
            return Error_Detailed(errors: (fuction: jsonCraftingError.error_getURLofMainBundleAsset, Swift: swiftError))
        case .error_JSONassetToData:
            return Error_Detailed(errors: (fuction: jsonCraftingError.error_JSONassetToData, Swift: swiftError))
        } // switch
    } // withSwiftError
} // ErrorCodes


fileprivate enum jsonCraftingError: Error{
    
    case error_getDataFromURL
    case error_decodeDataTo
    case error_encodeDataToJsonString
    case error_WriteJsonStringToFile
    case error_getURLofMainBundleAsset
    case error_Nil_FileNotLocated
    case error_JSONassetToData
} // jsonCraftingError

@MainActor
enum JsonCraft {
    
    // MARK: GET URL MAIN BUNDLE ASSET
    /// Returns the file URL for the resource identified by the specified name and file extension.
    ///  - Parameters:
    ///     - assets: name and file extension of main bundle assets
    ///     - Return: Result<URL,Error_Detailed>
    static func getURLofMainBundleAsset(asset: String, completion: (Result<URL, Error_Detailed>) -> ()){
        // MainBundleFiles.basicAppData.rawValue
      
        guard let url = Bundle.main.url(forResource: asset, withExtension: nil)
        else {
            return completion(.failure(Error_Detailed(errors: (fuction: jsonCraftingError.error_getURLofMainBundleAsset, Swift: jsonCraftingError.error_Nil_FileNotLocated ))))
        }
        completion(.success(url))
    }
    
    // MARK: JSON ASSET TO DATA
    /// Returns an Asset from the main bundle decoded as the passed in Type.
    /// - Parameters:
    ///    - dataType: Type that the JSON object comforms to.
    ///    - assets: name and file extension of main bundle assets
    ///    - Return: Result<DecodedData, Error_Detailed>
    static func jsonAssetToData<T: Decodable>(_ dataType: T.Type, asset: String, completion: (Result<T, Error_Detailed>) -> ()){
        var url: URL = URL.defaultValue
        var data: Data = Data()
        
        JsonCraft.getURLofMainBundleAsset(asset: asset) { result in
            switch result{
            case .success(let captured_Url):
                url = captured_Url
            case .failure(let error):
               return completion(.failure(error))
                
            } // result
        } // getURLofMainBundleAsset
        
        
        JsonCraft.getDataFromURL(url: url) { result in
            switch result{
            case .success(let captured_Data):
                data = captured_Data
            case .failure(let error):
               return completion(.failure(error))
            } // switch
        } // getDataFromURL
       
        JsonCraft.decodeDataTo(dataType, data) { result in
            switch result{
            case .success(let captured_DecodedData):
                return completion(.success(captured_DecodedData))
            case .failure(let error):
                return completion(.failure(error))
            } // switch
        } // decodeDataTo
        
    } // jaonAssetToData
    
    
    // MARK: GET DATA FROM URL
    /// Returns result <data, Error_Detailed>.  Data is A byte buffer in memory.
     /// - Parameters:
    ///    - url: URL of JSON file to load contents of into memory.
     ///   - completion: a Result providing the Data or Error_Detailed
    static func getDataFromURL(url fileURL: URL, completion: (Result<Data, Error_Detailed>) -> ()){
        
        let data : Data
        // load data to memory.
        do{
        data = try Data(contentsOf: fileURL)
        return completion( .success(data))
        }
        catch {
            return completion(.failure(ErrorCodes.error_getDataFromURL.withSwiftError(error)))
        } // catch
       
        } // getDatafromURL
      
    
    // MARK: DECODE DATA TO
    ///  Returns a value of the type you specify, decoded from a JSON object. By: Decoding data from memory and Loading it as the passed in Type.
    ///  - Parameters:
    ///     - T: The type of the value to decode from the supplied JSON object. AKA Data Type the JSON object conforms to.
    ///     - data: The JSON object to decode. Data is A byte buffer in memory.
    ///     - Returns: Result<Data, Error_Detailed>.
    static func decodeDataTo<T: Decodable>(_ t: T.Type, _ data: Data, completion: (Result<T, Error_Detailed>) -> ()){
        
        do {
            
            let decoder = JSONDecoder()
            let myTypeOfData = try decoder.decode(T.self, from: data) // load data from memory into struct data model
            return completion(.success(myTypeOfData))
            
        } catch {
            
            return completion(.failure(ErrorCodes.error_decodeDataTo.withSwiftError(error)))
            
        } // catch
        
    } // decodeDataTo
    
    
    // MARK: LOAD DATA
    ///  This func takes in any Struct Type and a conforming JSON file's URL.
    ///  Decodes & Loads, contents of file into memory as the passed in Type.
    /// - Parameters:
    ///     - t: Generic Data Type
    ///     - url: Conforming JSON file's URL
    ///     - Return: Result<Generic, Error_Detailed>
    static func loadData<T: Decodable>(_ t: T.Type, url fileURL: URL, completion: (Result<T,Error_Detailed>)-> ()){
        
        var urlData: Data = Data()
        
        JsonCraft.getDataFromURL(url: fileURL){ result in
            
            switch result {
                
            case .success(let urldata):
                urlData = urldata
            case .failure(let error):
                return completion(.failure(error))
                
            } // switch

        } // getDatafromUrl
        
        JsonCraft.decodeDataTo(t, urlData) { result in
           
            switch result {
                
            case .success(let decodeddata):
                completion(.success(decodeddata))
                
            case .failure(let error):
                return completion(.failure(error))
                
            } // switch
            
        } // decodeDataTo
    } // loadData
    
    
    // MARK: ENCODE DATA TO JSON STRING
    static func encodeDataToJsonString<T: Encodable>(data: T, completion: (Result<String, Error_Detailed>) -> ()){
       
       // Declair a Json Encoder
       let encoder = JSONEncoder()
       encoder.outputFormatting = .prettyPrinted // Format output for printing to file.
       
       print("ARC Count :" + CFGetRetainCount(encoder).description)
       
        do{
            
            let encodedData = try encoder.encode(data)
            let encodedString = String(data: encodedData, encoding: .utf8)!
            completion(.success(encodedString))
            
        } catch {
            
            completion(.failure(ErrorCodes.error_encodeDataToJsonString.withSwiftError(error)))
            
        } // catch
       
   } // jsonableEncoderDataToJsonString
    
    
    // MARK: WRITE JSON STRING TO FILE
    static func writeJsonStringToFile(filename: URL, jsonstring: String, completion: (Result<Bool, Error_Detailed>) -> ()){
        
        do {
            
            try jsonstring.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            completion(.success(true))
        } catch {
            
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            print("faile to write file error: " + error.localizedDescription)
            
            completion(.failure(ErrorCodes.error_WriteJsonStringToFile.withSwiftError(error)))
        } // catch
        
    } // jsonableWriteJsonStringToFile
    
    
    // MARK: WRITE DATA TO FILE
    static func writeDataToFile<T: Encodable >(data: T, to fileName:URL, completion: (Result<Bool, Error_Detailed>) -> ()){
        
        var jsonString = String.defaultValue
        
        JsonCraft.encodeDataToJsonString(data: data){ result in
            switch result{
            case .success(let jsonstring):
                jsonString = jsonstring
                
            case .failure(let error):
                return completion(.failure(error))
            }
            
        } // encodeDataToJsonString
        
        JsonCraft.writeJsonStringToFile(filename: fileName, jsonstring: jsonString) { result in
            switch result{
            case .success(let didWrite):
                return completion(.success(didWrite))
            case .failure(let error):
                return completion(.failure(error))
            }
        } //writeJsonStringToFile
        
    } // writeDataToFile
    
} // JsonCraft
    



/// Struct that handles JSON. Read, Write, Convert to Data, Store to Core Data.
struct Jsonable{
    
    /**
     Reads Json file at URL that conforms to the declaired dataModel and returns contents of Json file as datamodel.
     
    CODE EXAMPLE:
     ```
     let someData: [dataModel] = Jsonable.read(url: jsonFileUrl).returnData
     ```
     
     - Warning: Use  ```.returnData```  to get return of <T> data.
     */
    struct read<T: Decodable>{
        
       // let exampleAppData = getDocumentsDirectoryURL().appendingPathComponent(MainBundleFiles.basicAppData.rawValue)
        var returnData: T
        
        /// Return Preview Default Bundle Flyers
        init(){
            
            print("getting read Main Bundle path Jsonable")
            let data: T = jsonableReadMainBundleFileToDeclaredData(Dev_FileAssets.testFlyers.rawValue)
            self.returnData = data
            
        } // init
        
        /// Return Data from URL
        init(url: URL){
            
            print("getting read URL path Jsonable")
            let data = jsonableReadFileToDeclaredData(T.self ,url)
            
            self.returnData = data
            
        } // init
        
    } // read
    
    //TODO: EDIT TO SO IT MAKES NOMEMD5 AUTO FILE NAME (NAFN)
    /**
     Converts data to json string and writes it to FileName.
     
     CODING EXAMPLE:
     ```
     let _ =  Jsonable.write(data: SomeData, url: someUrl)
     ```
     */
    struct write<T: Encodable>{
        
        init(data: T, url: URL){
            
            jsonableWriteDataToJsonFile(data: data, FilePath: url)
        
        } // init
    
    } // write
    
} // Jsonable


//MARK: ERROR KEYS
/// Error options.
fileprivate enum JsonableError: Error {
    
    case failedEncoding
    
} // JsonableError



//MARK: LOAD JSON TO DATA
/**
 Generic that takes in any Decodable data type like a struct data model. Also a conforming json file's URL String and returns a data instance.
 
USAGE OF CODE EXAMPLE:
 ```
 // RETURNING AN ARRAY OF SOME DATA
 let someData: [DontCare_Decodable] = readFileToDeclaredData("FULL_URL.json")
 
 // RETURN AN INSTANCE OF SOME DATA
 let someData: DontCare_Decodable = readFileToDeclaredData("FULL_URL.json")
 ```
 
 - Returns:  <T: Decodable>
 */
fileprivate func jsonableReadFileToDeclaredData<T: Decodable>(_ t: T.Type, _ fileURL: URL) -> T { // Get and Return data from a JSON file.
    let data: Data
    
    do {

        data = try Data(contentsOf: fileURL) // load data to memory.

    } catch {

        fatalError("Couldn't load \(fileURL) from URL:\n\(error)")

    } // catch
    
    
    do {
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data) // load data from memory into struct data model
        
    } catch {
        
        fatalError("Couldn't parse \(fileURL) as \(T.self):\n\(error)")
        
    } // catch
    
} // jsonableReadFileToDeclaredData


/// loads file from URL and returns an MD5 hash of the file.
fileprivate func jsonableMD5from(fileURL: URL) -> String{
    
    let data: Data
    
    do{
        
        data = try Data(contentsOf: fileURL) // load data to memory.
        
    } catch {
        
        fatalError("Couldn't load \(fileURL) from URL:\n\(error)")
        
    } // catch
    
    let digest = Insecure.MD5.hash(data: data)
    print("MD5 : " + digest.description)
    return digest.description
   
    /*
     
     Note: Return digest as String
     
         digest.map {
                 String(format: "%02hhx", $0)
             }.joined()
         }
     
     */
    
} // jsonableMD5from


/**
 Generic that takes in any struct data model and a conforming json file URL String ( IN THE MAIN BUNDLE ONLY ) and returns a data instance.

CODE EXAMPLE:
```
// RETURNING AN ARRAY OF SOME DATA
let someData: [DontCare_Decodable] = readMainBundleFileToDeclaredData("conformingToDontCare_Decodable_DataFile.json")

// RETURN AN INSTANCE OF SOME DATA
let someData: DontCare_Decodable = readMainBundleFileToDeclaredData("conformingToDontCare_Decodable_DataFile.json")
```

- Returns:  <T: Decodable>
*/
fileprivate func jsonableReadMainBundleFileToDeclaredData<T: Decodable>(_ filename: String) -> T { // Get and Return data from a JSON file.
    let data: Data
   // MainBundleFiles.basicAppData.rawValue
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        
       // FileManager.default.contents(atPath: filename)
        fatalError("Couldn't find \(filename) in main bundle.")
        
    } // else
    
    do {
        
        data = try Data(contentsOf: file) // load data to memory.
        
    } catch {
        
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        
    } // catch
    
    do {
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data) // load data from memory into struct data model
        
    } catch {
        
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        
    } // catch
    
} // jsonableReadMainBundleFileToDeclaredData


//MARK: DATA TO JSON STRING
/// Encode any Encodable Data to a Json string.
fileprivate func jsonableEncodeDataToJsonString<T: Encodable>(data: T) throws -> String {
    
    // Declair a Json Encoder
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted // Format output for printing to file.
    
    print("ARC Count :" + CFGetRetainCount(encoder).description)
    
    guard let encodedData = try? encoder.encode(data) else{
        
        // failed to write file
        throw JsonableError.failedEncoding
        
    } // else
    
        let encodedString = String(data: encodedData, encoding: .utf8)!
        return encodedString
    
} // jsonableEncoderDataToJsonString


//MARK: WRITE JSON STRING TO FILE
/// Write Json string to a file.
fileprivate func jsonableWriteJsonStringToFile(filename: URL, jsonstring: String){
  
    do {
        
        try jsonstring.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        
    } catch {
        
        // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        print("faile to write file error: " + error.localizedDescription)
        
    } // catch
    
} // jsonableWriteJsonStringToFile


//MARK: WRITE JSON TO URL
/// Write Data To JSON File URL.
fileprivate func jsonableWriteDataToJsonFile<T: Encodable>(data: T, FilePath: URL){
    
    do{
        
        let dataAsJsonString = try jsonableEncodeDataToJsonString(data: data)
        jsonableWriteJsonStringToFile(filename: FilePath, jsonstring: dataAsJsonString)
        
    }catch{
        
        print("Failed writeDataToJsonFile: DataToJson \(error.localizedDescription) ")
        
    } // catch
    
} // jsonableWriteDataToJsonFile


//MARK: STRING TO IMAGE
/// Image Store Class to convert a string to Image and access main bundle png images.
final class ImageStore {
    
    typealias _ImageDictionary = [String: CGImage]
    fileprivate var images: _ImageDictionary = [:]
    fileprivate static var scale = 2
    static var shared = ImageStore()
    
    func image(name: String) -> Image {
        
        let index = _guaranteeImage(name: name)
        
        return Image(images.values[index], scale: CGFloat(ImageStore.scale), label: Text(verbatim: name))
        
    } // image
    
    /// Load image from Main Bundle. .png
    static func loadImage(name: String) -> CGImage {
        
        guard
            
            //let url = Bundle.main.url(forResource: name, withExtension: "jpg"),
            let url = Bundle.main.url(forResource: name, withExtension: "png"),
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
                
        else {
            
            fatalError("Couldn't load image \(name).png from main bundle.")
            
        } // else
        
        return image
        
    } // loadImage
    
    fileprivate func _guaranteeImage(name: String) -> _ImageDictionary.Index {
        
        if let index = images.index(forKey: name) { return index }
        
        images[name] = ImageStore.loadImage(name: name)
        
        return images.index(forKey: name)!
        
    } // _guarnteeImage
    
}// End Final class ImageStore
