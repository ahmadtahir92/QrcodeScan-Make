



#import "ViewController.h"
#import "ATGenerateQRCodeVC.h"
#import "ATScanningQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import "ATAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (IBAction)generateQRCode:(id)sender {

    ATGenerateQRCodeVC *VC = [[ATGenerateQRCodeVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)scanningQRCode:(id)sender {
    
    // 1、 Get the camera device
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        ATScanningQRCodeVC *scanningQRCodeVC = [[ATScanningQRCodeVC alloc] init];
                        [self.navigationController pushViewController:scanningQRCodeVC animated:YES];
                        NSLog(@"Main thread- - %@", [NSThread currentThread]);
                    });
                    NSLog(@"Current thread - - %@", [NSThread currentThread]);
                    
                    // The user first agreed to access the camera permissions
                    NSLog(@"The user first agreed to access the camera permissions");
                    
                } else {

                    // The user first denied access to the camera
                    NSLog(@"The user first denied access to the camera");
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // The user allows the current application to access the camera
            ATScanningQRCodeVC *scanningQRCodeVC = [[ATScanningQRCodeVC alloc] init];
            [self.navigationController pushViewController:scanningQRCodeVC animated:YES];
        } else if (status == AVAuthorizationStatusDenied) { // The user rejects the current application to access the camera
            ATAlertView *alertView = [ATAlertView alertViewWithTitle:@"Warning" delegate:nil contentTitle:@"Please go-> [Settings - Privacy - Camera - ATQRCodeExample] Open the access switch" alertViewBottomViewType:(ATAlertViewBottomViewTypeOne)];
            [alertView show];
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"The album can not be accessed for system reasons");
        }
    } else {
        ATAlertView *alertView = [ATAlertView alertViewWithTitle:@"Warning" delegate:nil contentTitle:@"Did not detect your camera, please test it on a real machine" alertViewBottomViewType:(ATAlertViewBottomViewTypeOne)];
        [alertView show];
    }

}


@end


