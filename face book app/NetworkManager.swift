//
//  NetworkManager.swift
//  face book app
//
//  Created by Chloe Tay on 22/10/26.
//

import Foundation

class NetworkManager{
    //one shared copy everyone uses so we dont create new manager everytime
    static let shared = NetworkManager()
    //nobody else can create another NetworkManager ???
    private init() {}
    //?limit=10 tells the server to send only 10
    func fetchUsers(limit: Int = 10) async throws -> [User] {
        guard let url = URL(string: "https://dummyjson.com/users?limit=\(limit)") else {
            throw URLError(.badURL) //If the address text is invalid, stop and report an error
        }
        //Go to the internet, download the data, and wait until it arrives
        //get back two things: the data and the server's response info
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Check the server said OK
        // 'as? HTTPURLResponse' means try to treat the response as an HTTP one (it might not be)
        guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse) //report error
        }
        
        // convert raw data into UsersResponse struct
        let decoded = try JSONDecoder().decode(UsersResponse.self, from: data)

        //return users array 
        return decoded.users
    }
    
}
