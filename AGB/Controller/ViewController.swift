//
//  ViewController.swift
//  AGB
//
//  Created by Alain Gabellier on 10/09/2018.
//  Copyright © 2018 Alain Gabellier. All rights reserved.
//

import UIKit
import BMSCore
import SwiftyJSON
import ChameleonFramework
import SwiftCloudant
import RealmSwift
import SwipeCellKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var transactionsList = [Transaction]()
    var docIdList = [String]()
    var docNum: Int = 0
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set as Delegate and DataSource for Table View
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register custom Cell.xib file
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        // Remove separator
        tableView.separatorStyle = .none
        
        // Load Existing Transactions
        loadAllTransactions()

    }

    //MARK: - Table View Management
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell

        // Set cell and current transaction
        print("Cell \(indexPath.row)")
        let currentTransaction = transactionsList[indexPath.row]
        
        // Set cell contents
        cell.dateLabel.text = currentTransaction.date
        cell.titleLabel.text = currentTransaction.title
        cell.amountLabel.text = String(format: "%.2f €", currentTransaction.amount)
        
        // Set category color according to category
        var categoryColor = UIColor.flatGray()
        switch currentTransaction.category {
        case .vc:
            categoryColor = UIColor.flatLime()
        case .salaire:
            categoryColor = UIColor.flatOrange()
        case .immo:
            categoryColor = UIColor.flatSkyBlue()
        }
        cell.category.backgroundColor = categoryColor
        
        // Set recurrent color according to reccurent bool
        var reccurentColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0)
        if currentTransaction.reccurent {
            reccurentColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        }
        cell.reccurent.backgroundColor = reccurentColor
        
        // Set bottomLine color
        cell.bottomLine.backgroundColor = categoryColor
        
        return cell
    }
    
    //MARK: - Database Cloudant Management
    
    // Connect to DB
    func connectCloudant() -> CouchDBClient {
        
        // Search infos in BMSCredentials.plist
        guard let contents = Bundle.main.path(forResource:"BMSCredentials", ofType: "plist"), let dictionary = NSDictionary(contentsOfFile: contents) else { fatalError("Access to credentials failed") }
        
        // Create Cloudant client
        let url = URL(string: dictionary["cloudantUrl"] as! String)
        let client = CouchDBClient(url:url!, username:dictionary["cloudantUsername"] as? String, password:dictionary["cloudantPassword"] as? String)
        
        // Return client
        return client
    }
    
    // Read All Documents in DB
    func loadAllTransactions() {
        
        // Get credentials
        let client = connectCloudant()
        let dbName = "database"
        
        // Clear transactionsList
        transactionsList.removeAll()
        
        // Read All docs in DB
        let allDocs = GetAllDocsOperation(databaseName: dbName, rowHandler: { doc in
                // Add Doc Ids to docIdList
                self.docIdList.append(doc["id"] as! String)
                }) { (response, httpInfo, error) in
                    if let error = error {
                        print("Encountered an error while Getting all documents. Error: \(error)")
                    } else {
                        self.docNum = response!["total_rows"] as! Int
                        print("Load of \(self.docNum) document Ids done")
                        self.loadEachTransaction()
                    }
        }
        client.add(operation: allDocs)
    }
    
    func loadEachTransaction() {

        // Get credentials
        let client = connectCloudant()
        let dbName = "database"
        
        print(docIdList)
        
        for docId in docIdList {
            // Get transaction entry in DB
            // Dispatcher creation to manage asynchronous request synchronization
            group.enter()
            let read = GetDocumentOperation(id: docId, databaseName: dbName) { (response, httpInfo, error) in
                if let error = error {
                    print("Encountered an error while Getting document \(docId). Error: \(error)")
                } else {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                        let decoder = JSONDecoder()
                        let transaction = try decoder.decode(Transaction.self, from: jsonData)
                        
                        // Append transaction to transactions List
                        self.transactionsList.append(transaction)
                        print("Document : \(docId)")
                        
                        // Say to Dispatcher that task is done
                        self.group.leave()
                    } catch {
                        print("Error decoding Doc .... \(error)")
                    }
                }
            }
            client.add(operation: read)
            
        }
        
        // What to do once All tasks done
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    
}

