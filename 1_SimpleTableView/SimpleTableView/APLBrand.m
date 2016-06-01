//
//  APLBrand.m
//  SimpleTableView
//
//  Created by Tu Nguyen on 5/16/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

#import "APLBrand.h"

@implementation APLBrand


@end

@implementation APLProduct

- (instancetype) initWithProdId: (NSString*) prodId productImage: (NSString*) prodImage productName: (NSString*) prodName description:(NSString*) productDesciption price: (float) price {
    self = [super init];
    
    //Set the property for a product
    _productId = prodId;
    _imageName = prodImage;
    _productName = prodName;
    _productDescription = productDesciption;
    _productPrice = price;
    
    return self;
}

@end

@implementation APLProductReview


@end