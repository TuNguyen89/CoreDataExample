//
//  APLBrandsModel.m
//  SimpleTableView
//
//  Created by Tu Nguyen on 5/16/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

#import "APLBrandsModel.h"

@implementation APLBrandsModel

{
    NSMutableArray* listBrands;
}

- (instancetype)init {
    self = [super init];
    listBrands = [[NSMutableArray alloc] init];
    return self;
}

- (NSArray*) getBrandList {
    return listBrands;
}

- (APLBrand *)insertBrand:(APLBrand *)a_brands {
    
    [listBrands addObject:a_brands];
    return a_brands;
}

- (APLBrand *)getBrandById:(NSInteger *)brandId {
    

    
    
    return nil;
}

- (void)buidBrandsModel {
    //  Build Model
    //Load the data model
    // Create three brands and their products perspective
}

@end
