//
//  ContactListTableViewController.swift
//  ContactsAppV2
//
//  Created by Arslan Abdullaev on 22.01.2022.
//

import UIKit

class ContactListTableViewController: UITableViewController {

    private var contacts: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        downloadData()
        setupRefreshControl()
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsVC = segue.destination as! DetailContactViewController
        detailsVC.user = sender as? User
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contact", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.imageProperties.maximumSize = CGSize(width: 100, height: 100)
        content.imageProperties.cornerRadius = 50
        
        let contact = contacts[indexPath.row]
        content.text = contact.name?.first
        content.secondaryText = contact.name?.last
        
        if let imageURL = contact.picture?.thumbnail {
            ContactManager.shared.fetchData(from: imageURL) { result in
                switch result {
                case .success(let data):
                    content.image = UIImage(data: data)
                    cell.contentConfiguration = content
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentUser = contacts[indexPath.row]
        performSegue(withIdentifier: Segues.showContact.rawValue, sender: currentUser)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ContactListTableViewController {
    @objc private func downloadData() {
        ContactManager.shared.fetchUsers { result in
            switch result {
            case .success(let value):
                self.contacts = value
                self.tableView.reloadData()
                if self.refreshControl != nil {
                    self.refreshControl?.endRefreshing()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(downloadData), for: .valueChanged)
    }
    
}
