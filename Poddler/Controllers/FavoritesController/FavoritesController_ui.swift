//
//  FavoritesController_ui.swift
//  Poddler
//
//  Created by Pohle, Sven on 8/3/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import UIKit

extension FavoritesController {
    func setupTableView() {
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.separatorColor = .clear
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = UIColor(r: 40, g: 40, b: 40)
    }


    func setupUserInterface() {
        if(favorites.count <= 0) {
            view.addSubview(uiAddButton)
            uiAddButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            uiAddButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            uiAddButton.widthAnchor.constraint(equalToConstant: view.frame.width*0.5).isActive = true
            uiAddButton.heightAnchor.constraint(equalToConstant: view.frame.width*0.5).isActive = true
            return
        }
    }
}
