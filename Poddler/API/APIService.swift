//
//  APIService.swift
//  Poddler
//
//  Created by Sven Pohle on 7/12/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
    static let shared = APIService()
    
    let baseUrl = "https://itunes.apple.com/search?"
    
    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        
        let parameters = ["term":searchText, "media":"podcast"]
        
        Alamofire.request(baseUrl, method: .get, parameters: parameters,
                          encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let error = dataResponse.error {
                print("Failed to get data: \(error)")
                return
            }
            
            guard let data = dataResponse.data else { return }
            
            do {
                let searchResults = try JSONDecoder().decode(SearchResults.self, from: data)
                
                completionHandler(searchResults.results)
                
            } catch let decodeErr {
                print("Failed to decode: \(decodeErr)")
                return
            }
        }
    }
    
    struct SearchResults: Decodable {
        let resultCount: Int
        let results: [Podcast]
    }
    
    func fetchEpisodes(baseUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        print(baseUrl)
        let feedUrl = URL(string: baseUrl)!
        let parser = FeedParser(URL: feedUrl)
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            guard let feed = result.rssFeed, result.isSuccess else {
                print("Could not parse the Episodes Feed! Error: \(String(describing: result.error))")
                return
            }
            
            var episodes = [Episode]()
            guard let items = feed.items else { return }
            items.forEach { item in
                let title = item.title ?? ""
                let pubDate = item.pubDate ?? Date()
                let summary = item.iTunes?.iTunesSummary ?? ""
                let streamUrl = item.enclosure?.attributes?.url ?? ""
                let imageUrl = item.iTunes?.iTunesImage?.attributes?.href ?? feed.iTunes?.iTunesImage?.attributes?.href ?? ""
                
                let episode = Episode(title: title, pubDate: pubDate, summary: summary,
                                      streamUrl: streamUrl, imageUrl: imageUrl)
                episodes.append(episode)
            }
            
            completionHandler(episodes)
        }
    }
}
