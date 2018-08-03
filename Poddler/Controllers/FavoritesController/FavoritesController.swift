//
//  FavoritesController.swift
//  Poddler
//
//  Created by Pohle, Sven on 8/1/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import UIKit
import CoreData

class FavoritesController: UITableViewController
{
    let cellId = "favoriteCellId"
    
    lazy var uiAddButton:UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "favorites")?.imageScaled(to: CGSize(width: view.frame.width, height: view.frame.width))
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(searchForPodcastsCb), for: .touchUpInside)
        return button
    }()
    
    var favorites = [Podcast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFavoritePodcasts()
    }
    
    func getFavoritePodcasts() {
        CoreDataService.shared.getSubscribedPodcasts { (podcasts) in
            self.favorites = podcasts
            self.setupUserInterface()
            self.tableView.reloadData()
        }
    }
    
    func setupTableView() {
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.separatorColor = .clear
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    
    fileprivate func setupUserInterface() {
        if(favorites.count <= 0) {
            view.addSubview(uiAddButton)
            uiAddButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            uiAddButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            uiAddButton.widthAnchor.constraint(equalToConstant: view.frame.width*0.5).isActive = true
            uiAddButton.heightAnchor.constraint(equalToConstant: view.frame.width*0.5).isActive = true
            return
        }
    }
    
    @objc fileprivate func searchForPodcastsCb() {
        let searchController = PodcastsSearchController()
        self.navigationController?.pushViewController(searchController, animated: true)
    }
}

extension FavoritesController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PodcastCell
        
        if indexPath.row%2 == 0 {
            cell.backgroundColor = UIColor(r: 55, g: 55, b: 55)
        } else {
            cell.backgroundColor = UIColor(r: 40, g: 40, b: 40)
        }
        
        let podcast = self.favorites[indexPath.row]
        cell.podcast = podcast
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
}
