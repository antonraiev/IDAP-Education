//
//  FFUsersData.m
//  FacebookFriends
//
//  Created by Anton Rayev on 3/20/14.
//  Copyright (c) 2014 Anton Rayev. All rights reserved.
//

#import "FFUsers.h"

#import "FFUsers.h"

static NSString * const kFFStorageFileName = @"kFFStorageFileName.plist";
static NSString * const kFFCacheFolder	   = @"Caches";

@interface FFUsers ()
@property (nonatomic, retain)	NSMutableArray	*mutableUsers;

@end

@implementation FFUsers

@dynamic users;
@dynamic savePath;

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)cleanup {
	[self save];
	self.mutableUsers = nil;
}

- (id)init {
    self = [super init];
    if (self) {
        self.mutableUsers = [NSMutableArray array];
    }
	
    return self;
}

#pragma mark -
#pragma mark Accessors

- (NSArray *)users {
	return [[self.mutableUsers copy] autorelease];
}

- (NSString *)savePath {
	NSString *libraryPath = [NSFileManager libraryDirectoryPath];
	NSString *cachePath = [libraryPath stringByAppendingPathComponent:kFFCacheFolder];
	
	return [cachePath stringByAppendingPathComponent:kFFStorageFileName];
}

#pragma mark -
#pragma mark Public

- (void)addUser:(FFUser *)user {
	[self.mutableUsers addObject:user];
}

- (void)removeUser:(FFUser *)user {
	[self.mutableUsers removeObject:user];
}

#pragma mark -
#pragma mark Private

- (void)performLoading {
	self.mutableUsers = [NSKeyedUnarchiver unarchiveObjectWithFile:self.savePath];
	
	[self finishLoading];
}

- (void)save {
	[NSKeyedArchiver archiveRootObject:self.mutableUsers toFile:self.savePath];
}

@end