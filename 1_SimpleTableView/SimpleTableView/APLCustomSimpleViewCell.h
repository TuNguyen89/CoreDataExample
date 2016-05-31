//
//  APLCustomSimpleViewCell.m
//  SimpleTableView
//
//  Created by Tu Nguyen on 5/13/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class APLProductAvailabilityStatusButton;

@interface APLCustomTableViewCell : UITableViewCell

@property  IBOutlet UIImageView* productImage;
@property  IBOutlet UILabel* productName;
@property  IBOutlet UILabel* priceValue;
@property  IBOutlet APLProductAvailabilityStatusButton* productStatusBnt;
@end