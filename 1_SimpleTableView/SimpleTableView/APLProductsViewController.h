//
//  APLProductDetailViewController.h
//  SimpleTableView
//
//  Created by Tu Nguyen on 5/16/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APLBrand.h"

@interface APLProductsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (void) handleProductDetail: (NSString*) brandId;

@end

@interface APLProductAvailabilityStatusButton : UIButton
@property (setter=setProductStatus:, nonatomic, assign) ProductAvailabilityStatus availabilityStatus;
@end