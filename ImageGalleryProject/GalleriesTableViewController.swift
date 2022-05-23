//
//  GalleriesTableViewController.swift
//  ImageGalleryProject
//
//  Created by Or Peleg on 22/05/2022.
//

import UIKit

class GalleriesTableViewController: UITableViewController, UITextFieldDelegate {
    
    
    let NASAURLStrings = [
        "Cassini": "https://www.biography.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cg_face%2Cq_auto:good%2Cw_300/MTQ3NTI2NTg2OTE1MTA0MjM4/kenrick_lamar_photo_by_jason_merritt_getty_images_entertainment_getty_476933160.jpg",
        "Earth": "https://www.nasa.gov/sites/default/files/wave_earth_mosaic_3.jpg",
        "Saturn": "https://www.nasa.gov/sites/default/files/saturn_collage.jpg"]
    
    var selectedGallery: Gallery?
    var onlineGalleries: [Gallery] = []
    var deletedGalleries: [Gallery] = []
    var namesForOnlineGalleries: [String] = []
    var namesForDeletedGalleries: [String] = []
    lazy var tapToEditName = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
    var countGalleries = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Recently Deleted"
        } else {
            return "Online Galleries"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return onlineGalleries.count
        } else {
            return deletedGalleries.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath)
        let textField = UITextField(frame: cell.frame)
        tapToEditName.numberOfTapsRequired = 2
        cell.addGestureRecognizer(tapToEditName)
        if indexPath.section == 0 {
            textField.text = namesForOnlineGalleries[indexPath.row]
        } else {
            textField.text = namesForDeletedGalleries[indexPath.row]
        }
        cell.addSubview(textField)
        return cell
    }
    
    @objc func tapHandler(_ sender: UITapGestureRecognizer) {
        if let cellView = sender.view as? UITableViewCell {
            for subview in cellView.subviews {
                if let textField = subview as? UITextField {
                    textField.text = "Tapped"
                    textField.isEnabled = true
                    return
                }
            }
        }
    }
    
    @IBAction func addNewGallery(_ sender: UIBarButtonItem) {
        let newGallery = Gallery(name: "Untitled \(countGalleries)")
        if countGalleries >= 0 {
            newGallery.images = [WebImage(URL(string: "https://www.biography.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cg_face%2Cq_auto:good%2Cw_300/MTQ3NTI2NTg2OTE1MTA0MjM4/kenrick_lamar_photo_by_jason_merritt_getty_images_entertainment_getty_476933160.jpg")!, 10)]
        }
        if countGalleries >= 1 {
            newGallery.images.append(WebImage(URL(string: "https://www.nasa.gov/sites/default/files/wave_earth_mosaic_3.jpg")!, 10))
        }
        
        if countGalleries >= 2 {
            newGallery.images.append(WebImage(URL(string: "https://www.nasa.gov/sites/default/files/saturn_collage.jpg")!, 10))
        }
        countGalleries += 1
        onlineGalleries.append(newGallery)
        namesForOnlineGalleries.append(newGallery.name)
        tableView.reloadData()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != UISplitViewController.DisplayMode.oneOverSecondary {
            splitViewController?.preferredDisplayMode = UISplitViewController.DisplayMode.oneOverSecondary
        }
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if editingStyle == .delete {
                deletedGalleries.append(onlineGalleries[indexPath.row])
                namesForDeletedGalleries.append(namesForOnlineGalleries[indexPath.row])
                onlineGalleries.remove(at: indexPath.row)
                namesForOnlineGalleries.remove(at: indexPath.row)
            } else if editingStyle == .insert { }
        } else {
            deletedGalleries.remove(at: indexPath.row)
            namesForDeletedGalleries.remove(at: indexPath.row)
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 {
            let undelete = UIContextualAction(style: UIContextualAction.Style.normal, title: "Undelete") { [self]_,_,_ in
                self.onlineGalleries.append(deletedGalleries[indexPath.row])
                self.namesForOnlineGalleries.append(namesForDeletedGalleries[indexPath.row])
                self.deletedGalleries.remove(at: indexPath.row)
                self.namesForDeletedGalleries.remove(at: indexPath.row)
                tableView.reloadData()
            }
            let swipeAction = UISwipeActionsConfiguration(actions: [undelete])
            return swipeAction
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedGallery = onlineGalleries[indexPath.row]
            performSegue(withIdentifier: "Show Image Gallery", sender: self)
        } else {
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ImagesCollectionViewController {
            if segue.identifier == "Show Image Gallery" {
                destination.title = selectedGallery?.name
                destination.gallery = selectedGallery
            } else {
                return
            }
        }
    }
}
