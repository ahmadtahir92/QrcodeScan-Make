





#import <UIKit/UIKit.h>
@class ATAlertView;

typedef enum : NSUInteger {
    ATAlertViewBottomViewTypeOne,
    ATAlertViewBottomViewTypeTwo,
} ATAlertViewBottomViewType;

@protocol ATAlertViewDelegate <NSObject>

@optional
/** right Button click event(SGAlertViewBottomViewTypeOne Type of OK button；SGAlertViewBottomViewTypeTwo Type is right) */
- (void)didSelectedRightButtonClick;
/** left Button click event(Click event targeted SGAlertViewBottomViewTypeTwo Type works) */
- (void)didSelectedLeftButtonClick;

@end

@interface ATAlertView : UIView

@property (nonatomic, weak) id<ATAlertViewDelegate> delegate_AT;

/** ok (Right)Button title(SGAlertViewBottomViewTypeTwo The default is the Right button) */
@property (nonatomic, copy) NSString *sure_btnTitle;
/** left Button title */
@property (nonatomic, copy) NSString *left_btnTitle;
/** ok (Right)Button title color(SGAlertViewBottomViewTypeTwo The default is the Right button)*/
@property (nonatomic, strong) UIColor *sure_btnTitleColor;
/** left Button title color(SGAlertViewBottomViewTypeTwo Style the Left button)*/
@property (nonatomic, strong) UIColor *left_btnTitleColor;
/** Bottom button style */
@property (nonatomic, assign) ATAlertViewBottomViewType alertViewBottomViewType;

/** Object method created SGAlertView */
- (instancetype)initWithTitle:(NSString *)title delegate:(id<ATAlertViewDelegate>)delegate contentTitle:(NSString *)contentTitle alertViewBottomViewType:(ATAlertViewBottomViewType)alertViewBottomViewType;

/** Class method creation SGAlertView */
+ (instancetype)alertViewWithTitle:(NSString *)title delegate:(id<ATAlertViewDelegate>)delegate contentTitle:(NSString *)contentTitle alertViewBottomViewType:(ATAlertViewBottomViewType)alertViewBottomViewType;

- (void)show;

@end
