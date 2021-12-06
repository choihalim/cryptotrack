//
//  ViewController.swift
//  CryptoTrack
//
//  Created by 최하림 on 11/25/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var coins = Coins()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        coins.getData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! DetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.coin = coins.coinArray[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    func formatNumberWithCommas(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value: number)) else {return ""}
        return "\(formattedNumber)"
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.coinArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if segmentedControl.selectedSegmentIndex == 1 {
            cell.textLabel?.text = "\(indexPath.row+1). \(coins.coinArray[indexPath.row].name) (\(coins.coinArray[indexPath.row].symbol))"
        } else {
            cell.textLabel?.text = "\(coins.coinArray[indexPath.row].name) (\(coins.coinArray[indexPath.row].symbol))"
        }
        
        let mCap = Double(coins.coinArray[indexPath.row].marketCapUsd)!
        let pChange = Double(coins.coinArray[indexPath.row].changePercent24Hr)!
        let roundedChange = round(pChange * 100) / 100.0
        let price = Double(coins.coinArray[indexPath.row].priceUsd)!
        let roundedPrice = round(price * 100) / 100.0
        let truncatedPrice = round(price * 10000000) / 10000000.0
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if price > 0.001 {
                cell.detailTextLabel?.text = "$\(roundedPrice)"
                if String(roundedPrice).last == "0" {
                    cell.detailTextLabel?.text = "$\(roundedPrice)0"
                }
            } else {
                cell.detailTextLabel?.text = "$\(truncatedPrice)"
                if String(truncatedPrice).last == "0" {
                    cell.detailTextLabel?.text = "$\(truncatedPrice)0"
                }
            }
            cell.detailTextLabel?.textColor = UIColor.black
        case 1:
            cell.detailTextLabel?.text = "$\(formatNumberWithCommas(number: Int(mCap.rounded())))"
            cell.detailTextLabel?.textColor = UIColor.black
        case 2:
            cell.detailTextLabel?.text = "\(roundedChange)%"
            if roundedChange > 0 {
                cell.detailTextLabel?.textColor = UIColor.systemGreen
            } else {
                cell.detailTextLabel?.textColor = UIColor.red
            }
        default:
            print("Error: should not have reached here, there are only three segments in this segmented control.")
        }
        return cell
    }
}

