//
//  Coin.swift
//  CryptoTrack
//
//  Created by 최하림 on 11/25/21.
//

import Foundation

struct Coin: Codable {
    var rank: String
    var symbol: String
    var name: String
    var supply: String
    var maxSupply: String?
    var marketCapUsd: String
    var volumeUsd24Hr: String
    var priceUsd: String
    var changePercent24Hr: String
}
