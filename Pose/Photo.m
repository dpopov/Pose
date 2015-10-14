//
//  Photo.m
//  Pose
//
//  Created by Daniel Popov on 10/13/15.
//  Copyright © 2015 Crusoe Ventures. All rights reserved.
//

#import "Photo.h"

@implementation Photo

+(void)addPhoto:(UIImage*)image{
    NSManagedObjectContext *save = [MagicalRecordStack defaultStack].newConfinementContext;
    Photo *photo = [Photo MR_createEntityInContext:save];
    photo.image = image;
    [save MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError * _Nullable error) {}];
}

@end
