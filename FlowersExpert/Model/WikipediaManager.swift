//
//  WikipediaManager.swift
//  FlowersExpert
//
//  Created by Gil Marom on 30/07/2022.
//

import Foundation

protocol WikipediaManagerDelegate {
    func wikiInfoDidUpdate(_ wikipediaManager: WikipediaManager, wikiInfo: WikiModel)
    func didFailWithError(_ error: Error)
}

struct WikipediaManager {
    
    var delegate: WikipediaManagerDelegate?
    
    let wikipediaURL = "https://en.wikipedia.org/api/rest_v1/page/summary/"
    
    func fetchWikiInfo(flowerName: String) {
        let urlString = wikipediaURL + flowerName.replacingOccurrences(of: " ", with: "%20")
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                
                if let safeData = data {
                    if let wikiInfo = self.parseJSON(safeData) {
                        self.delegate?.wikiInfoDidUpdate(self, wikiInfo: wikiInfo)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ wikiData: Data) -> WikiModel? {
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WikiData.self, from: wikiData)
            let extract = decodedData.extract
            let imageSource = decodedData.originalimage.source
            
            let wikiInfo = WikiModel(summary: extract, imageURL: imageSource)
            return wikiInfo
            
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
    
}
