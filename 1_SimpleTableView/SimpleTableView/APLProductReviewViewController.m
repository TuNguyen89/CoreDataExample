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
#import "APLCustomViewCells.h"

#define MAX_NUMBER_OF_REVIEW_PER_REQUEST        10

typedef NS_ENUM(NSInteger, ProductSectionType) {
    ProductSectionTypeAboutThisItem,
    ProductSectionTypeCustomerReviews,
    ProductSectionTypeMax
    
};


@interface APLProductReviewViewController ()

@end

@implementation APLProductReviewViewController

{
    id productObjectId;
    NSMutableArray<APLProductReview*> *productReviewList;
    NSArray                           *userList;
    __weak IBOutlet UITableView* tableViewReference;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureTableView];
    productReviewList = [NSMutableArray new];
    userList          = [NSMutableArray new];
    
    [self fetchUser];
    [self fetchingProductReviewByNumberOfReivew: MAX_NUMBER_OF_REVIEW_PER_REQUEST];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ProductSectionTypeMax;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRow = 0;
    switch (section) {
        case ProductSectionTypeAboutThisItem:
            numberOfRow = 1;
            break;
        case ProductSectionTypeCustomerReviews:
            numberOfRow =  productReviewList.count;
            break;
        default:
            break;
    }
    
    return numberOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* resultCell = nil;
    
    switch (indexPath.section) {
        case ProductSectionTypeCustomerReviews:
            resultCell = [self buildTableViewCellForProductReview:tableView];
            break;
        case ProductSectionTypeAboutThisItem:
            resultCell = [self buildTableViewCellForAboutThisItem];
            break;
        default:
            resultCell = [UITableViewCell new];
            break;
    }

    return resultCell;
}

- (UITableViewCell* ) buildTableViewCellForProductReview: (UITableView*) tableView {
    static NSString* reusedCellId = @"ReviewTbCellId";
    APLProducReviewTableViewCell* reviewTableViewCell = [tableView dequeueReusableCellWithIdentifier:reusedCellId];
    
    if (reviewTableViewCell) {
        return reviewTableViewCell;
    } else {
        return [[APLProducReviewTableViewCell alloc] initWithNibName:@"ReviewTableViewCell"];
    }

}

- (UITableViewCell*) buildTableViewCellForAboutThisItem {
    APLDefaultCellWithAutoFitHeight* resultCell = [[APLDefaultCellWithAutoFitHeight alloc] initWithNibName:@"DefaultCellWithAutoFitHeight"];
    
    resultCell.autoFitTextLabel.text = @"Description";
    resultCell.autoFitDetailTextLabel.text = [productObjectId valueForKey:@"productDescription"];

    return resultCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if ([cell isKindOfClass: [APLProducReviewTableViewCell class]])
    {
        APLProducReviewTableViewCell* reviewTableViewCell = (APLProducReviewTableViewCell*) cell;
        
        @try {
    
            if (indexPath.section == ProductSectionTypeCustomerReviews && productReviewList.count) {
                APLProductReview* review = [productReviewList objectAtIndex:indexPath.row];

                if (!reviewTableViewCell)
                {
                    //Create the new table view cell if it doesn't existing in table
                    reviewTableViewCell = [[APLProducReviewTableViewCell alloc] initWithNibName:@"ReviewTableViewCell"];

                }

                reviewTableViewCell.userComment.text = review.comment;
                
                [userList enumerateObjectsUsingBlock:^(id userObject, NSUInteger index, BOOL* stop) {
                   
                    if([[userObject objectForKey:@"objectId"] isEqual:[review.userObjectId objectForKey:@"objectId"]]) {
                        reviewTableViewCell.userName.text = [userObject objectForKey:@"userName"] ? [userObject objectForKey:@"userName"] : [userObject objectForKey:@"email"];
                        //Stop if we found the object ID
                        *stop = TRUE;
                    }
                }];
            
                reviewTableViewCell.ratingBar.value  = (review.rating % 10) / 2.00;

                if( indexPath.row == (productReviewList.count - 1)) {
                    [self fetchingProductReviewByNumberOfReivew:MAX_NUMBER_OF_REVIEW_PER_REQUEST];
                }

            }
        } @catch (NSException* exception) {
            NSLog(@"%@", exception);
        } @finally {
            
        }
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case ProductSectionTypeAboutThisItem:
            return @"About this item";
        case ProductSectionTypeCustomerReviews:
            return @"Customer Reviews";
        default:
            return @"Default section";
            break;
    }
    
    return @"should not reach here!!!";
}

- (void)handleProductReview:(id) objectId {
    productObjectId = objectId;
    
    //Create the add review button
    
}

- (void) fetchUser {
    APLAPIManager* manager =  [APLAPIManager sharedManager];
    [manager getUserListAll:^(BOOL isSuccess, id respondeObject, NSError* error) {
       
        if (isSuccess) {
            userList = [respondeObject objectForKey:@"results"];
            [tableViewReference reloadData];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)fetchingProductReviewByNumberOfReivew: (NSInteger) numberOfReview {
    //Get the list of product review
    APLAPIManager* manager =  [APLAPIManager sharedManager];
    
    //Create a query parameter with return number of predifined number of review
    NSDictionary* queryString = @{@"where": @{@"productID": @{@"__type": @"Pointer", @"className": @"Product", @"objectId": [productObjectId valueForKey:@"productId"]}},
                                  @"where":@{@"userID": @{@"$exist": @true}}, //The user id should exist to make a comment valid
                                  @"where":@{@"comment": @{@"$exist": @true}}, // The comment also need be valid
                                  @"where": @{@"rating": @{@"$exist": @true}},
                                  @"order": @"-createdAt",
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
        
        if (![productReview.comment isEqualToString:@""] &&                  // Comment should not empty
            productReview.rating <= 10 && productReview.rating >= 0 &&       // Rating between [0 - 10]
            productReview.userObjectId != [NSNull null]) {                   // The userID also need be to be not null
            //add the product review into review list
            [productReviewList addObject:productReview];
        }
    }];
}


#pragma mark - configure table view cell auto height resizing

- (void) configureTableView {
    tableViewReference.rowHeight = UITableViewAutomaticDimension;
    tableViewReference.estimatedRowHeight = 160;
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
