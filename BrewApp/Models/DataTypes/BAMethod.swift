//
//  BAMethod.swift
//  BrewApp
//
//  Created by Emerson Balahan Varona on 8/2/23.
//

import Foundation

struct BAMethod: Codable {
    let mash_temp: [BAMashTemp]
    let fermentation: BAFermentation
    let twist: String?
}
