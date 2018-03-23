//
//  IGUser.swift
//  Locstagram
//
//  Created by Yusuke Ohashi on 2018/03/23.
//  Copyright © 2018 Yusuke Ohashi. All rights reserved.
//

import Foundation

struct IGUser: Codable {
    let data: IGUserData
}

struct IGUserData: Codable {
    let id, username, fullName, profilePicture: String
    let bio, website: String
    let isBusiness: Bool
    let counts: Counts
    
    enum CodingKeys: String, CodingKey {
        case id, username
        case fullName = "full_name"
        case profilePicture = "profile_picture"
        case bio, website
        case isBusiness = "is_business"
        case counts
    }
}

struct Counts: Codable {
    let media, follows, followedBy: Int
    
    enum CodingKeys: String, CodingKey {
        case media, follows
        case followedBy = "followed_by"
    }
}

// MARK: Convenience initializers

extension IGUser {
    init(data: Data) throws {
        self = try JSONDecoder().decode(IGUser.self, from: data)
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

extension IGUserData {
    init(data: Data) throws {
        self = try JSONDecoder().decode(IGUserData.self, from: data)
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

extension Counts {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Counts.self, from: data)
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

