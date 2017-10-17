//
//  ManuUIViewController.swift
//  iosTest
//
//  Created by User on 29/09/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit


class ManuUIViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Sources.getInstance().allSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MenuViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MenuViewCell  else {
            fatalError("The dequeued cell is not an instance of MenuTableViewCell.")
        }
        let menuItem = Sources.getInstance().allSources[indexPath.row]

        
        cell.menuItemLabel.text = menuItem.sourceLink
        cell.menuItemSwitch.isOn = menuItem.isSelected
        
        return cell
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
