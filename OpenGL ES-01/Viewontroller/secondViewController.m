//
//  secondViewController.m
//  OpenGL ES-01
//
//  Created by 郝琦 on 2019/6/3.
//  Copyright © 2019 GoGoCoding. All rights reserved.
//

#import "secondViewController.h"
#import "../View/OpenGLView.h"

@interface secondViewController ()
@property (weak, nonatomic) IBOutlet OpenGLView *openGLView;

@end

@implementation secondViewController
- (IBAction)onShoulderSliderValueChanged:(id)sender {
    UISlider * slider = (UISlider *)sender;
    float currentValue = [slider value];
    
    NSLog(@" >> current shoulder is %f", currentValue);
    
    self.openGLView.rotateShoulder = currentValue;
}


- (IBAction)onElbowSliderValueChanged:(id)sender {
    UISlider * slider = (UISlider *)sender;
    float currentValue = [slider value];
    
    NSLog(@" >> current elbow is %f", currentValue);
    self.openGLView.rotateElbow = currentValue;
}


- (IBAction)onRotateButtonClick:(id)sender {
    [self.openGLView toggleDisplayLink];
    
    UIButton * button = (UIButton *)sender;
    NSString * text = button.titleLabel.text;
    if ([text isEqualToString:@"Rotate"]) {
        [button setTitle: @"Stop" forState: UIControlStateNormal];
    }
    else {
        [button setTitle: @"Rotate" forState: UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
