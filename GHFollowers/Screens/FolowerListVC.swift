//
//  FolowerListVC.swift
//  GHFollowers
//
//  Created by Danilo on 30/10/22.
//

import UIKit

class FolowerListVC: UIViewController {
    
    var username: String!
    var followers:[Follower] = []
    var filteredFollowers:[Follower] = []
    var collectionView:UICollectionView!
    var isSearching = false

    //pagination
    var page = 1
    var hasMoreFollowers = true
    
    ///diffable datasource collection view
    enum Section { case main }
    
    //                                      • enum sono hashable di default,
    //                                      • Follower dobbiamo renderlo conforme
    //                                                        |
    //                                                        V
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewcontroller()
        configureSearchController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewcontroller(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView(){
        
        ///frame: view.bounds: prende l'intera view
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        
        ///prima di aggiungere la collectionView alla view, va inizializzata altrimenti risulta nil
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func configureSearchController(){
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false //<ios15 rimuoce lo schermo oscurato durante la ricerca
        navigationItem.searchController = searchController
    }
    
    func getFollowers(username: String, page: Int){
        
        showLoadingView()
        
        //                                                                  GFError Conforms to Error
        //                                                                Result < [Follower], GFError >
        //                                                                            |
        //                                                                            V
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            //Serve a non rendere tutti i self? optional
            guard let self = self else { return }
                self.dismissLoadingView()

       

            switch result {
                
            case .success(let followers):
                
                //print(followers)
                
                if followers.count < 100 { self.hasMoreFollowers = false} //intercetta l'ultima pagina
                
                //alimenta l'array vuoto dichiarato in cima
                self.followers.append(contentsOf: followers) //siccome self è weak, può essere nil per cui dovrebbe essere optional
                
                if self.followers.isEmpty {
                    let message = "This user doesn't have any follower. Go Follow them!"
                    //print(message)
                    DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
                    return
                }
                
                self.updateData(on: self.followers) // ma non lo è  grazie al guard let iniziale
            case .failure(let error):
                print(error)

                self.presentGFAlertOlnMainThread(title: "Something Bad Happened 🫤", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(on followers: [Follower]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    

    
}

extension FolowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > (contentHeight - height) { // per infinite scrolling aggiungere in /2 in modo che la chiamata venga fatta a metà lista
            guard hasMoreFollowers else { return } //se non ci sono ulteriori followers esce
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let destVC = UserInfoVC()
        destVC.username = follower.login
        let navController = UINavigationController(rootViewController: destVC)
        
        present(navController, animated: true)

    }
    
}

extension FolowerListVC:UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        
        //se ci sono parole da cercare (filtro non vuoto)
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        isSearching = false
        updateData(on: followers)
    }
}


