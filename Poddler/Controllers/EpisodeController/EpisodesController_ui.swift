//
//  EpisodesController_ui.swift
//  Poddler
//
//  Created by Sven Pohle on 7/24/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import UIKit

extension EpisodesController {
    func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(r: 40, g: 40, b: 40)
    }
}
