//
//  TableViewController.swift
//  ARDemo
//
//  Created by KKFantasy on 2019/4/22.
//  Copyright © 2019 kk. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let detailTitles = ["快照", "图像识别", "对象识别"]
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DemoListCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return detailTitles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoListCell", for: indexPath)
        cell.textLabel?.text = "Demo\(indexPath.row + 1)"
        cell.detailTextLabel?.text = detailTitles[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        index = indexPath.row
        performSegue(withIdentifier: "demo\(indexPath.row + 1)", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destination
        vc.title = detailTitles[index]
    }

}
