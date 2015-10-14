//
//  Photo+CoreDataProperties.h
//  Pose
//
//  Created by Daniel Popov on 10/13/15.
//  Copyright © 2015 Crusoe Ventures. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Photo.h"

NS_ASSUME_NONNULL_BEGIN

@interface Photo (CoreDataProperties)

@property (nullable, nonatomic, retain) id image;

@end

NS_ASSUME_NONNULL_END
