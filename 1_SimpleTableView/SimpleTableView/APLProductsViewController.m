//
//  APLProductDetailViewController.m
//  SimpleTableView
//
//  Created by Tu Nguyen on 5/16/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

#import "APLProductsViewController.h"
#import "APLCustomViewCells.h"
#import "APLAPIManager.h"

#import "APLProductReviewViewController.h"

@implementation APLProductsViewController

{
    NSString* brandId;
    NSMutableArray<APLProduct*> *productsList;
    __weak IBOutlet UITableView *tableViewOnController;
    UIActivityIndicatorView* productLoadingIndicator;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    tableViewOnController.rowHeight = UITableViewAutomaticDimension;
    tableViewOnController.estimatedRowHeight = 100.0;
    
    //Initilaze an indicator using for loading data.
    productLoadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(0, 0, 40, 40)];
    productLoadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    productLoadingIndicator.center = self.view.center;
    [self.view addSubview:productLoadingIndicator];
    [productLoadingIndicator startAnimating];
    
    // init the product list
    productsList = [NSMutableArray new];
    
    [[APLAPIManager sharedManager] getProductListALl:^(BOOL success, id responseObject, NSError* error) {
      
        //Stop the loading indicator as request is finished
        [productLoadingIndicator stopAnimating];
        if (success) {
            [self convertJSONToProductsList:responseObject];
            [tableViewOnController reloadData];
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return productsList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    APLProductTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"CustomViewCellId"];
    APLProduct* productAtIndexPath = [productsList objectAtIndex: indexPath.row];
    
    if (!customCell) {
        
        NSArray* objFromNib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        
        if ( [[objFromNib objectAtIndex:0] class] == ([APLProductTableViewCell class])) {
            customCell = [objFromNib objectAtIndex:0];
        } else {
            //Create the default custom cell
            customCell = [[APLProductTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
    }
    
    //if the brand have receive from another view controller e.g. produc view controller
    if (productAtIndexPath) {
        customCell.productName.text = productAtIndexPath.productName;
        customCell.priceValue.text = [NSString stringWithFormat:@"%.2f $", productAtIndexPath.productPrice];
        customCell.productStatusBnt.availabilityStatus = productAtIndexPath.productStatus;
        
    } else {
        
    }
    
    return customCell;
}

- (void)handleProductDetail:(NSString *) aBrandId {
    brandId = aBrandId;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //TODO something wrong with product review controller
    
    APLProductReviewViewController* productReviewVC = [[APLProductReviewViewController alloc] initWithNibName:@"ProductReviewView" bundle:nil];
    [productReviewVC handleProductReview: [productsList objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:productReviewVC animated:TRUE];

}

#pragma mark - convert JSON to Product list

- (void) convertJSONToProductsList: (id) responseObject {
    
    if([responseObject isKindOfClass:[NSArray class]]) {
        //The response object JSON is an array
        NSLog(@"ERROR: do not support return value is an array");
    } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
        //The response object JSON is a dictionary
        NSArray* brandRequestResult = [responseObject objectForKey:@"results"];
        [brandRequestResult enumerateObjectsUsingBlock:^(id aProduct, NSUInteger idx, BOOL* stop) {
            
            //Each brand is a dictionary type, it have pair key-value for each attribute
            APLProduct* product = [APLProduct new];
            product.productId = [aProduct objectForKey:@"objectId"];
            product.productName   = [aProduct objectForKey:@"productName"];
            product.productDescription = [aProduct objectForKey:@"description"];
            product.brandId            = [[aProduct objectForKey:@"brandID"] objectForKey:@"objectId"];
            product.productPrice       = [[aProduct objectForKey:@"price"] floatValue];

            
            static NSDictionary* statusLookUp =nil;
            
            //Work arround to make compiler happy in case it does not recognize enum
            if(!statusLookUp)
            {
                
                statusLookUp =  @{@"INSTOCK": @(ProductAvailabilityStatusInstock),
                                  @"OUTSTOCK": @(ProductAvailabilityStatusOutstock),
                                  @"ARCHIVED" : @(ProductAvailabilityStatusArchived)};
            }
            
            //If the key availabilityStatus doen't exist, meaning that status is unknown
            NSString* statusString = [aProduct objectForKey:@"availabilityStatus"];
            product.productStatus = (ProductAvailabilityStatus) [[statusLookUp objectForKey:statusString] integerValue];
            
            product.brandId = [[aProduct objectForKey:@"brandID"] objectForKey:@"objectId"];
            
            //The result should has following property, otherwise ignore this product becuase invalid formatting
            if (!(product.productName && product.description && product.productId))
            {
                NSLog(@"ERROR, product formating isn't correct");
            } else if(brandId && [brandId isEqual:product.brandId]) {
            //Adding to our data source
                [productsList addObject:product];
            }
            
        }];
    }

}

@end


#pragma custom button which show the availabitily

@implementation APLProductAvailabilityStatusButton

- (instancetype)init {
    self = [super init];
    
    _availabilityStatus = ProductAvailabilityStatusUnknown;
    return self;
}

- (void) setProductStatus: (ProductAvailabilityStatus) productStatus {
    _availabilityStatus = productStatus;
    
    switch (_availabilityStatus) {
        case ProductAvailabilityStatusInstock:
            //Change the button as in stock type
            [self setTitleColor:[UIColor greenColor] forState:UIControlStateNormal] ;
            [self setTitle:@"In Stock" forState:UIControlStateNormal] ;
            break;
        case ProductAvailabilityStatusOutstock:
            [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self setTitle:@"Out Stock" forState:UIControlStateNormal];
            break;
            
        case ProductAvailabilityStatusArchived:
            [self setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
            [self setTitle:@"Archived" forState:UIControlStateNormal];
            break;
        case ProductAvailabilityStatusUnknown:
            //go throught
        default:
            
            [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self setTitle:@"Unknown status" forState:UIControlStateNormal];
            break;
    }
}

@end
