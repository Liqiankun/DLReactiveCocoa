//
//  RACRGBViewController.m
//  DLReactiveCocoa
//
//  Created by David on 2017/11/25.
//  Copyright © 2017年 David. All rights reserved.
//

#import "RACRGBViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface RACRGBViewController ()

@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UITextField *redField;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UITextField *greenField;
@property (weak, nonatomic) IBOutlet UISlider *blueSilder;
@property (weak, nonatomic) IBOutlet UITextField *blueField;
@property (weak, nonatomic) IBOutlet UIView *RGBView;

@end

@implementation RACRGBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.redField.text = self.greenField.text = self.blueField.text = @"0.5";
    RACSignal *redSignal = [self bindSlider:self.redSlider textField:self.redField];
    RACSignal *greenSignal = [self bindSlider:self.greenSlider textField:self.greenField];
    RACSignal *blueSignal = [self bindSlider:self.blueSilder textField:self.blueField];
    RACSignal *resultSignal = [[RACSignal combineLatest:@[redSignal, greenSignal, blueSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        return [UIColor colorWithRed:[value[0] floatValue] green:[value[1] floatValue] blue:[value[2] floatValue] alpha:1];
    }];
    
    RAC(self.RGBView, backgroundColor) = resultSignal;
    
}

-(RACSignal *)bindSlider:(UISlider *)slider textField:(UITextField *)textField {
    RACSignal *textSignal = [[textField rac_textSignal] take:1];
    RACChannelTerminal *sliderChannel = [slider rac_newValueChannelWithNilValue:nil];
    RACChannelTerminal *fieldChannel = [textField rac_newTextChannel];
    [fieldChannel subscribe:sliderChannel];
    [[sliderChannel map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%.02f", [value floatValue]];
    }] subscribe:fieldChannel];
    return [[sliderChannel merge:fieldChannel] merge:textSignal];
}

- (void)didReceiveMemoryWarning {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
