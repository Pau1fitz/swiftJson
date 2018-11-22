//
//  ViewController.swift
//  json
//
//  Created by Paul Fitzgerald on 11/22/18.
//  Copyright © 2018 Paul Fitzgerald. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var jokes = [] as Array
    
    @IBOutlet weak var myTableView: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = jokes[indexPath.row] as! String
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jokes.count
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "http://api.icndb.com/jokes/random/10")
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                if let va = json["value"] as? [[String:Any]] {
                    va.forEach { self.jokes.append($0["joke"] ?? String()) }
                    print(self.jokes)
                    DispatchQueue.main.async {
                        self.myTableView.reloadData()
                    }
                }
            } catch let error as NSError {
                print(error)
            }
        }).resume()
    }
}

