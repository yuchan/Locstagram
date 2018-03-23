//
//  IGClient.swift
//  Locstagram
//
//  Created by Ohashi, Yusuke a | Mike | ECMD on 2018/03/23.
//  Copyright © 2018 Yusuke Ohashi. All rights reserved.
//

import Foundation

class IG {
    fileprivate static let shared = IG()
    
    fileprivate var clientID = ""
    fileprivate var clientSecret = ""
    fileprivate var redirectURI = ""
    fileprivate let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)

    static func configure(clientID: String, clientSecret: String, redirectURI: String) {
        shared.clientID = clientID
        shared.clientSecret = clientSecret
        shared.redirectURI = redirectURI
    }
    
    static func getAccessToken(code: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if let url = URL(string: "https://api.instagram.com/oauth/access_token") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let parameters = "client_id=\(shared.clientID)" +
                "&client_secret=\(shared.clientSecret)" +
                "&grant_type=authorization_code" +
                "&redirect_uri=\(shared.redirectURI)" +
            "&code=\(code)"
            request.httpBody = parameters.data(using: .utf8)
            shared.session.dataTask(with: request) { (data, response, error) in
                completion(data, response, error)
                }.resume()
        }
    }
    
    static func biography(accessToken: String, completion:@escaping (IGUser?, Error?) -> Void) {
        if let url = URL(string: "https://api.instagram.com/v1/users/self/?access_token=\(accessToken)") {
            let request = URLRequest(url: url)
            shared.session.dataTask(with: request) { (data, response, error) in
                do {
                    if let data = data {
                        let user = try IGUser(data: data)
                        completion(user, nil)
                    } else {
                        completion(nil, error)
                    }
                } catch {
                    completion(nil, nil)
                }
                }.resume()
        }
    }
}
