//
//  Coins.swift
//  CryptoTrack
//
//  Created by 최하림 on 11/25/21.
//

import Foundation

class Coins {
    private struct Returned: Codable {
        var data: [Coin]
    }
    
    var urlString = "https://api.coincap.io/v2/assets"
    var coinArray: [Coin] = []
    
    func getData(completed: @escaping () -> ()) {
        print("🕸 Accessing the url \(urlString)")
        // create a URL
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a URL from \(urlString)")
            completed()
            return
        }
        // create session
        let session = URLSession.shared
        
        // get data with .dataTask method
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("😡 ERROR: \(error.localizedDescription)")
            }
            // deal with the data
            do {
                let returned = try JSONDecoder().decode(Returned.self, from: data!)
                self.coinArray = self.coinArray + returned.data
            } catch {
                print("JSON ERROR: \(error.localizedDescription)")
            }
            completed()
        }
        task.resume()
    }
}
