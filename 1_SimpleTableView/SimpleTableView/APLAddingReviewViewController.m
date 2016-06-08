//
//  APLAddingReviewViewController.m
//  SimpleTableView
//
//  Created by Tu Nguyen on 6/7/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

#import "APLAddingReviewViewController.h"
#import "HCSStarRatingView.h"

@interface APLAddingReviewViewController ()

@property (nonatomic, weak) IBOutlet HCSStarRatingView* ratingBar;
@property (nonatomic, weak) IBOutlet UITextView*        productComment;
@property (nonatomic, weak) IBOutlet UITextField*       userName, *userEmail;

@end

@implementation APLAddingReviewViewController

{
    id productObject;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Adding a save button
    //adding adde review button
    UIBarButtonItem *saveBnt = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveReview:)];
    self.navigationItem.rightBarButtonItem = saveBnt;
}

- (IBAction)saveReview :(id)sender {
    
    
    //Make the post comment to push the review
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) handleAddReviewForProduct: (id) objectId {
    productObject = objectId;
}

@end
