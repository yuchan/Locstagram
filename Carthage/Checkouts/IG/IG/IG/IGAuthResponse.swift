//
//  IGAuthResponse.swift
//  IG
//
//  Created by Yusuke Ohashi on 2018/03/23.
//  Copyright © 2018 Yusuke Ohashi. All rights reserved.
//

import Foundation

public struct IGAuthResponse: Codable {
    public let accessToken: String
    public let user: User

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case user
    }
}

public struct User: Codable {
    public let id, username, profilePicture, fullName: String
    public let bio, website: String
    public let isBusiness: Bool

    enum CodingKeys: String, CodingKey {
        case id, username
        case profilePicture = "profile_picture"
        case fullName = "full_name"
        case bio, website
        case isBusiness = "is_business"
    }
}

// MARK: Convenience initializers

public extension IGAuthResponse {
    init(data: Data) throws {
        self = try JSONDecoder().decode(IGAuthResponse.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public extension User {
    init(data: Data) throws {
        self = try JSONDecoder().decode(User.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
