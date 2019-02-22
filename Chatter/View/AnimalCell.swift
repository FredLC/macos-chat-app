//
//  AnimalCell.swift
//  Chatter
//
//  Created by Fred Lefevre on 2019-02-22.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Cocoa

class AnimalCell: NSCollectionViewItem {
    
    @IBOutlet weak var animalImage: NSImageView!
    
    override func viewDidAppear() {
        setupView()
    }
    
    func configureCell(index: Int, animalType: AnimalType) {
        if animalType == AnimalType.dark {
            animalImage.image = NSImage(named: "dark\(index)")
            view.layer?.backgroundColor = NSColor.lightGray.cgColor
        } else {
            animalImage.image = NSImage(named: "light\(index)")
            view.layer?.backgroundColor = NSColor.gray.cgColor
        }
    }
    
    func setupView() {
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
        view.layer?.cornerRadius = 10
        view.layer?.borderWidth = 2
        view.layer?.borderColor = NSColor.darkGray.cgColor
    }
    
}
