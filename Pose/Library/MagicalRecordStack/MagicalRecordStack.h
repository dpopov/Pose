//
//  MagicalRecordStack.h
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN
@interface MagicalRecordStack : NSObject

@property (nonatomic, copy) NSString *stackName;

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;
@property (nonatomic, strong) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, strong) NSPersistentStore *store;

@property (nonatomic, assign) BOOL loggingEnabled;
@property (nonatomic, assign) BOOL saveOnApplicationWillTerminate;
@property (nonatomic, assign) BOOL saveOnApplicationWillResignActive;

+ (__nullable instancetype) defaultStack;
+ (void) setDefaultStack:(MagicalRecordStack * __nullable)stack;

+ (instancetype) stack;

- (void) reset;

- (NSManagedObjectContext *) newConfinementContext;

- (void) setModelFromClass:(Class)modelClass;
- (void) setModelNamed:(NSString *)modelName;

@end
NS_ASSUME_NONNULL_END
