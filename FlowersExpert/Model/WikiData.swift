//
//  WikiSummaryData.swift
//  FlowersExpert
//
//  Created by Gil Marom on 30/07/2022.
//

import Foundation

struct WikiData: Codable {
    let extract: String
    let originalimage: OriginalImage
}

struct OriginalImage: Codable {
    let source: String
}
