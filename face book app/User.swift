//
//  User.swift
//  face book app
//
//  Created by Chloe Tay on 22/10/26.
//

import Foundation

// MARK: - Main Response
// The whole reply from the server
// It has a list of users, plus info about paging (how many exist, how many we skipped, how many we got)
struct UsersResponse: Codable {
    let users: [User]   // The array of users inside the reply
    let total: Int      // Total users that exist on the server (e.g. 208)
    let skip: Int       // How many users were skipped (used for pagination later)
    let limit: Int      // How many users this reply contains
}

// MARK: - User Model
struct User: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let age: Int
    let email: String
    let phone: String
    let image: String   // A URL stored as text, e.g. "https://..."

    // this is NOT in the JSON, it's computed on demand, so Codable ignores it
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}
