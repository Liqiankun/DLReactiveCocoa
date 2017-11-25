//
//  RACViewController.m
//  DLReactiveCocoa
//
//  Created by David on 2017/11/25.
//  Copyright © 2017年 David. All rights reserved.
//

#import "RACViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface RACViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation RACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    RACSignal *nameSignal = [self.nameTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
//        return @(value.length > 8);
//    }];
    
    RACSignal *enableSignal = [[RACSignal combineLatest:@[self.nameTextField.rac_textSignal, self.passwordTextField.rac_textSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        return @([value[0] length] > 4 && [value[1] length] > 6);
    }];
    
    self.loginButton.rac_command = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal empty];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
