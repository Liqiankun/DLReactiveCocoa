//
//  ViewController.m
//  DLReactiveCocoa
//
//  Created by David on 2017/11/25.
//  Copyright © 2017年 David. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.enabled = NO;
    [self.nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)textFieldDidChange:(UITextField *)textFiled {
    self.loginButton.enabled = (self.nameTextField.text.length > 5 &&
                                self.passwordTextField.text.length > 6
                                );
}

-(void)reactiveObjcCode {
    RACSignal *viewDidAppear = [self rac_signalForSelector:@selector(viewDidAppear:)];
    [viewDidAppear subscribeNext:^(id  _Nullable x) {
        NSLog(@"X : %@", x);
        NSLog(@"%s", __func__);
    }];
    
    // 错误
    [viewDidAppear subscribeError:^(NSError * _Nullable error) {
        
    }];
    
    // 完成
    [viewDidAppear subscribeCompleted:^{
        
    }];
    
    // 对按钮的订阅
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Click Me" forState:UIControlStateNormal];
    [button setRac_command:[[RACCommand alloc] initWithEnabled:nil signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSLog(@"cliked me");
            // 模拟网络请求
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:[NSDate date]];
                [subscriber sendCompleted];
            });
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }]];
    
    [[[button rac_command] executionSignals] subscribeNext:^(RACSignal<id> * _Nullable x) {
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"X : %@", x);
        }];
    }];
    button.frame = CGRectMake(0, 0, 80, 80);
    button.center = self.view.center;
    [self.view addSubview:button];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    NSLog(@"%s", __func__);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
