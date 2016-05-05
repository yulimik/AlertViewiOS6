//
//  MLTableAlert.h
//
//  Version 1.0
//
//  Created by Matteo Del Vecchio on 11/12/12.
//  Copyright (c) 2012 Matthew Labs. All rights reserved.
//  For the complete copyright notice, read Source Code License.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class MyAlert;


// Blocks definition for table view management
typedef void (^MyAlertOkBlock)(void);
typedef void (^MyAlertCancelBlock)(void);

@interface MyAlert : UIView<UITextFieldDelegate>

@property (nonatomic, assign) CGFloat height;

@property (assign,nonatomic) BOOL isCamera;
@property (nonatomic, strong) MyAlertOkBlock newOkBlock;
@property (nonatomic, strong) MyAlertOkBlock okBlock;
@property (nonatomic, strong) MyAlertCancelBlock cancelBlock;


// Initialization method; rowsBlock and cellsBlock MUST NOT be nil
-(id)initWithTitle:(NSString *)title msg:(NSString *)msg;

-(void)setOkBtnTitle:(NSString *)okTitle;
-(void)setCancelBtnTitle:(NSString *)cancelTitle;
-(void)andOkBlock:(MyAlertOkBlock)cellsBlock;
-(void)withOkBlock:(MyAlertOkBlock)newBlock;
-(void)andCancelBlock:(MyAlertCancelBlock)cellsBlock;
-(void)setTextbox:(NSString *)text isholder:(BOOL)isholder limitNum:(int)limitNum;
-(NSString *)getText;

// Show the alert
-(void)show;

@end

