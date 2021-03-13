//
//  DataManager.swift
//  AFTest
//
//  Created by Anh Dinh on 3/12/21.
//

import Foundation
import Alamofire

class DataManager {
    
    var dataArray = [DataStruct]()
    
    static let shared = DataManager()
    
    //https://raw.githubusercontent.com/AxxessTech/Mobile-Projects/master/challenge.json
    public func fetchData(){
        AF.request("https://raw.githubusercontent.com/AxxessTech/Mobile-Projects/master/challenge.json").response{ response in
            
            //print(response.data)
            let data = String(data: response.data!, encoding: .utf8)
            //print(data)
            
            do{
                self.dataArray = try JSONDecoder().decode([DataStruct].self, from: (data?.data(using:.utf8)!)!)
                
                print(self.dataArray)
            }catch{
                print("Failed to decode: \(error)")
            }
        }
    }
    
    public func fetchData2(){
        AF.request("https://raw.githubusercontent.com/AxxessTech/Mobile-Projects/master/challenge.json").responseJSON { (response) in
            //print(response)
            
            let data = response.data
            
            do{
                self.dataArray = try JSONDecoder().decode([DataStruct].self, from: data!)
                
                print(self.dataArray)
            }catch{
                print("Failed to decode: \(error)")
            }
        }
        
    }
    
}
