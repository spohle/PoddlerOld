//
//  Podcast.swift
//  Poddler
//
//  Created by Sven Pohle on 7/12/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import Foundation

struct Podcast: Decodable, Encodable {
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
    
    func getSubscribedStatus() -> Bool {
        let service = CoreDataService.shared
        return service.getSubscribedStatus(podcast: self)
    }
}
