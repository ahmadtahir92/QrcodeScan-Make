





#import <UIKit/UIKit.h>
@class ATAlertView;

typedef enum : NSUInteger {
    ATAlertViewBottomViewTypeOne,
    ATAlertViewBottomViewTypeTwo,
} ATAlertViewBottomViewType;

@protocol ATAlertViewDelegate <NSObject>

@optional
- (void)didSelectedRightButtonClick;
- (void)didSelectedLeftButtonClick;

@end

@interface ATAlertView : UIView

@property (nonatomic, weak) id<ATAlertViewDelegate> delegate_AT;

@property (nonatomic, copy) NSString *sure_btnTitle;
@property (nonatomic, copy) NSString *left_btnTitle;
@property (nonatomic, strong) UIColor *sure_btnTitleColor;
@property (nonatomic, strong) UIColor *left_btnTitleColor;
@property (nonatomic, assign) ATAlertViewBottomViewType alertViewBottomViewType;

- (instancetype)initWithTitle:(NSString *)title delegate:(id<ATAlertViewDelegate>)delegate contentTitle:(NSString *)contentTitle alertViewBottomViewType:(ATAlertViewBottomViewType)alertViewBottomViewType;

+ (instancetype)alertViewWithTitle:(NSString *)title delegate:(id<ATAlertViewDelegate>)delegate contentTitle:(NSString *)contentTitle alertViewBottomViewType:(ATAlertViewBottomViewType)alertViewBottomViewType;

- (void)show;

@end
