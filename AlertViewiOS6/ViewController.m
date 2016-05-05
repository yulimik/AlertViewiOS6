//
//  ViewController.m
//  AlertViewiOS6
//
//  Created by 周伟 on 16/5/5.
//  Copyright © 2016年 周伟. All rights reserved.
//

#import "ViewController.h"
#import "MyAlert.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.testBtn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.testBtn1.backgroundColor = [UIColor grayColor];
    self.testBtn1.frame = CGRectMake(30, 50, 100, 100);
    [self.view addSubview:self.testBtn1];
    [self.testBtn1 setTitle:@"OnlyOK" forState:UIControlStateNormal];
    [self.testBtn1 addTarget:self action:@selector(onlyOK) forControlEvents:UIControlEventTouchUpInside];
    
    self.testBtn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.testBtn2.backgroundColor = [UIColor grayColor];
    self.testBtn2.frame = CGRectMake(150, 50, 100, 100);
    [self.view addSubview:self.testBtn2];
    [self.testBtn2 setTitle:@"OKandBlock" forState:UIControlStateNormal];
    [self.testBtn2 addTarget:self action:@selector(OKandBlock) forControlEvents:UIControlEventTouchUpInside];
    
    self.testBtn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.testBtn3.backgroundColor = [UIColor grayColor];
    self.testBtn3.frame = CGRectMake(30, 200, 100, 100);
    [self.view addSubview:self.testBtn3];
    [self.testBtn3 setTitle:@"OKandCancel" forState:UIControlStateNormal];
    [self.testBtn3 addTarget:self action:@selector(OKandCancel) forControlEvents:UIControlEventTouchUpInside];
    
    self.testBtn4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.testBtn4.backgroundColor = [UIColor grayColor];
    self.testBtn4.frame = CGRectMake(150, 200, 100, 100);
    [self.view addSubview:self.testBtn4];
    [self.testBtn4 setTitle:@"AlertWithText" forState:UIControlStateNormal];
    [self.testBtn4 addTarget:self action:@selector(alertWithTextField) forControlEvents:UIControlEventTouchUpInside];
    
    self.tagLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 500, 200, 80)];
    self.tagLab.backgroundColor = [UIColor grayColor];
    self.tagLab.textColor = [UIColor redColor];
    self.tagLab.textAlignment =  NSTextAlignmentCenter;
    [self.view addSubview:self.tagLab];
}

#pragma mark - button click
- (void)onlyOK {
    MyAlert *alertView = [[MyAlert alloc]initWithTitle:@"Tissue" msg:@"Only has OK button and no block"];
    [alertView andOkBlock:^{
        NSLog(@"no block");
    }];
    [alertView show];
}

- (void)OKandBlock {
    MyAlert *alertView = [[MyAlert alloc]initWithTitle:@"Tissue" msg:@"OK and block"];
    [alertView andOkBlock:^{
        self.tagLab.text = @"OK and Block";
    }];
    [alertView show];
}

- (void)OKandCancel {
    MyAlert *alertView = [[MyAlert alloc]initWithTitle:@"Tissue" msg:@"OK and cancel with Block"];
    [alertView andOkBlock:^{
        self.tagLab.text = @"OK with Block";
    }];
    [alertView andCancelBlock:^{
        self.tagLab.text = @"Cancel with Block";
    }];
    [alertView show];
}

- (void)alertWithTextField {
    MyAlert *alertView = [[MyAlert alloc]initWithTitle:@"Tissue" msg:@"textBox"];
    [alertView setTextbox:@"text limit 6" isholder:YES limitNum:5];
    [alertView andOkBlock:^{
        self.tagLab.text = [alertView getText];
    }];
    [alertView show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
