//
//  NetworkManager.swift
//  face book app
//
//  Created by Chloe Tay on 22/10/26.
//

import Foundation
import UIKit

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
    
    func fetchImage(from urlString: String) async throws -> UIImage {
        //turn the text into url, if text invalid, stop and report
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        //download raw bytes and wait
        let (data, response) = try await URLSession.shared.data(from: url)
        
        //make sure server says ok
        guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse) //report error
        }
        
        // If the bytes aren't a valid image, report an error instead of crashing
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        return image
    }
    
}
