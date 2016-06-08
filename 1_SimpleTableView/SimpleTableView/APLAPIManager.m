//
//  APLAPIManager.m
//  SimpleTableView
//
//  Created by Tu Nguyen on 5/26/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

#import "APLAPIManager.h"
#import "AFNetworking.h"

@implementation APLAPIManager


// The share instance accross application of API manager
static APLAPIManager* sharedInstance;
static NSDictionary* parseProperties;
static AFHTTPSessionManager* manager;


+ (APLAPIManager* )sharedManager {
    
    if (!sharedInstance) {
        sharedInstance = [[APLAPIManager alloc] init];
        [sharedInstance initManagerDefault];
    }
    return sharedInstance;
}

- (void) initManagerDefault {
    
    //Search the parse plist file to get configuration
    NSString* plistPath = nil;
    NSError* error = nil;
    NSPropertyListFormat outFormat;
    NSString* rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingString:@"parseAPI.plist"];
    
    //Try to locate the parseAPI.plist in our bundle. If it doesn't exist delegate to file manager to
    // locate parseAPI.plist
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"parseAPI" ofType:@"plist"];
    }
    
    NSData* plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    parseProperties = (NSDictionary*) [NSPropertyListSerialization propertyListWithData:plistXML options:NSPropertyListImmutable format:&outFormat error:&error];
    
    if (error) {
        NSLog(@"Error while loading %@: detail %@", plistPath, error);
    }
    
    //Set default header for URL session request
    //Pair of key-value cache control
    NSString* cacheControlKeyString = @"Cache-Control";
    
    //Pair of key-value of Content-type
    NSString* contentTypeKeyString = @"Content-Type";
    
    //Pair key-value of application Id Key
    NSString* applicationIdKeyString = @"X-Parse-Application-Id";
    
    //Pair key-value of rest API key
    NSString* restAPIKeyString = @"X-Parse-Rest-Api-Key";
    
    manager = [AFHTTPSessionManager manager];
    
    AFJSONRequestSerializer *jsonRequest = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    manager.requestSerializer = jsonRequest;
    
    [manager.requestSerializer setValue:[parseProperties objectForKey:cacheControlKeyString]  forHTTPHeaderField:cacheControlKeyString];
    [manager.requestSerializer setValue:[parseProperties objectForKey:contentTypeKeyString] forHTTPHeaderField:contentTypeKeyString];
    [manager.requestSerializer setValue:[parseProperties objectForKey:applicationIdKeyString] forHTTPHeaderField:applicationIdKeyString];
    [manager.requestSerializer setValue:[parseProperties objectForKey:restAPIKeyString] forHTTPHeaderField:restAPIKeyString];
}

- (void) getBrandsListAll: (requestComppletionBlock) completion {
    
    NSURL* brandURLRequest = [NSURL URLWithString: [NSString stringWithFormat:@"%@/%@", [parseProperties objectForKey:@"Parse-Base-URL"], [parseProperties objectForKey:@"Brand-Relative-URL"]]];
    [manager GET:brandURLRequest.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask* task, id respondeObject) {
        completion(TRUE, respondeObject, nil);
    } failure: ^(NSURLSessionTask* task, NSError* error)  {
        completion(FALSE, nil, error);
        
    }];
    
}
- (void) getProductListALl: (requestComppletionBlock) completion {
    
    //Create a url for brands
    NSURL* productURLRequest = [NSURL URLWithString:
                             [NSString stringWithFormat:@"%@/%@", [parseProperties objectForKey:@"Parse-Base-URL"], [parseProperties objectForKey:@"Product-Relative-URL"]]];

    [manager GET:productURLRequest.absoluteString parameters:nil progress:nil
     
       success:^(NSURLSessionDataTask* task, id responseObject) {
        //Call the block to return the result, in this case return SUCCESS
           completion(TRUE, responseObject, nil);
        
    } failure: ^(NSURLSessionDataTask* task, NSError* error) {
        completion(FALSE, nil, error);
    }];
    
}

- (void) getProductReviewsByQueryString: (NSDictionary*) queryString completeBlock:(requestComppletionBlock)completion {
    NSURL* productReviewsURLRequest = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [parseProperties objectForKey:@"Parse-Base-URL"], [parseProperties objectForKey:@"Review-Relative-URL"]]];
    
    [manager GET:productReviewsURLRequest.absoluteString parameters:queryString progress:nil success:^(NSURLSessionDataTask* task, id responseObject) {
        completion(TRUE, responseObject, nil);
        
    } failure: ^(NSURLSessionDataTask* task , NSError* error) {
        completion(FALSE, nil, error);
    }];
}

- (void) getProductListByBrandId: (requestComppletionBlock) completion {
    
    completion(TRUE, nil, nil);
}

- (void) getUserListAll:(requestComppletionBlock)completion {
    
    NSURL* userURLRequest = [NSURL URLWithString: [NSString stringWithFormat: @"%@/%@", [parseProperties objectForKey:@"Parse-Base-URL"], [parseProperties objectForKey:@"User-Relative-URL"]]];
    
    [manager GET:userURLRequest.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask* task, id responseObject) {
        completion(TRUE, responseObject, nil);
        
    } failure: ^(NSURLSessionDataTask* task , NSError* error) {
        completion(FALSE, nil, error);
    }];
    
}

#pragma mark - POST a review

- (void)postProductReviewReview:(NSDictionary *)postString completeBlock:(requestComppletionBlock)completion {
    
    NSURL* productReviewPost = [NSURL URLWithString: [NSString stringWithFormat: @"%@/%@", [parseProperties objectForKey:@"Parse-Base-URL"], [parseProperties objectForKey:@"Review-Relative-URL"]]];
    
    [manager POST:productReviewPost.absoluteString parameters:postString progress:nil success:^(NSURLSessionDataTask* task, id responseObject) {
        completion(TRUE, responseObject, nil);
        
    } failure: ^(NSURLSessionDataTask* task , NSError* error) {
        completion(FALSE, nil, error);
    }];
    
}

#pragma mark - Add a user

- (void)postUser:(NSDictionary *)postString completeBlock:(requestComppletionBlock)completion {
    
    NSURL* userPost = [NSURL URLWithString: [NSString stringWithFormat: @"%@/%@", [parseProperties objectForKey:@"Parse-Base-URL"], [parseProperties objectForKey:@"User-Relative-URL"]]];
    
    [manager POST:userPost.absoluteString parameters:postString progress:nil success:^(NSURLSessionDataTask* task, id responseObject) {
        completion(TRUE, responseObject, nil);
        
    } failure: ^(NSURLSessionDataTask* task , NSError* error) {
        completion(FALSE, nil, error);
    }];
    
}

@end
