//
//  DevicesTableViewController.m
//  MyStore
//
//  Created by Tu Nguyen on 5/23/16.
//  Copyright © 2016 Tu Nguyen. All rights reserved.
//

#import "DevicesTableViewController.h"
#import "DeviceDetailViewController.h"
#import <CoreData/CoreData.h>

@interface DevicesTableViewController ()

@property (strong) NSMutableArray* devices;
@property (strong) NSMutableArray* searchedDevices;

@end

@implementation DevicesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    
    NSManagedObjectContext* context = [self managedObjectContext];
    //get the device from database to application
    NSFetchRequest* fetchRequest  = [[NSFetchRequest alloc] initWithEntityName:@"Device"];
    
    //Simulate the search bar
//    NSString* deviceName = @"i";
//    [fetchRequest setPredicate: [NSPredicate predicateWithFormat:@"name contains %@", deviceName]];
    
    self.devices = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//Handle for delete a row in table view
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObjectContext* context = [self managedObjectContext];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSManagedObject* device = [self.devices objectAtIndex:indexPath.row];
        //Delete the entity at database via context
        [context deleteObject:device];
    }
    
    if (! [context save:nil] ) {
    
        NSLog(@"Can't save the data ");
        return;
    }
    
    //If the saving return success, then update the table view
    [_devices removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths: [NSArray arrayWithObjects: indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    
}

//the height of table view cell should be same in orgin table view as well as search result
// table view
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

#pragma mark - Segue preparation for edit a divice information

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // If the seque indentity is show for editing, let pass the device information to
    // device detail information
    if ([segue.identifier  isEqual: @"ShowForEditing"]) {
        
        //Get the device entity (mo) based on the selected row index in table view
        NSManagedObject* device = [_devices objectAtIndex: [[self tableView] indexPathForSelectedRow].row];
        
        ((DeviceDetailViewController*) segue.destinationViewController).device = device;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
 
    [self performSegueWithIdentifier:@"ShowForEditing" sender:self];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //Only one section in our table
    return 1;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //The number of row in section equal to number of device which fetched from database
    if (tableView == self.tableView) {
        return self.devices.count;
    } else if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchedDevices.count;
    } else {
        return 0;
    }
    //return _devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellId = @"defaultCellId";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        NSManagedObject* device = nil;
        cell = [UITableViewCell new];
        
        // the context of table view cell depended on what type of result should be displayed
        // If the table view of device view controller need be be reloadded then reload the whole list of
        // device
        // If the table view of search result table view, then reloadded the searched result by search bar
        if (self.tableView == tableView) {
            
            device = [self.devices objectAtIndex:indexPath.row];

        } else if (self.searchDisplayController.searchResultsTableView == tableView) {
            device = [_searchedDevices objectAtIndex:indexPath.row];
        }
        
        //Fill the context for table view cell
        if (device)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [device valueForKey:@"name"], [device valueForKey:@"version"]];
            
            cell.detailTextLabel.text = [device valueForKey:@"company"];
        } else {
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
        }
    }
    return cell;
}

- (NSManagedObjectContext*) managedObjectContext {
    NSManagedObjectContext* context = nil;
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

#pragma mark - search bar search handling

// Write the function to reload the data e.g. the device entity from database.
// The condition for this query is name
-  (void) filterContextWithSearchText: (NSString*) searchForNameText {
    
    NSManagedObjectContext* context =  [self managedObjectContext];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Device"];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat: @"(name contains[c] %@) OR (version contains[c] %@)", searchForNameText, searchForNameText]];
    
    NSError* err = nil;
    _searchedDevices =  [[context executeFetchRequest:fetchRequest error:&err] mutableCopy];
    
    if (err) {
        NSLog(@"Could load device name = %@ with error %@", searchForNameText, [err description]);
    }

}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    //Filter the device result base on search for name of device
    [self filterContextWithSearchText:searchString];
    
    if(_searchedDevices.count)
        return YES;
    else
        return NO;
}

@end
