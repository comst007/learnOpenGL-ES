//
//  ViewController.m
//  LZGLESPro_00
//
//  Created by comst on 2018/3/15.
//  Copyright © 2018年 comst. All rights reserved.
//

#import "ViewController.h"
#import "LZGLView.h"
@interface ViewController ()
@property (strong, nonatomic) LZGLView *glView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.glView = [[LZGLView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:self.glView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
