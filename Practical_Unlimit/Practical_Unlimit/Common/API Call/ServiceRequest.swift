//
//  ServiceRequest.swift
//

//MARK: - Service Request
struct ServiceRequest {

    //MARK: - Webservice Call Method
    func wsGetJokes(completion : @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {

        ApiCall().get(apiUrl: WebServiceURL.jokeURL, model: JokesList.self) { (success, responseData) in

            if success {
                completion(true, responseData)
            } else {
                completion(false, responseData)
            }
        }
    }
}
