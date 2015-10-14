//
//  Photo.h
//  Pose
//
//  Created by Daniel Popov on 10/13/15.
//  Copyright © 2015 Crusoe Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Photo : NSManagedObject

+(void)addPhoto:(UIImage*_Nullable)image;

@end

NS_ASSUME_NONNULL_END

#import "Photo+CoreDataProperties.h"
