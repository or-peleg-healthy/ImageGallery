//
//  ImagesCollectionViewController.swift
//  ImageGalleryProject
//
//  Created by Or Peleg on 22/05/2022.
//

import UIKit


class ImagesCollectionViewController: UICollectionViewController,  UICollectionViewDragDelegate, UICollectionViewDropDelegate, UIDropInteractionDelegate {
   
    let defaultURL = URL(string: "https://www.biography.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cg_face%2Cq_auto:good%2Cw_300/MTQ3NTI2NTg2OTE1MTA0MjM4/kenrick_lamar_photo_by_jason_merritt_getty_images_entertainment_getty_476933160.jpg")
    var gallery: Gallery?
    var chosenImageToEnlarge: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.dragDelegate = self
        collectionView?.dropDelegate = self
        collectionView.addInteraction(UIDropInteraction(delegate: self))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        if let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ImageCollectionViewCell {
            if gallery != nil, indexPath.item < ((gallery?.images.count)!) {
                imageCell.configure(with: ((gallery?.images[indexPath.item])!)!)
            } else {
                imageCell.blank()
            }
            cell = imageCell
        }
        return cell
    }
    
    // MARK: - Collection View Navigation
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < (gallery?.images.count) ?? 0 {
            chosenImageToEnlarge = gallery?.images[indexPath.item]
            performSegue(withIdentifier: "Show Image", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ImageViewController {
            if segue.identifier == "Show Image" {
                destination.imageURL = chosenImageToEnlarge
            } else {
                return
            }
        }
    }
    
    // MARK: - Collection View Drag & Drop
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        dragItems(at: indexPath)
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if indexPath.item < (self.gallery?.images.count)! {
            if let imageURL = gallery?.images[indexPath.item] as? URL {
                let urlContents = try? Data(contentsOf: imageURL)
                let image = UIImage(data: urlContents!)
                let dragItem = UIDragItem(itemProvider: NSItemProvider(object: image!))
                dragItem.localObject = imageURL
                return [dragItem]
            } else {
                return []
            }
        } else {
            return []
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        if destinationIndexPath.item > (self.gallery?.images.count)! - 1 {
            return
        }
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                if let url = item.dragItem.localObject as? URL {
                    collectionView.performBatchUpdates( { gallery?.images.remove(at: sourceIndexPath.item)
                        gallery?.images.insert(contentsOf: [url], at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath]) })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            } else {
                let placeholderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "Cell"))
                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let url = provider as? URL {
                            placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                self.gallery?.images.insert(contentsOf: [url], at: insertionIndexPath.item)
                                collectionView.reloadData()
                            })
                        } else {
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }

    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        UIDropProposal(operation: .copy)
    }

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: NSURL.self) { nsurls in
            if let url = nsurls.first as? URL {
                self.gallery?.images.append(url)
            }
        }
    }
}
