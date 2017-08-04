//
//  ResultViewController.swift
//  VideoResume
//
//  Created by LC-NikhilLihla on 04/08/17.
//  Copyright © 2017 Mohd Kamar Shad. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tableDataSource: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        print("DataSource : \(getDataSource().count)")
    }
    
    fileprivate func getDataSource() -> [String] {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        let videoDirectory = documentDirectory.appendingFormat("Video", [])
//        let savePath = (documentDirectory as NSString).appendingPathComponent("mergeVideo4.mov")
//        let url = NSURL(fileURLWithPath: savePath)
        
        let fileManager = FileManager.default
        let dataSource = try! fileManager.contentsOfDirectory(atPath: documentDirectory)
        
        return dataSource
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ResultViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getDataSource().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let path = getDataSource()[indexPath.row]
        let url = URL(fileURLWithPath: path)
        cell?.textLabel?.text = url.lastPathComponent
        
        return cell!
    }
}

extension ResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("TableView Index : \(indexPath.row)")
    }
}
