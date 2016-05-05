//
//  MLTableAlert.m
//
//  Version 1.0
//
//  Created by Matteo Del Vecchio on 11/12/12.
//  Copyright (c) 2012 Matthew Labs. All rights reserved.
//  For the complete copyright notice, read Source Code License.
//

#import "MyAlert.h"

#define kTableAlertWidth     284.0
#define kLateralInset         12.0
#define kVerticalInset         8.0
#define kMinAlertHeight      100.0
#define kTextboxHeight        44.0
#define kOkButtonHeight       44.0
#define kOkButtonMargin        5.0
#define kCancelButtonHeight   44.0
#define kCancelButtonMargin    5.0
#define kTitleLabelMargin     12.0
#define kOncontrolviewHeight  40.0

@interface MyAlert ()
@property (nonatomic, strong) UIView *alertBg;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *okButtonTitle;
@property (nonatomic, strong) NSString *cancelButtonTitle;

@property (nonatomic) BOOL hasMsg;
@property (nonatomic) BOOL hasOkBtn;
@property (nonatomic) BOOL hasCancelBtn;
@property (nonatomic) BOOL hasTextbox;
@property (nonatomic) BOOL isholder;
@property (nonatomic) int limitNum;

@end


@implementation MyAlert

#pragma mark - MyAlert Initialization

-(id)initWithTitle:(NSString *)title msg:(NSString *)msg
{
	self = [super init];
	if (self)
	{

        _title = title;
		_msg = msg;
		_height = kMinAlertHeight;
        _okButtonTitle = @"OK";
        _cancelButtonTitle = @"Cancel";
        if ([msg isEqual: @""]) {
            _hasMsg = false;
        } else {
            _hasMsg = true;
        }
        _hasOkBtn = true;
        _hasCancelBtn = false;
        _hasTextbox = false;
	}
	
	return self;
}

-(void)setOkBtnTitle:(NSString *)okTitle {
    _okButtonTitle = okTitle;
}
-(void)setCancelBtnTitle:(NSString *)cancelTitle {
    _cancelButtonTitle = cancelTitle;
    _hasCancelBtn = true;
}
-(void)andOkBlock:(MyAlertOkBlock)cellsBlock {
    if (self) {
        _okBlock = cellsBlock;
    }
}

-(void)withOkBlock:(MyAlertOkBlock)newBlock
{
    if (self) {
        _newOkBlock = newBlock;
    }
}

-(void)andCancelBlock:(MyAlertCancelBlock)cellsBlock {
    if (self) {
        _cancelBlock = cellsBlock;
        _hasCancelBtn = true;
    }
}

-(void)setTextbox:(NSString *)text isholder:(BOOL)isholder limitNum:(int)limitNum{
    _hasTextbox = true;
    _text = text;
    _isholder = isholder;
    _limitNum = limitNum;
}

-(void)createBackgroundView
{
	
	// adding some styles to background view (behind table alert)
	self.frame = [[UIScreen mainScreen] bounds];
	self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
	self.opaque = NO;
	
	// adding it as subview of app's UIWindow
	UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    [appWindow addSubview:self];
    
	// get background color darker
	[UIView animateWithDuration:0.2 animations:^{
		self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
	}];
}

-(void)animateIn
{
	// UIAlertView-like pop in animation
	self.alertBg.transform = CGAffineTransformMakeScale(0.6, 0.6);
	[UIView animateWithDuration:0.2 animations:^{
		self.alertBg.transform = CGAffineTransformMakeScale(1.1, 1.1);
	} completion:^(BOOL finished){
		[UIView animateWithDuration:1.0/15.0 animations:^{
			self.alertBg.transform = CGAffineTransformMakeScale(0.9, 0.9);
		} completion:^(BOOL finished){
			[UIView animateWithDuration:1.0/7.5 animations:^{
				self.alertBg.transform = CGAffineTransformIdentity;
			}];
		}];
	}];
}

-(void)animateOut
{
	[UIView animateWithDuration:1.0/7.5 animations:^{
		self.alertBg.transform = CGAffineTransformMakeScale(0.9, 0.9);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:1.0/15.0 animations:^{
			self.alertBg.transform = CGAffineTransformMakeScale(1.1, 1.1);
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:0.3 animations:^{
				self.alertBg.transform = CGAffineTransformMakeScale(0.01, 0.01);
				self.alpha = 0.3;
			} completion:^(BOOL finished){
				// table alert not shown anymore
				[self removeFromSuperview];
                if (self.isCamera) {
                    self.okBlock();
                }
			}];
		}];
	}];
}

