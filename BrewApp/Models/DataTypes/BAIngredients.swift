//
//  BAIngredients.swift
//  BrewApp
//
//  Created by Emerson Balahan Varona on 8/2/23.
//

import Foundation

struct BAIngredients: Codable {
    let malt: [BAMalt]
    let hops: [BAHops]
    let yeast: String
}
