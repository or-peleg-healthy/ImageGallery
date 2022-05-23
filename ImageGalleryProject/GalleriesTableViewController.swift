//
//  GalleriesTableViewController.swift
//  ImageGalleryProject
//
//  Created by Or Peleg on 22/05/2022.
//

import UIKit

class GalleriesTableViewController: UITableViewController, UITextFieldDelegate {
    
    
    let urlStrings = [
        "one": "https://www.biography.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cg_face%2Cq_auto:good%2Cw_300/MTQ3NTI2NTg2OTE1MTA0MjM4/kenrick_lamar_photo_by_jason_merritt_getty_images_entertainment_getty_476933160.jpg",
        "two": "https://boardroom.tv/wp-content/uploads/2022/05/Kendrick-Lamar-The-Heart-Part-5-1280x720.png",
        "three": "https://media-cldnry.s-nbcnews.com/image/upload/t_fit-1240w,f_auto,q_auto:best/rockcms/2022-05/220513-kendrick-lamar-mn-1225-f90ed6.jpg"]
    
    var selectedGallery: Gallery?
    var onlineGalleries: [Gallery] = []
    var deletedGalleries: [Gallery] = []
    var namesForOnlineGalleries: [String] = []
    var namesForDeletedGalleries: [String] = []
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
        if let inputCell = cell as? TextFieldTableViewCell {
            inputCell.textField.isEnabled = true
            inputCell.resignationHandler = { [weak self] in
                if let text = inputCell.textField.text {
                    self?.namesForOnlineGalleries[indexPath.item] = text
                    self?.onlineGalleries[indexPath.item].name = text
                    self?.tableView.reloadData()
                }
            }
            if indexPath.section == 0 {
                if indexPath.item < namesForOnlineGalleries.count {
                    inputCell.textField.text = namesForOnlineGalleries[indexPath.item]
                }
            } else {
                inputCell.textField.text = namesForDeletedGalleries[indexPath.item]
            }
            return inputCell
        }
        return cell
    }

    
    @IBAction func addNewGallery(_ sender: UIBarButtonItem) {
        let newGallery = Gallery(name: "Untitled \(countGalleries)")
        if countGalleries >= 0 {
            newGallery.images.append(URL(string: urlStrings["one"]!)!)
        }
        if countGalleries >= 1 {
            newGallery.images.append(URL(string: urlStrings["two"]!)!)
        }
        
        if countGalleries >= 2 {
            newGallery.images.append(URL(string: urlStrings["three"]!)!)
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
