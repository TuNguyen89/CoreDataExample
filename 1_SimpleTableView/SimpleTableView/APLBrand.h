//
//  APLBrand.h
//  SimpleTableView
//
//  Created by Tu Nguyen on 5/16/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APLProduct : NSObject
typedef NS_ENUM(NSInteger, ProductAvailabilityStatus) {
    ProductAvailabilityStatusUnknown,
    ProductAvailabilityStatusInstock,
    ProductAvailabilityStatusOutstock,
    ProductAvailabilityStatusArchived
    
};

@property ProductAvailabilityStatus productStatus;
@property NSString*                 brandId;
@property NSString*                 productId;
@property NSString*                 imageName;
@property NSString*                 productName;
@property NSString*                 productDescription;
@property float                     productPrice;

- (instancetype) initWithProdId: (NSString*) prodId productImage: (NSString*) prodImage productName: (NSString*) prodName description:(NSString*) productDesciption price: (float) price;

@end


@interface APLBrand : NSObject

@property NSString  *brandId;
@property NSString  *brandImage;
@property NSString  *brandName;
@property NSString  *brandDescription;

@end


@interface APLProductReview : NSObject

@property NSInteger             rating;
@property (nonatomic) NSString* comment;
@property (nonatomic) NSString* productObjectId;
@property (nonatomic )id        userObjectId;

@end