-(void)show
{
	[self createBackgroundView];
	
    int frameheight = 0;

	// alert view creation
	self.alertBg = [[UIView alloc] initWithFrame:CGRectZero];
	[self addSubview:self.alertBg];

    
	// setting alert background image
	UIImageView *alertBgImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"MLTableAlertBackground.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:30]];
	[self.alertBg addSubview:alertBgImage];

	
	// alert title creation
	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	self.titleLabel.backgroundColor = [UIColor clearColor];
	self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
	self.titleLabel.shadowOffset = CGSizeMake(0, -1);
	self.titleLabel.font = [UIFont boldSystemFontOfSize:25.0];
	self.titleLabel.frame = CGRectMake(kLateralInset, 15, kTableAlertWidth - kLateralInset * 2, 22);
	self.titleLabel.text = self.title;
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
	[self.alertBg addSubview:self.titleLabel];
    frameheight = frameheight + 15 + 22 + kVerticalInset;
    
    if (self.hasMsg) {
        self.msgLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.msgLabel setNumberOfLines:0];
        self.msgLabel.textColor = [UIColor whiteColor];
        [self.msgLabel setTextAlignment:NSTextAlignmentCenter];
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:20];
        CGSize size = CGSizeMake(kTableAlertWidth - kLateralInset * 2, 2000);
        CGSize labelsize = [self.msg sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        self.msgLabel.frame = CGRectMake(kLateralInset, frameheight, kTableAlertWidth - kLateralInset * 2, labelsize.height);
        
        NSString *firstStr = [self.msg substringWithRange:NSMakeRange(0,1)];
        if ([firstStr isEqualToString:@"("]) {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.msg];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,5)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(6,self.msg.length-6)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:20.0] range:NSMakeRange(0, 6)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:20.0] range:NSMakeRange(6, self.msg.length-6)];
            self.msgLabel.attributedText = str;
        }else{
            self.msgLabel.font = font;
            self.msgLabel.text = self.msg;
        }

        [self.alertBg addSubview:self.msgLabel];
        frameheight = frameheight + self.msgLabel.frame.size.height + kVerticalInset;
    }
    
    if (self.hasTextbox) {
        self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.textField.enablesReturnKeyAutomatically = false;
        self.textField.keyboardType = UIKeyboardTypeDefault;
        self.textField.returnKeyType = UIReturnKeyDefault;
        self.textField.delegate = self;
        self.textField.frame = CGRectMake(kLateralInset, frameheight, kTableAlertWidth - kLateralInset * 2, kTextboxHeight);
        [self.textField setBorderStyle:UITextBorderStyleRoundedRect];
        if (self.isholder) {
            [self.textField setPlaceholder:self.text];
        } else {
            self.textField.text = self.text;
        }
        [self.alertBg addSubview:self.textField];
        frameheight = frameheight + kTextboxHeight + kVerticalInset;
    }
	
    int okwidth = kTableAlertWidth - kLateralInset * 2;
    if (self.hasCancelBtn) {
        okwidth = (okwidth - kLateralInset) / 2;
    }
    
	if (self.hasCancelBtn) {
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(kLateralInset, frameheight, okwidth, kOkButtonHeight);
        self.cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        self.cancelButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
        self.cancelButton.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
        [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.cancelButton setBackgroundColor:[UIColor clearColor]];
        [self.cancelButton setBackgroundImage:[[UIImage imageNamed:@"MLTableAlertButton.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
        [self.cancelButton setBackgroundImage:[[UIImage imageNamed:@"MLTableAlertButtonPressed.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateHighlighted];
        self.cancelButton.opaque = NO;
        self.cancelButton.layer.cornerRadius = 5.0;
        [self.cancelButton addTarget:self action:@selector(cancelAlert) forControlEvents:UIControlEventTouchUpInside];
        [self.alertBg addSubview:self.cancelButton];
    }
    
    self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.hasCancelBtn) {
        self.okButton.frame = CGRectMake(kLateralInset * 2 + okwidth, frameheight, okwidth, kCancelButtonHeight);
    } else {
        self.okButton.frame = CGRectMake(kLateralInset, frameheight, okwidth, kCancelButtonHeight);
    }
    self.okButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.okButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    self.okButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    self.okButton.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    [self.okButton setTitle:self.okButtonTitle forState:UIControlStateNormal];
    [self.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.okButton setBackgroundColor:[UIColor clearColor]];
    [self.okButton setBackgroundImage:[[UIImage imageNamed:@"MLTableAlertButton.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
    [self.okButton setBackgroundImage:[[UIImage imageNamed:@"MLTableAlertButtonPressed.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateHighlighted];
    self.okButton.opaque = NO;
    self.okButton.layer.cornerRadius = 5.0;
    [self.okButton addTarget:self action:@selector(okAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.alertBg addSubview:self.okButton];
    
    frameheight = frameheight + kOkButtonHeight + kVerticalInset;
	
    self.height = frameheight;
	self.alertBg.frame = CGRectMake((self.frame.size.width - kTableAlertWidth) / 2, (self.frame.size.height - self.height) / 2, kTableAlertWidth, self.height - kVerticalInset * 3);
	alertBgImage.frame = CGRectMake(0.0, 0.0, kTableAlertWidth, frameheight + kVerticalInset);
	
	[self becomeFirstResponder];

	// show the alert with animation
	[self animateIn];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(NSString *)getText {
    return self.textField.text;
}

-(void)newOkAlert
{
    [self animateOut];
    NSLog(@"close");
}

-(void)okAlert
{
    [self animateOut];

    // dismiss the alert with its animation
    if (self.isCamera) {
        NSLog(@"no camera");
    }else
    {
    self.okBlock();
    }

}

-(void)cancelAlert
{
    self.cancelBlock();
    // dismiss the alert with its animation
    [self animateOut];
}

-(void)dismissTableAlert
{
	// dismiss the alert with its animation
	[self animateOut];
}

// Allows the alert to be first responder
-(BOOL)canBecomeFirstResponder
{
	return YES;
}

// Alert height setter
-(void)setHeight:(CGFloat)height
{
	if (height > kMinAlertHeight)
		_height = height;
	else
		_height = kMinAlertHeight;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textField) {
        if (textField.text.length > self.limitNum){
           textField.text = [textField.text substringToIndex:self.limitNum];
        }
    }
    
    return YES;
}

@end
