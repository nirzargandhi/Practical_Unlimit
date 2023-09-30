//
//  ApiCall.swift
//

import Foundation

//MARK: - API Call
class ApiCall {

    //MARK: - API Call Method
    func get<T : Decodable>(apiUrl : String, model: T.Type, isLoader : Bool = true, isErrorToast : Bool = true, isAPIToken : Bool = false, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {

        requestGetMethod(apiUrl: apiUrl, method: "GET", model: model, isLoader : isLoader, isErrorToast : isErrorToast, isAPIToken : isAPIToken, completion: completion)
    }

    func requestGetMethod<T : Decodable>(apiUrl : String, method: String, model: T.Type, isLoader : Bool = true, isErrorToast : Bool = true, isAPIToken : Bool = false, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {

        var request = URLRequest(url: URL(string: apiUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData)
        request.httpMethod = method
        request.setValue(constValueField, forHTTPHeaderField: constHeaderField)
        request.setValue("*/*", forHTTPHeaderField: "Accept")

        if isAPIToken {
            request.setValue("Bearer ", forHTTPHeaderField: "Authorization")
        }

        let task: URLSessionDataTask = URLSession(configuration: URLSessionConfiguration.default).dataTask(with : request as URLRequest, completionHandler: { (data, response, error) -> Void in

            guard let data = data, error == nil else {

                print(error as Any)

                completion(false, error as AnyObject)
                return
            }

            let decoder = JSONDecoder()
            do {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                    mainThread {
                        completion(false, AlertMessage.msgUnauthorized as AnyObject)
                    }
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 403 {
                    mainThread {
                        completion(false, AlertMessage.msgError403 as AnyObject)
                    }
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 500 {
                    mainThread {
                        completion(false, AlertMessage.msgError500 as AnyObject)
                    }
                } else {

                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        print(convertedJsonIntoDict)
                    }

                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        let dictResponse = try decoder.decode(model, from: data)
                        mainThread {
                            completion(true, dictResponse as AnyObject)
                        }
                    } else {
                        let dictResponse = try decoder.decode(GeneralResponseModel.self, from: data)
                        mainThread {
                            completion(false, dictResponse.message as AnyObject)
                        }
                    }
                }
            } catch let error as NSError {

                print("\n\n===========Error===========")
                print("Error Code: \(error._code)")
                print("Error Messsage: \(error.localizedDescription)")
                if let str = String(data: data, encoding: String.Encoding.utf8) {
                    print("Print Server data:- " + str)
                }
                debugPrint(error)
                print("===========================\n\n")

                debugPrint(error)

                completion(false, error as AnyObject)
            }
        })

        task.resume()
    }
}
