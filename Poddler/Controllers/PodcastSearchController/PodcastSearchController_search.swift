//
//  PodcastSearchController_search.swift
//  Poddler
//
//  Created by Sven Pohle on 7/24/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import UIKit

extension PodcastsSearchController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.uiOverlayView.backgroundColor = self.uiOverlayView.backgroundColor?.withAlphaComponent(0.0)
            self.uiOverlayView.frame.origin.y = 400
        }) { (finished) in
            self.uiOverlayView.isHidden = true
        }
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        if self.podcasts.count == 0 {
            
            self.uiOverlayView.isHidden = false
            UIView.animate(withDuration: animationDuration) {
                self.uiOverlayView.backgroundColor = self.uiOverlayView.backgroundColor?.withAlphaComponent(1.0)
                self.uiOverlayView.frame.origin.y = 0
            }
        }
    }
}

extension PodcastsSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            APIService.shared.fetchPodcasts(searchText: searchText) { (podcasts) in
                self.podcasts = podcasts
                self.tableView.reloadData()
            }
        }
    }
}
