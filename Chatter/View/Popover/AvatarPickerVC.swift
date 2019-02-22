//
//  AvatarPickerVC.swift
//  Chatter
//
//  Created by Fred Lefevre on 2019-02-22.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Cocoa

enum AnimalType {
    case dark
    case light
}

class AvatarPickerVC: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout {
    
    // Outlets
    @IBOutlet weak var segmentedControl: NSSegmentedControl!
    @IBOutlet weak var collectionView: NSCollectionView!
    
    // Variables
    var animalType = AnimalType.dark
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        if let selectedIndexPath = collectionView.selectionIndexPaths.first {
            if animalType == .dark {
                UserDataService.instance.avatarName = "dark\(selectedIndexPath.item)"
            } else {
                UserDataService.instance.avatarName = "light\(selectedIndexPath.item)"
            }
            view.window?.cancelOperation(nil)
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AnimalCell"), for: indexPath)
        guard let animalCell = cell as? AnimalCell else { return NSCollectionViewItem() }
        animalCell.configureCell(index: indexPath.item, animalType: animalType)
        return animalCell
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSMakeSize(85.0, 85.0)
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        if segmentedControl.selectedSegment == 0 {
            animalType = .dark
        } else {
            animalType = .light
        }
        collectionView.reloadData()
    }
    
}
