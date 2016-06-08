//
//  APLAPIManager.h
//  SimpleTableView
//
//  Created by Tu Nguyen on 5/26/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


//The API manager is singeton class, it's responbility for make the connection to our Server
// and get the nessarily information.

@interface APLAPIManager : NSObject

// Declare a request complete block which help to give a callback funtion
// The caller should have responsebility to implement this block.
typedef void(^requestComppletionBlock)(BOOL, id, NSError*);

//The function to get shared manager
+ (APLAPIManager*) sharedManager;

- (void) getBrandsListAll: (requestComppletionBlock) completion;
- (void) getProductListALl:(requestComppletionBlock) completion;
- (void) getProductListByBrandId:(requestComppletionBlock) completion;
- (void) getProductReviewsByQueryString: (NSDictionary*) queryString completeBlock: (requestComppletionBlock) completion;
- (void) getUserListAll: (requestComppletionBlock) completion;


#pragma mark - POST a comment

- (void) postProductReviewReview: (NSDictionary*) postString completeBlock: (requestComppletionBlock) completion;
- (void) postUser: (NSDictionary*) postString completeBlock: (requestComppletionBlock) completion;

@end
