//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Danilo on 07/11/22.
//

import UIKit

class UserInfoVC: UIViewController {

    let headerView = UIView()
    
    var username:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        
        view.backgroundColor = .systemBackground
        
        //dismiss btn
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        layoutUI()
        
        NetworkManager.shared.getUserInfo(for: username) { result in
            switch result {
            case .success(let user):
                
                DispatchQueue.main.async {
                    self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)

                }
                
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
    
    func layoutUI(){
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        //headerView.backgroundColor = .systemPink
        
        NSLayoutConstraint.activate([
    
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180)
            
        
        ])
    }
    
    func add(childVC: UIViewController, to containerView:UIView){
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }

}
