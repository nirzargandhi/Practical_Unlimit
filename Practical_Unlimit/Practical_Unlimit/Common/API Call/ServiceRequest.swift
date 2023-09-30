//
//  ServiceRequest.swift
//

//MARK: - Service Request
struct ServiceRequest {

    //MARK: - Webservice Call Methods
    func wsGetJokes(latitude : Double, longitude : Double, completion : @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {

        ApiCall().get(apiUrl: WebServiceURL.jokeURL, model: GeneralResponseModel.self) { (success, responseData) in

            if success {
                completion(true, responseData)
            } else {
                completion(false, responseData)
            }
        }
    }
}
