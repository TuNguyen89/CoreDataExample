//
//  APLProductReviewViewController.m
//  SimpleTableView
//
//  Created by Harvey Nash on 5/31/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

#import "APLProductReviewViewController.h"
#import "APLBrand.h"
#import "APLAPIManager.h"

#define MAX_NUMBER_OF_REVIEW_PER_REQUEST        10

@interface APLProductReviewViewController ()

@end

@implementation APLProductReviewViewController

{
    NSString* productObjectId;
    NSMutableArray<APLProductReview*> *productReviewList;
    __weak IBOutlet UITableView* tableViewReference;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    productReviewList = [NSMutableArray new];
    
    [self fetchingProductReviewByNumberOfReivew: MAX_NUMBER_OF_REVIEW_PER_REQUEST];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return productReviewList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    APLProductReview* review = [productReviewList objectAtIndex:indexPath.row];
    
    UITableViewCell* viewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SystemTableViewId"];
    
    viewCell.textLabel.text = review.comment;
    viewCell.detailTextLabel.text = review.userObjectId;
    
    if( indexPath.row == (productReviewList.count - 1)) {
        [self fetchingProductReviewByNumberOfReivew:MAX_NUMBER_OF_REVIEW_PER_REQUEST];
    }
    
    return viewCell;
}

- (void)handleProductReview:(NSString *) objectId {
    productObjectId = objectId;
}

- (void)fetchingProductReviewByNumberOfReivew: (NSInteger) numberOfReview {
    //Get the list of product review
    APLAPIManager* manager =  [APLAPIManager sharedManager];
    
    //Create a query parameter with return number of predifined number of review
    NSDictionary* queryString = @{@"where": @{@"productID": @{@"__type": @"Pointer", @"className": @"Product", @"objectId": productObjectId}},
                                  @"where":@{@"userID": @{@"$exist": @true}}, //The user id should exist to make a comment valid
                                  @"where":@{@"comment": @{@"$exist": @true}}, // The comment also need be valid
                                  @"limit": [NSNumber numberWithInteger:numberOfReview],
                                  @"skip": [NSNumber numberWithInteger:productReviewList.count]};
    
    [manager getProductReviewsByQueryString:queryString completeBlock:^(BOOL isSuccess, id respondeObject, NSError* error) {
        
        if (isSuccess == TRUE) {
            
            [self convertJSONToReviewList: respondeObject];
            [tableViewReference reloadData];
        } else {
            
            NSLog(@"%@", respondeObject);
        }
        
    }];
}

- (void) convertJSONToReviewList: (id) respondedObject {
    
    
    NSArray* requestResult = [respondedObject objectForKey:@"results"];
    
    [requestResult enumerateObjectsUsingBlock:^(id reviewObj, NSUInteger index, BOOL* stop) {
       
        APLProductReview* productReview = [APLProductReview new];
        productReview.comment = [reviewObj objectForKey:@"comment"];
        productReview.rating  = [[reviewObj objectForKey:@"rating"] integerValue];
        productReview.userObjectId = [reviewObj objectForKey:@"userID"];
        
        //add the product review into review list
        [productReviewList addObject:productReview];
    }];
}


#pragma mark - Delegate

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
