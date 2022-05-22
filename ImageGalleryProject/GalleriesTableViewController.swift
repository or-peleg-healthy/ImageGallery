//
//  GalleriesTableViewController.swift
//  ImageGalleryProject
//
//  Created by Or Peleg on 22/05/2022.
//

import UIKit

class GalleriesTableViewController: UITableViewController {
    
    var sections: [[String]] = [[]]
    var galleries: [[URL]] = []
    let NASAURLStrings = [
        "Cassini": "https://www.biography.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cg_face%2Cq_auto:good%2Cw_300/MTQ3NTI2NTg2OTE1MTA0MjM4/kenrick_lamar_photo_by_jason_merritt_getty_images_entertainment_getty_476933160.jpg",
        "Earth": "https://www.nasa.gov/sites/default/files/wave_earth_mosaic_3.jpg",
        "Saturn": "https://www.nasa.gov/sites/default/files/saturn_collage.jpg"]
    var selectedGallery: [URL] = []
    var recentlyDeletedGallery: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sections = [[], []]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Recently Deleted"
        } else {
            return "No Title"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.sections[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath)

        // Configure the cell...
        let textField = UITextField(frame: cell.frame)
        textField.text = sections[indexPath.section][indexPath.row]
        cell.addSubview(textField)
        return cell
    }

    @IBAction func addNewGallery(_ sender: UIBarButtonItem) {
        if !sections[0].contains("Untitled") {
            sections[0] += ["Untitled"]
            galleries.append([])
        } else {
            let untitledCell = "Untitled"
            var numberOfUntitledCell = 1
            var itemThatExists = untitledCell + " " + String(numberOfUntitledCell)
            while sections[0].contains(itemThatExists)
            {
                numberOfUntitledCell += 1
                itemThatExists = untitledCell + " " + String(numberOfUntitledCell)
            }
            sections[0] += [itemThatExists]
            let newURL = URL(string: NASAURLStrings["Cassini"]!)!
            galleries.append([newURL])
        }
        tableView.reloadData()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != UISplitViewController.DisplayMode.oneOverSecondary {
            splitViewController?.preferredDisplayMode = UISplitViewController.DisplayMode.oneOverSecondary
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if editingStyle == .delete {
                sections[1].append(sections[0][indexPath.row])
                sections[0].remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .fade)
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        } else {
            sections[1].remove(at: indexPath.row)
            galleries.remove(at: indexPath.row)
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 {
            let undelete = UIContextualAction(style: UIContextualAction.Style.normal, title: "Undelete") { [self]_,_,_ in
                self.sections[0].append(sections[1][indexPath.row])
                self.sections[1].remove(at: indexPath.row)
                tableView.reloadData()
            }
            let swipeAction = UISwipeActionsConfiguration(actions: [undelete])
            return swipeAction
        } else {
            return nil
        }
    }
//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
//    {
//        if indexPath.section == 0 {
//            return UITableViewCell.EditingStyle.none
//        } else {
//            return UITableViewCell.EditingStyle.delete
//        }
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
                performSegue(withIdentifier: "Show Recently Deleted", sender: self)
        } else {
            selectedGallery = galleries[indexPath.row]
            performSegue(withIdentifier: "Show Image Gallery", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ImagesCollectionViewController {
            if segue.identifier == "Recently Deleted" {
                destination.title = "Recently Deleted"
                destination.imageURLs = recentlyDeletedGallery
            } else {
                destination.imageURLs = selectedGallery
            }
        }
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
