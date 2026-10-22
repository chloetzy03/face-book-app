//
//  ViewController.swift
//  face book app
//
//  Created by Chloe Tay on 22/10/26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // testing
            Task {
                do {
                    let users = try await NetworkManager.shared.fetchUsers()
                    print("Fetched \(users.count) users")
                    for user in users {
                        print("- \(user.fullName), \(user.age), \(user.email)")
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
        
    }


}


#Preview {
    ViewController()
}

