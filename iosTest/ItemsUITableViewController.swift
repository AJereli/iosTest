    //
    //  ItemsUITableViewController.swift
    //  iosTest
    //
    //  Created by User on 26/09/2017.
    //  Copyright © 2017 User. All rights reserved.
    //
    
    import UIKit
    import PromiseKit

    class ItemsUITableViewController: UITableViewController {
        
        var items = [Item]()
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        //MARK: - Table view data source
        
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.clearsContextBeforeDrawing = true
            
            self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
            
            // Uncomment the following line to preserve selection between presentations
            // self.clearsSelectionOnViewWillAppear = false
            
            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
            // self.navigationItem.rightBarButtonItem = self.editButtonItem
        }
        @objc func handleRefresh(refreshControl: UIRefreshControl) {
           
            
            items = Sources.getInstance().loadItems(limitForSource: 1)
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            items = Sources.getInstance().loadItems(limitForSource: 3)
    
            tableView.reloadData()
        }
        
        override func scrollViewDidScroll(_ scrollView: UIScrollView) {
            // calculates where the user is in the y-axis
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            
            if offsetY > contentHeight - scrollView.frame.size.height {
                
                items = Sources.getInstance().loadItems(limitForSource: 1)
                
                // tell the table view to reload with the new data
                tableView.reloadData()
            }
        }
        
        @IBAction func selectMenuEvent(_ sender: Any) {
            performSegue(withIdentifier: "segueMenu", sender: sender)
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            // Table view cells are reused and should be dequeued using a cell identifier.
            let cellIdentifier = "ItemTableViewCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemTableViewCell  else {
                fatalError("The dequeued cell is not an instance of ItemTableViewCell.")
            }
            
            
            let item = items[indexPath.row]
            
            cell.titleLabel.text = item.title
            cell.descritpionTextView.text =  item.description
            
            cell.imageSpinner.startAnimating()

            firstly{ () -> Promise<UIImage> in
                return item.downloadImage()
                }.then{ (image) -> Void in
                    cell.newsImageView.image = image
                }.catch{error in
                    cell.newsImageView.image = UIImage(named: "animeCat")
            }.always {
                
                    cell.imageSpinner.stopAnimating()
            }
            
         
            return cell
        }
        
      
        
        
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return items.count
        }
        
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let currUrl:String = items[indexPath.row].newsUrl
            performSegue(withIdentifier: "segueUrl", sender: currUrl)
        }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "segueUrl"{
                if let controller = segue.destination as? PageViewController {
                    controller.siteUrl = (sender as! String)
                }
                
            }
            if segue.identifier == "segueMenu"{
                
            }
        }
        
      
        
//        override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//            if indexPath.row == items.count-1 {
//                tableView.reloadData()
//            }
//        }

        
        /*
         // Override to support conditional editing of the table view.
         override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the specified item to be editable.
         return true
         }
         */
        
        /*
         // Override to support editing the table view.
         override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
         // Delete the row from the data source
         tableView.deleteRows(at: [indexPath], with: .fade)
         } else if editingStyle == .insert {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
         }
         */
        
        
        // Override to support rearranging the table view.
       
        
        /*
         // Override to support conditional rearranging of the table view.
         override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the item to be re-orderable.
         return true
         }
         */
        
        
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        
        
        
    }
