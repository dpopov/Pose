//
//  Photo+CoreDataProperties.swift
//  Pose
//
//  Created by Daniel Popov on 10/12/15.
//  Copyright © 2015 Crusoe Ventures. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import UIKit
import CoreData

extension Photo {
    @NSManaged var image: UIImage?
}
