



#import "ATQRCodeTool.h"

@implementation ATQRCodeTool

/**
 *  Generate an ordinary two-dimensional code
 *
 *  @param data    Pass in the data you want to generate two-dimensional code
 *  @param imageViewWidth    The width of the picture
 */
+ (UIImage *)AT_generateWithDefaultQRCodeData:(NSString *)data imageViewWidth:(CGFloat)imageViewWidth {
    // 1、Create a filter object
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // Restore the default properties of the filter
    [filter setDefaults];
    
    // 2、Set the data
    NSString *info = data;
    // Convert the string into
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    
    // Set the filter inputMessage data via KVC
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    
    // 3、Get the image of the filter output
    CIImage *outputImage = [filter outputImage];
    
    
    return [ATQRCodeTool createNonInterpolatedUIImageFormCIImage:outputImage withSize:imageViewWidth];
}

/** Generate the specified size according to CIImage UIImage */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.create bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.Save bitmap To the picture
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

/**
 * Generate a two-dimensional code with a logo
 *
 *  @param data    Pass in the data you want to generate two-dimensional code
 *  @param logoImageName    logo的image name
 *  @param logoScaleToSuperView    Logo relative to the parent view of the zoom ratio (range: 0-1,0, does not show, 1, the same size with the parent view)
 */
+ (UIImage *)AT_generateWithLogoQRCodeData:(NSString *)data logoImageName:(NSString *)logoImageName logoScaleToSuperView:(CGFloat)logoScaleToSuperView {
    // 1、Create a filter object
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // Restore the default properties of the filter
    [filter setDefaults];
    
    // 2、Set the data
    NSString *string_data = data;
    // Convert the string to NSdata (although the two-dimensional code is essentially a string, but here need to convert, do not convert to collapse)
    NSData *qrImageData = [string_data dataUsingEncoding:NSUTF8StringEncoding];
    
    // Set the filter input value, KVC assignment
    [filter setValue:qrImageData forKey:@"inputMessage"];
    
    // 3、Get the image of the filter output
    CIImage *outputImage = [filter outputImage];
    
    // Image is less than (27,27),We need to zoom in
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    
    // 4. Convert the CIImage type to the UIImage type
    UIImage *start_image = [UIImage imageWithCIImage:outputImage];
    
    
    // - - - - - - - - - - - - - - - - Add the middle small icon- - - - - - - - - - - - - - - -
    // 5、Open the drawing, get the graphics context (the size of the context, that is, the size of the two-dimensional code)
    UIGraphicsBeginImageContext(start_image.size);
    
    // Draw the two-dimensional code image (here is the graphics context, the upper left corner (0,0) point
    [start_image drawInRect:CGRectMake(0, 0, start_image.size.width, start_image.size.height)];
    
    // And then draw a small picture
    NSString *icon_imageName = logoImageName;
    UIImage *icon_image = [UIImage imageNamed:icon_imageName];
    CGFloat icon_imageW = start_image.size.width * logoScaleToSuperView;
    CGFloat icon_imageH = start_image.size.height * logoScaleToSuperView;
    CGFloat icon_imageX = (start_image.size.width - icon_imageW) * 0.5;
    CGFloat icon_imageY = (start_image.size.height - icon_imageH) * 0.5;
    
    [icon_image drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
    
    // 6、Get this picture of the current painting
    UIImage *final_image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 7、Close the graphics context
    UIGraphicsEndImageContext();
    
    return final_image;
}

/**
 *  Generate a color two-dimensional code
 *
 *  @param data    Pass in the data you want to generate two-dimensional code
 *  @param backgroundColor    Background color
 *  @param mainColor    Main color
 */
+ (UIImage *)AT_generateWithColorQRCodeData:(NSString *)data backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor {
    // 1、Create a filter object
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // Restore the default properties of the filter
    [filter setDefaults];
    
    // 2、Set the data
    NSString *string_data = data;
    // Convert the string to NSdata (although the two-dimensional code is essentially a string, but here need to convert, do not convert to collapse)
    NSData *qrImageData = [string_data dataUsingEncoding:NSUTF8StringEncoding];
    
    // Set the filter input value, KVC assignment
    [filter setValue:qrImageData forKey:@"inputMessage"];
    
    // 3、Get the image of the filter output
    CIImage *outputImage = [filter outputImage];
    
    // The picture is less than (27,27) and we need to zoom in
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(9, 9)];
    
    
    // 4、Create a color filter (not much for color)
    CIFilter * color_filter = [CIFilter filterWithName:@"CIFalseColor"];
    
    // Set the default value
    [color_filter setDefaults];
    
    // 5. KVC assigned to the private property
    [color_filter setValue:outputImage forKey:@"inputImage"];
    
    // 6、Need to Use CIColor
    [color_filter setValue:backgroundColor forKey:@"inputColor0"];
    [color_filter setValue:mainColor forKey:@"inputColor1"];
    
    // 7、Set the output
    CIImage *colorImage = [color_filter outputImage];
    
    return [UIImage imageWithCIImage:colorImage];
}

/**
 *  Scan QR CODE
 *
 *  @param outsideVC    External controller
 *  @param session    AVCaptureSession Object
 *  @param previewLayer    AVCaptureVideoPreviewLayer
 */
+ (void)AT_scanningQRCodeOutsideVC:(UIViewController *)outsideVC session:(AVCaptureSession *)session previewLayer:(AVCaptureVideoPreviewLayer *)previewLayer {
    // 1、Get the camera device
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2、Create input stream
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // 3、Create an output stream
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    // 4、Set the agent to refresh in the main thread
    [output setMetadataObjectsDelegate:(id)outsideVC queue:dispatch_get_main_queue()];
    
    // Set the scan range (each value 0 ~ 1, the upper right corner of the screen for the coordinates of the origin)
    // Note: WeChat two-dimensional code scanning range is the entire screen, there is no treatment (not set)
    output.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
    
    // 5、Initialize the link object (session object)
    // High quality collection rate
    //session.sessionPreset = AVCaptureSessionPreset1920x1080; // If the two-dimensional code picture is too small, or fuzzy please use this code, note the following sentence code
    session.sessionPreset = AVCaptureSessionPresetHigh;
    
    // 5.1 Add session input
    [session addInput:input];
    
    // 5.2 Add session output
    [session addOutput:output];
    
    // 6、Set the output data type, you need to add the metadata output to the session before you can specify the metadata type, otherwise it will be error
    // Set the encoding format supported by the sweep code (set bar code and two-dimensional code as follows)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // 7、Instantiate the preview layer, passing _session to tell the layer what to display in the future
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = outsideVC.view.layer.bounds;
    
    // 8、Insert the layer into the current view
    [outsideVC.view.layer insertSublayer:previewLayer atIndex:0];
    
    // 9、Start the session
    [session startRunning];
}


@end

