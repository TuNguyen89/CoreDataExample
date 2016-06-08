//
//  APLCustomSimpleViewCell.m
//  SimpleTableView
//
//  Created by Tu Nguyen on 5/13/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@class APLProductAvailabilityStatusButton;

@interface APLProductTableViewCell : UITableViewCell

@property  (nonatomic, weak) IBOutlet UIImageView* productImage;
@property  (nonatomic, weak) IBOutlet UILabel* productName;
@property  (nonatomic, weak) IBOutlet UILabel* priceValue;
@property  (nonatomic, weak) IBOutlet APLProductAvailabilityStatusButton* productStatusBnt;
@end


@interface APLProductReviewTableViewCell : UITableViewCell

- initWithNibName: (NSString*) nibNameOrNil;

@property (nonatomic, weak) IBOutlet UILabel* userName;
@property (nonatomic, weak) IBOutlet HCSStarRatingView* ratingBar;
@property (nonatomic, weak) IBOutlet UILabel* userComment;

@end

@interface APLDefaultCellWithAutoFitHeight : UITableViewCell

- initWithNibName: (NSString*) nibNameOrNil;

@property (nonatomic, weak) IBOutlet UILabel* autoFitTextLabel;
@property (nonatomic, weak) IBOutlet UILabel* autoFitDetailTextLabel;

@end