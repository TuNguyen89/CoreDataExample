//
//  APLCustomSimpleViewCell.m
//  SimpleTableView
//
//  Created by Tu Nguyen on 5/13/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APLCustomViewCells.h"


@implementation APLProductTableViewCell


@end

@implementation APLProductReviewTableViewCell

- (id)initWithNibName:(NSString *)nibNameOrNil {
    self = [super init];
    
    id objectFromNib = [[[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:self options:nil] objectAtIndex:0];
    //If the owner of nib loaded is a kind of APLProducReviewTableViewCell
    if ([objectFromNib isKindOfClass:[APLProductReviewTableViewCell class]]) {
        self = objectFromNib;
    } else {
        self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SystemCellId"];
    }
    
    return self;
}

@end

@implementation APLDefaultCellWithAutoFitHeight

- (id)initWithNibName:(NSString *)nibNameOrNil {
    self = [super init];
    
    id objectFromNib = [[[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:self options:nil] objectAtIndex:0];
    //If the owner of nib loaded is a kind of APLDefaultCellWithAutoFitHeight
    if ([objectFromNib isKindOfClass:[APLDefaultCellWithAutoFitHeight class]]) {
        self = objectFromNib;
    } else {
        self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SystemCellId"];
    }
    
    return self;
}

@end