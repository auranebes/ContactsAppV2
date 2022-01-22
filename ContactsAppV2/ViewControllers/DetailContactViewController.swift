//
//  DetailContactViewController.swift
//  ContactsAppV2
//
//  Created by Arslan Abdullaev on 22.01.2022.
//

import UIKit
import Alamofire

class DetailContactViewController: UIViewController {
    @IBOutlet weak var contactPhoto: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        setValues(with: user)
    }
    
    override func viewWillLayoutSubviews() {
        contactPhoto.layer.cornerRadius = contactPhoto.bounds.height / 2
    }
    
    private func setValues(with user: User) {
        firstNameLabel.text = user.name?.first
        firstNameLabel.text = user.name?.last
        
       // guard let imageURL = URL(string: user.picture?.large ?? "") else { return }
        ContactManager.shared.fetchData(from: user.picture?.large ?? "") { result in
            switch result {
            case .success(let data):
                self.contactPhoto.image = UIImage(data: data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
