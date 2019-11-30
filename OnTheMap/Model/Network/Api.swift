//
//  Api.swift
//  OnTheMap
//
//  Created by fahad on 17/03/1441 AH.
//  Copyright © 1441 Fahad Albgumi. All rights reserved.
//

import Foundation
class API {
    static private var accountInfo = AccountInfo()
    static var sessionId: String?

    
    static func sessionPost(username:String, password:String , completion: @escaping (String?) -> Void) {
        var errorString: String?
        var request = URLRequest(url: URL(string: APIConstants.SESSION)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let code = (response as? HTTPURLResponse)?.statusCode {
                if code >= 200 && code < 300 {
                    let range: CountableRange = 5..<data!.count
                    let newData = data?.subdata(in: range) /* subset response data! */
                    if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
                        let dict = json as? [String:Any],
                        let sessionDict = dict["session"] as? [String: Any],
                        let accountDict = dict["account"] as? [String: Any]  {
                        self.accountInfo.key = accountDict["key"] as? String // This is used in getUserInfo(completion:)
                        self.sessionId = sessionDict["id"] as? String
                        
                        self.getUserInfo(completion: { err in
                            
                        })
                    } else {
                        errorString = "Cant find response"
                    }
                } else {
                    errorString = "login credintials are not correct"
                }
            } else {
                errorString = "Check your internet connection"
            }
            DispatchQueue.main.async {
                completion(errorString)
            }
            
        }
        task.resume()
    }
    
    static func getUserInfo(completion: @escaping (Error?)->Void) {
        let request = URLRequest(url: URL(string: "\(APIConstants.PUBLIC_USER)\(accountInfo.key ?? "")")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let range: CountableRange = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            do {
                if let json = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as? [String: Any] {
                    self.accountInfo.lastName = json["last_name"] as? String
                    self.accountInfo.firstName = json["first_name"] as? String
                }
            } catch {
                print(error)
            }
//            print(accountInfo)
//            print(self.accountInfo)
        }
        task.resume()
    }
        
    static func getLocations(limit: Int = 100, skip:Int = 0, orderBy: SLParam = .updatedAt, completion: @escaping (LocationsData?) -> Void) {
        guard let url = URL(string: "\(APIConstants.STUDENT_LOCATION)?\(APIConstants.ParameterKeys.LIMIT)=\(limit)&\(APIConstants.ParameterKeys.SKIP)=\(skip)&\(APIConstants.ParameterKeys.ORDER)=-\(orderBy.rawValue)") else {
            completion(nil)
            return
        }
        var studentLocations: [StudentLocation] = []
        var request = URLRequest(url:url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(APIConstants.HeaderValues.PARSE_API_KEY, forHTTPHeaderField: APIConstants.HeaderKeys.PARSE_API_KEY)
        request.addValue(APIConstants.HeaderValues.PARSE_APP_ID, forHTTPHeaderField: APIConstants.HeaderKeys.PARSE_APP_ID)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                if statusCode >= 200 && statusCode < 300 { //Response is ok
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []),
                        let dictionary = json as? [String:Any],
                        let results = dictionary["results"] as? [Any]{
                        for location in results {
                            let data = try! JSONSerialization.data(withJSONObject: location)
                            let studentLocation = try! JSONDecoder().decode(StudentLocation.self, from: data)
                            studentLocations.append(studentLocation)
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                completion(LocationsData(studentLocations: studentLocations))
            }
            
        }
        task.resume()
        
    }
    
    static func postLocation(_ location: StudentLocation, completion: @escaping (String?)->Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print(accountInfo)
        request.httpBody = "{\"uniqueKey\": \"\(accountInfo.key!)\", \"firstName\": \"\(accountInfo.firstName!)\", \"lastName\": \"\(accountInfo.lastName!)\",\"mapString\": \"\(location.mapString!)\", \"mediaURL\": \"\(location.mediaURL!)\",\"latitude\": \(location.latitude!), \"longitude\": \(location.longitude!)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion("Location not Posted")
                return
            }
            completion(nil)
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
    
    
}
