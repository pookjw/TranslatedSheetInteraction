//
//  ViewController.mm
//  MyApp
//
//  Created by Jinwoo Kim on 1/6/24.
//

#import "ViewController.h"
#import "CollectionViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (IBAction)foo:(id)sender {
    CollectionViewController *viewController = [CollectionViewController new];
    viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:viewController animated:YES completion:nil];
    [viewController release];
}

@end
