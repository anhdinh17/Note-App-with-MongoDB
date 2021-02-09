//
//  APIFunctions.swift
//  Note-App
//
//  Created by Anh Dinh on 1/26/21.
//

import Foundation
import Alamofire

// This struct is how we want to save data from raw data
struct Note: Decodable {
    
    var title: String?
    var date: String?
    var _id: String
    var note: String?
    
    
}

class APIFunctions {
    
    var delegate: DataDelegate?
    
    static let functions = APIFunctions() // Singleton
    
    func fetchNotes(){
        
        // we gonna make request to this server and we want the response
        AF.request("http://192.168.1.105:8081/fetch").response { (response) in
            // print the data from the fetch route we created
            print(response.data)
            
            // convert data into String so that we can parse
            let data = String(data: response.data!, encoding: .utf8)
            
            // whatever set itself a delegate of APIFunctions will execute this line
            self.delegate?.updateArray(newArray: data!)
            
        }
        
    }
    
    // Add Notes function
    func addNote(date:String, title: String, note: String){
        
        // This one is to create a note, just like what we do with Postman when we want to create a note
        // we go to the server /create route
        // .post means this one is used to post data
        // "title", "date", "note" headers are just like when we create data from postman, we have to create those keys
        AF.request("http://192.168.1.105:8081/create", method: .post, encoding: URLEncoding.httpBody,headers: ["title": title, "date": date, "note": note]).responseJSON { (response) in
            print("Response from addNote: \(response)")
        }
        
    }
    
    // Update Notes function
    func updateNote(date:String, title: String, note: String,id: String){
        
        // This is to update the same note without creating a new note
        // because we set the /update route with express
        AF.request("http://192.168.1.105:8081/update", method: .post, encoding: URLEncoding.httpBody,headers: ["title": title, "date": date, "note": note,"id": id]).responseJSON { (response) in
            print("Response from updateNote: \(response)")
        }
        
        
    }
    
    
    func deleteNote(id: String){

        AF.request("http://192.168.1.105:8081/delete", method: .post, encoding: URLEncoding.httpBody,headers: ["id": id]).responseJSON { (response) in
            print("Response from updateNote: \(response)")
        }
        
        
    }
    
    
}








