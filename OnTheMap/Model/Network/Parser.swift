//
//  Parser.swift
//  OnTheMap
//
//  Created by fahad on 18/03/1441 AH.
//  Copyright © 1441 Fahad Albgumi. All rights reserved.
//

import Foundation

class Parser {
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
    
    
    
    
    
    
    
}
