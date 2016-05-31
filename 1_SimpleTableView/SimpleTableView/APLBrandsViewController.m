
/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller that sets up the table view and serves as the table view's data source and delegate.
 */

#import "APLBrandsViewController.h"
#import "APLProductsViewController.h"
#import "APLCustomSimpleViewCell.h"
#import "APLBrand.h"

#import "APLAPIManager.h"

@interface APLBrandsViewController ()


@end

@implementation APLBrandsViewController

{
    NSMutableArray<APLBrand*>  *brandsList;
    //We need a weak reference of table view to reload the data
    __weak UITableView*        brandtableView;
    UIActivityIndicatorView*   brandLoadingIndicator;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Allocate a new mutable array
    brandsList = [NSMutableArray new];
    brandLoadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    brandLoadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    brandLoadingIndicator.center = self.view.center;
    //Show the loading indication animation
    [brandLoadingIndicator startAnimating];
    brandLoadingIndicator.backgroundColor = [UIColor whiteColor];
    
    //The the subview into table view controller
    [self initTableView];
    brandtableView.hidden = TRUE;
    [self.view addSubview:brandLoadingIndicator];
    
    //Loading brand list
    APLAPIManager* apiManager = [APLAPIManager sharedManager] ;
    [apiManager getBrandsListAll: ^(BOOL success, id responseObject, NSError* error){

        //stop and hide actitvity indicator and show an erro if loading brands returns either no item or error
        [brandLoadingIndicator stopAnimating];
        brandLoadingIndicator.hidden = TRUE;
        
        if (success) {
            [self convertJSONToBrandsList:responseObject];
            
            //After get data source finish, let reload the table view
            [brandtableView reloadData];
            brandtableView.hidden = FALSE;
            
        } else {
            NSLog(@"ERROR: %@", error);
        }
        
        //Show the resutl of loading to user
        UITextField* brandLoadingResultTxtFld = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        if (error || brandsList.count == 0) {
            if (error) {
                
                brandLoadingResultTxtFld.text = @"Error during loading brands";
            } else {
                brandLoadingResultTxtFld.text = @"No brand is available";
            }
            
            [self.view addSubview:brandLoadingResultTxtFld];
        } else {
            //[self initTableView];
        }
        
    }];
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of time zone names.
    return [brandsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *MyIdentifier = @"defaultTableViewCellId";

	/*
     Retrieve a cell with the given identifier from the table view.
     */
    UITableViewCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (!defaultCell)
    {
        
        defaultCell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    /*Get the Brand base on row index*/
    APLBrand* brand = [brandsList objectAtIndex:indexPath.row];
    
	// Set up the text for cell.
    defaultCell.textLabel.text = brand.brandName;
    //Set the Brand image for cell
    defaultCell.imageView.image = [UIImage imageNamed:brand.brandImage];
    //Make rectangle as square shape with height is 20 the image view
    defaultCell.imageView.frame = CGRectMake(0.0, 0.0, 70.0, 70.0);

	return defaultCell;
}

//When user select the row at index Path, open a new view controller within present table view
// for list of products
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    APLProductsViewController* productDetailVC = [[APLProductsViewController alloc]       initWithNibName:@"SimpleTableView" bundle:nil];
    
    //Get the selected brand
    NSString* selectedBrandId = [brandsList objectAtIndex:indexPath.row].brandId;
    
    // Let the product detail view controller know what brand indentifier it should get and show to user
    [productDetailVC handleProductDetail:selectedBrandId];
    [self.navigationController pushViewController:productDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}


- (void) initTableView {
    //Create a default table view and add it into the subview of view controller
    UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    //Set the data source and delegate to this view controller
    tableView.dataSource = self;
    tableView.delegate   = self;
    brandtableView = tableView;
    //Add to view
    [self.view addSubview:tableView];
}

#pragma mark - convert JSON to Brand list
- (void) convertJSONToBrandsList: (id) responseObject {
    
    if([responseObject isKindOfClass:[NSArray class]]) {
        //The response object JSON is an array
        NSLog(@"ERROR: do not support return value is an array");
    } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
        //The response object JSON is a dictionary
        NSArray* brandRequestResult = [responseObject objectForKey:@"results"];
        [brandRequestResult enumerateObjectsUsingBlock:^(id aBrand, NSUInteger idx, BOOL* stop) {
           
            //Each brand is a dictionary type, it has pair key-value for each attribute
            APLBrand* brand = [APLBrand new];
            brand.brandName = [aBrand objectForKey:@"name"];
            brand.brandId   = [aBrand objectForKey:@"objectId"];
            brand.brandDescription = [aBrand objectForKey:@"description"];
            
            //Adding to our data source
            [brandsList addObject:brand];
            
        }];
    }
}

@end
