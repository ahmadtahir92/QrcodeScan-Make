



#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import <AVFoundation/AVFoundation.h>

@interface ATQRCodeTool : NSObject

/** Generate an ordinary two-dimensional code*/
+ (UIImage *)AT_generateWithDefaultQRCodeData:(NSString *)data imageViewWidth:(CGFloat)imageViewWidth;
/** Generate a logo with a logo (viewScaleToSuperView: relative to the parent view of the zoom ratio range 0-1; 0, do not show, 1, the same size with the parent view) */
+ (UIImage *)AT_generateWithLogoQRCodeData:(NSString *)data logoImageName:(NSString *)logoImageName logoScaleToSuperView:(CGFloat)logoScaleToSuperView;
/** Generate a color two-dimensional code*/
+ (UIImage *)AT_generateWithColorQRCodeData:(NSString *)data backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor;

/** Scan QR code  */
+ (void)AT_scanningQRCodeOutsideVC:(UIViewController *)outsideVC session:(AVCaptureSession *)session previewLayer:(AVCaptureVideoPreviewLayer *)previewLayer;

@end
