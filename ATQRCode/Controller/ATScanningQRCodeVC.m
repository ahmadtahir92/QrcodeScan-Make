



#import "ATScanningQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import "ATScanningQRCodeView.h"
#import "ATScanSuccessJumpVC.h"
#import "ATQRCodeTool.h"
#import <Photos/Photos.h>
#import "ATAlertView.h"

@interface ATScanningQRCodeVC () <AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) ATScanningQRCodeView *scanningView;

@property (nonatomic, strong) UIButton *right_Button;
@property (nonatomic, assign) BOOL first_push;

@end

@implementation ATScanningQRCodeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.scanningView = [[ATScanningQRCodeView alloc] initWithFrame:self.view.frame outsideViewLayer:self.view.layer];
    [self.view addSubview:self.scanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"scan it";
    self.navigationController.navigationBar.barTintColor = [UIColor purpleColor];


    [self setupScanningQRCode];
    
    self.first_push = YES;
    
    // rightBarButtonItem
    [self setupRightBarButtonItem];
}

// rightBarButtonItem
- (void)setupRightBarButtonItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Album" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItenAction)];
}
- (void)rightBarButtonItenAction {
    [self readImageFromAlbum];
}
- (void)readImageFromAlbum {

    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {

        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            

            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init]; 
                        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        imagePicker.delegate = self;
                        
                        [self presentViewController:imagePicker animated:YES completion:nil];
                        NSLog(@"Main thread - - %@", [NSThread currentThread]);
                    });
                    NSLog(@"Current thread - - %@", [NSThread currentThread]);
                    

                    NSLog(@"The user first agreed to access the album permissions");
                } else {

                    NSLog(@"The user first denied access to the album");
                }
            }];
       
        } else if (status == PHAuthorizationStatusAuthorized) {
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            
            [self presentViewController:imagePicker animated:YES completion:nil];
            

        } else if (status == PHAuthorizationStatusDenied) {
            
            ATAlertView *alertView = [ATAlertView alertViewWithTitle:@"Warning" delegate:nil contentTitle:@"Go to -> [Settings - Privacy - Photo - ATQRCodeExample] to open the access switch" alertViewBottomViewType:(ATAlertViewBottomViewTypeOne)];
            [alertView show];
            
        } else if (status == PHAuthorizationStatusRestricted) {
            NSLog(@"The album can not be accessed for system reasons");
        }
        
    } else {
        ATAlertView *alertView = [ATAlertView alertViewWithTitle:@"Warning" delegate:nil contentTitle:@"Did not detect your camera, please test it on a real machine" alertViewBottomViewType:(ATAlertViewBottomViewTypeOne)];
        [alertView show];
    }
}
#pragma mark - - - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"info - - - %@", info);
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self scanQRCodeFromPhotosInTheAlbum:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    }];
}

- (void)scanQRCodeFromPhotosInTheAlbum:(UIImage *)image {
   
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    

    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    
    NSLog(@"Scan the results－ － %@", features);
    
    for (int index = 0; index < [features count]; index ++) {
        CIQRCodeFeature *feature = [features objectAtIndex:index];
        NSString *scannedResult = feature.messageString;
        NSLog(@"result:%@",scannedResult);
        
        if (self.first_push) {
            ATScanSuccessJumpVC *jumpVC = [[ATScanSuccessJumpVC alloc] init];
            jumpVC.jump_URL = scannedResult;
            [self.navigationController pushViewController:jumpVC animated:YES];
            
            self.first_push = NO;
        }
    }
}


- (void)setupScanningQRCode {

    self.session = [[AVCaptureSession alloc] init];

    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    [ATQRCodeTool AT_scanningQRCodeOutsideVC:self session:_session previewLayer:_previewLayer];
}



- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    

    [self playSoundEffect:@"sound.caf"];


    [self.session stopRunning];
    

    [self.previewLayer removeFromSuperlayer];
    

    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        NSLog(@"metadataObjects = %@", metadataObjects);
        
        if ([obj.stringValue hasPrefix:@"http"]) {

            ATScanSuccessJumpVC *jumpVC = [[ATScanSuccessJumpVC alloc] init];
            jumpVC.jump_URL = obj.stringValue;
            NSLog(@"stringValue = = %@", obj.stringValue);
            [self.navigationController pushViewController:jumpVC animated:YES];
            
        } else {
            
            ATScanSuccessJumpVC *jumpVC = [[ATScanSuccessJumpVC alloc] init];
            jumpVC.jump_bar_code = obj.stringValue;
            NSLog(@"stringValue = = %@", obj.stringValue);
            [self.navigationController pushViewController:jumpVC animated:YES];
        }
    }
}



- (void)playSoundEffect:(NSString *)name{

    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    

    SystemSoundID soundID = 0;

    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    

    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    

    AudioServicesPlaySystemSound(soundID);
    
}
void soundCompleteCallback(SystemSoundID soundID, void *clientData){
    NSLog(@"Play done...");
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;

}
@end
