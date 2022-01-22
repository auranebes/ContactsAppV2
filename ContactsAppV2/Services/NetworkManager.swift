//
//  NetworkManager.swift
//  ContactsAppV2
//
//  Created by Arslan Abdullaev on 22.01.2022.
//

import Alamofire

class ContactManager {
    static let shared = ContactManager()
    
    private let urlParams = [
        "results":"\(30)"
    ]
    
    private init() {}
    
    func fetchUsers(_ completion: @escaping (Result<[User], AFError>) -> Void) {
        AF.request(URLConstants.randomUserAPI.rawValue, parameters: urlParams)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let users = User.getRandomUsers(from: value)
                    completion(.success(users))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchData(from url: String, completion: @escaping (Result<Data, AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

