//
//  APLBrandsModel.h
//  SimpleTableView
//
//  Created by Tu Nguyen on 5/16/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APLBrand.h"

@interface APLBrandsModel : NSObject


- (NSArray*)   getBrandList;

// Insert a brand into the list and return it;
- (APLBrand*)  insertBrand: (APLBrand*) a_brands;
- (void) buidBrandsModel;
- (APLBrand*) getBrandById: (NSInteger*) brandId;

@end
