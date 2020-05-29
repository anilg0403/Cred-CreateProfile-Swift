//
//  InfoData.swift
//  InfoApp
//
//  Created by Anil Gupta on 22/05/20.
//  Copyright © 2020 Anil Gupta. All rights reserved.
//

import Foundation

struct InfoDataArray :  Codable {
    
    let pages : [InfoData]?
    
    enum CodingKeys: String, CodingKey {
        case pages
    }

}

struct InfoData :  Codable {

    let title : String?
    let subtitle : String?
    let placeholderText : String?
    let canMoveNext : Bool?
    let nextButtonText : String?
    let showNumberKeyoard : Bool?
    let emptyFieldMsg : String?
    let isSummary : Bool?
    let parameterKey : String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case subtitle
        case placeholderText
        case canMoveNext
        case nextButtonText
        case showNumberKeyoard
        case emptyFieldMsg
        case isSummary
        case parameterKey
    }
}

