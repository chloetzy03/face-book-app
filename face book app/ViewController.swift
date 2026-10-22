//
//  ViewController.swift
//  face book app
//
//  Created by Chloe Tay on 22/10/26.
//

import UIKit

class ViewController: UIViewController {

    //list of users start empty
    private var users: [User] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "face book"
        setupTableView()
        loadUsers()
    }

    
    private func setupTableView(){
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.dataSource = self
        
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.reuseID)
    }
    
    
    private func loadUsers(){
        Task{
            do{
                users = try await NetworkManager.shared.fetchUsers()
                tableView.reloadData()
            } catch {
                print("Error: \(error)")
            }
        }
    }
    

}


extension ViewController: UITableViewDataSource {
    //one row per user
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    //what goes in row number X
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get a recyled cell or make a new one
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserTableViewCell.reuseID,
            for: indexPath
        ) as? UserTableViewCell else { //otherwise return blank cell
            return UITableViewCell()
        }
        
        cell.configure(with: users[indexPath.row])
        return cell
    }
    
    
    
}






#Preview {
    UINavigationController(rootViewController: ViewController())
}

