//
//  APLAddingReviewViewController.m
//  SimpleTableView
//
//  Created by Tu Nguyen on 6/7/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

#import "APLAddingReviewViewController.h"
#import "HCSStarRatingView.h"
#import "APLAPIManager.h"
#import "APLProductReviewViewController.h"

@interface APLAddingReviewViewController ()

@property (nonatomic, weak) IBOutlet HCSStarRatingView* ratingBar;
@property (nonatomic, weak) IBOutlet UITextView*        productComment;
@property (nonatomic, weak) IBOutlet UITextField*       userName, *userEmail;

@end

@implementation APLAddingReviewViewController

{
    id productObject;
    NSArray                           *userList; // JSON response from server
    
    UIAlertView* notification;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    userList          = [NSMutableArray new];
    [self fetchUser];
    
    //Create an alter
    notification = [[UIAlertView alloc] initWithTitle:@"Add review" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //Adding a save button
    //adding adde review button
    UIBarButtonItem *saveBnt = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveReview:)];
    self.navigationItem.rightBarButtonItem = saveBnt;
}

- (IBAction)saveReview :(id)sender {
    //Make the post comment to push the review
    NSString* userObjectId = [self lookUpUserObject];
    if (userObjectId) {
        //If the userId already existed on the list user
        [self postReviewWithUserObjectId: userObjectId];
    } else {
        //If the userEmail doesnot exist yet, create the new one
        if(![_userEmail.text isEqualToString:@""] && ![_userName.text isEqualToString:@""]) {
            NSDictionary* addUserPostString = @{@"email": _userEmail.text, @"userName": _userName.text};
            
            APLAPIManager* manager =  [APLAPIManager sharedManager];
            [manager postUser:addUserPostString completeBlock:^ (BOOL isSuccess, id respondeObj, NSError* err) {
                if (isSuccess) {
                    [self postReviewWithUserObjectId: [respondeObj objectForKey:@"objectId"]];
                    
                } else {
                    notification.message = @"User information is invalid";
                    NSLog(@"Adding user failure error: %@", err);
                    [notification show];
                }
                
            }];
        } else {
            notification.message = @"Insert user name and user email";
            [notification show];
        }
    }
    
}

- (void) postReviewWithUserObjectId: (NSString*) userObjectId {
    
    APLAPIManager* manager =  [APLAPIManager sharedManager];
    NSDictionary* productReviewPost = [self buildProductReviewPostStringWithUserObjectId: userObjectId];
    [manager postProductReviewReview: productReviewPost completeBlock:^ (BOOL isSuccess, id respondeObj, NSError* err) {
        if (isSuccess) {
            notification.message = @"Thanks for your review";
        } else {
            notification.message = @"Add review failure";
            NSLog(@"Add review failure %@", err);
        }
        [notification show];
    }];
}

- (NSString*) lookUpUserObject {
    
    __block NSString* result = nil;
    NSString* userEmail = _userEmail.text;

    [userList enumerateObjectsUsingBlock:^(id userObject, NSUInteger index, BOOL* stop) {
        
        if([[userObject objectForKey:@"email"] isEqual: userEmail]) {
            result = [userObject objectForKey:@"objectId"];
            *stop = TRUE;
        }
    }];
    
    return result;
}

- (void) fetchUser {
    APLAPIManager* manager =  [APLAPIManager sharedManager];
    [manager getUserListAll:^(BOOL isSuccess, id respondeObject, NSError* error) {
        
        if (isSuccess) {
            userList = [respondeObject objectForKey:@"results"];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (NSDictionary*) buildProductReviewPostStringWithUserObjectId: (nonnull NSString*) userObjectId{
    
    //Make the post comment to push the review
    NSString*  commet = _productComment.text;
    NSNumber*  rating = [NSNumber numberWithFloat:(_ratingBar.value * 2.00f)];
    
    NSDictionary* postString = @{@"comment": commet, @"rating": rating, @"productID": @{ @"__type": @"Pointer", @"className": @"Product", @"objectId": [productObject valueForKey:@"productId"]}, @"userID": @{ @"__type": @"Pointer", @"className": @"User", @"objectId": userObjectId}};
    
    
    return postString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) handleAddReviewForProduct: (id) objectId {
    productObject = objectId;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(alertView.cancelButtonIndex ==  buttonIndex) {
        id productReviewVC = [self.navigationController popViewControllerAnimated:TRUE];
    }
}

@end
