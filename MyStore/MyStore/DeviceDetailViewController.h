//
//  DeviceDetailViewController.h
//  MyStore
//
//  Created by Tu Nguyen on 5/23/16.
//  Copyright © 2016 Tu Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DeviceDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *versionTextField;

@property (weak, nonatomic) IBOutlet UITextField *companyTextField;

@property (strong)  NSManagedObject* device;

- (IBAction)cancel:(id)sender;

- (IBAction)save:(id)sender;

@end
