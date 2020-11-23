//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate{
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "?apikey=F2F50B28-B198-4F82-A8D0-B8E0F4995A93"
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String){

        fetchWallet(walletName: currency)
    }
    
    func fetchWallet(walletName: String){
        let urlString = "\(baseURL)/\(walletName)\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest (with urlString: String){
           //1. Create a URL
           
           if let url = URL(string: urlString){//URL is optional
            //2. Create a URL Session
            
            let session = URLSession(configuration: .default)
            //3. Give a URL Session Task
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    //let dataString = String(data: safeData, encoding: .utf8)
                    if let coinData = self.parseJSON(safeData){
                        self.delegate?.didUpdateCoin(self, coin: coinData)
                    //    print(coinData.rateString)
                    }
                }
            }
            //4. Start the Task
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> CoinModel?{
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(CoinData.self, from: coinData)
            let rate = decodeData.rate
            let data = CoinModel(rate: rate)
            return data
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
