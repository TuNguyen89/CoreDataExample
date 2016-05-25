//
//  DeviceDetailViewController.m
//  MyStore
//
//  Created by Tu Nguyen on 5/23/16.
//  Copyright © 2016 Tu Nguyen. All rights reserved.
//

#import "DeviceDetailViewController.h"

@interface DeviceDetailViewController ()

@end

@implementation DeviceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //If receive the device entity from Device table, let show it
    if( _device) {
        _nameTextField.text = [_device valueForKey:@"name"];
        _versionTextField.text = [_device valueForKey:@"version"];
        _companyTextField.text = [_device valueForKey:@"company"];
    } else {
        
    }
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    
    NSManagedObjectContext* context = [self managedObjectContext];
    //If the device is modified
    if(_device) {
        
        [_device setValue:_nameTextField.text forKey:@"name"];
        [_device setValue:_versionTextField.text forKey:@"version"];
        [_device setValue:_companyTextField.text forKey:@"company"];
        
    } else {
        
        NSManagedObject* device = [NSEntityDescription insertNewObjectForEntityForName:@"Device" inManagedObjectContext:context];
        [device setValue:self.nameTextField.text forKey:@"name"];
        [device setValue:self.companyTextField.text forKey:@"company"];
        [device setValue:self.versionTextField.text forKey:@"version"];
        
        
    } //If the device is created as the new once
    
    NSError* err = nil;
    
    //If saving have problem
    if( ![context save: &err]) {
        NSLog(@"Can't save %@ %@", err, [err localizedDescription]);
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

//Get the managed object context
- (NSManagedObjectContext*) managedObjectContext {
    NSManagedObjectContext* context = nil;
    
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

@end
