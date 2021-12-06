//
//  DetailViewController.swift
//  CryptoTrack
//
//  Created by 최하림 on 11/25/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var supplyLabel: UILabel!
    @IBOutlet weak var maxSupplyLabel: UILabel!
    
    var coin: Coin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard coin != nil else {
            print("!!! coin is nil in DetailViewController should NEVER happen!")
            return
        }

        updateUserInterface()
    }
    
    func formatNumberWithCommas(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value: number)) else {return ""}
        return "\(formattedNumber)"
    }
    
    func updateUserInterface() {
        nameLabel.text = coin.name
        percentLabel.text = ""
        let roundedChange = round(Double(coin.changePercent24Hr)! * 100) / 100.0
        if roundedChange > 0.0 {
            percentLabel.text! += "+"
            percentLabel.textColor = UIColor.systemGreen
        } else {
            percentLabel.textColor = UIColor.red
        }
        percentLabel.text! += "\(roundedChange)%"
        rankLabel.text = "#\(coin.rank)"
        var doublePrice = Double(coin.priceUsd)!
        if doublePrice > 0.001 {
            doublePrice = round(doublePrice * 100) / 100.0
        }
        priceLabel.text = "$\(doublePrice)"
        marketCapLabel.text = "$\(formatNumberWithCommas(number: Int(Double(coin.marketCapUsd)!.rounded())))"
        volumeLabel.text = "$\(formatNumberWithCommas(number: Int(Double(coin.volumeUsd24Hr)!.rounded())))"
        supplyLabel.text = formatNumberWithCommas(number: Int(Double(coin.supply)!.rounded()))
        if coin.maxSupply != nil {
            maxSupplyLabel.text = formatNumberWithCommas(number: Int((Double(coin.maxSupply!)?.rounded())!))
        } else {
            maxSupplyLabel.text = "N/A"
        }
    }
}
