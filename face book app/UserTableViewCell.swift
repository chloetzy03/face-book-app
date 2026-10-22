//
//  UserTableViewCell.swift
//  face book app
//
//  Created by Chloe Tay on 22/10/26.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    static let reuseID = "UserCell" //static belongs to class itself
    private var imageTask: Task<Void, Never>?
    
    //MARK: UI elements
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .secondarySystemBackground //grey placeholder
        imageView.contentMode = .scaleAspectFit //fill the circle, crop extra
        imageView.clipsToBounds = true //hide anything outside shape
        imageView.layer.cornerRadius = 30 //circle
        return imageView
    }()
    
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    
    //MARK: layout
    private func setupLayout(){
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(ageLabel)
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            ageLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 4),
            ageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            ageLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            // Pin the last label to the bottom so the cell knows how tall to be
            ageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    //MARK: reuse cell
    //calls this just BEFORE this cell is recycled for another row
    //stop the old download and clear the old picture
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()          // Stop the unfinished download
        imageTask = nil
        profileImageView.image = nil // Back to the grey placeholder
    }
    
    
    
    //MARK: configure
    func configure(with user: User){
        nameLabel.text = user.fullName
        emailLabel.text = user.email
        ageLabel.text = "Age: \(user.age)"
        
        //start downloading this user's picture and remember the task
        imageTask = Task {
            do {
                let image = try await NetworkManager.shared.fetchImage(from: user.image)
                
                // "If the cell was recycled while we waited, the task was cancelled. Don't touch the picture, it belongs to another user now."
                guard !Task.isCancelled else { return }
                profileImageView.image = image
            } catch {
                print("Image error: \(error)")
            }
        }
    }
    
    
    
    
    
    
    
    


}
