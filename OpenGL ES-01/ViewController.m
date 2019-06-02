//
//  ViewController.m
//  OpenGL ES-01
//
//  Created by 郝琦 on 2019/5/18.
//  Copyright © 2019 GoGoCoding. All rights reserved.
//

#import "ViewController.h"
#import "View/OpenGLView.h"

@interface ViewController ()

@property (nonatomic, assign) float posX;
@property (nonatomic, assign) float posY;
@property (nonatomic, assign) float posZ;

@property (nonatomic, assign) float scaleZ;
@property (nonatomic, assign) float rotateX;


@property (nonatomic, strong) UIView *controlView;
@property (strong, nonatomic)  OpenGLView *openGLView;

@property (weak, nonatomic) IBOutlet UISlider *posXSlider;
@property (weak, nonatomic) IBOutlet UISlider *posYSlider;
@property (weak, nonatomic) IBOutlet UISlider *posZSlider;
@property (weak, nonatomic) IBOutlet UISlider *scaleZSlider;
@property (weak, nonatomic) IBOutlet UISlider *rotateXSlider;

@end

@implementation ViewController
- (IBAction)xSliderValueChanged:(id)sender {
    
    UISlider *slider = (UISlider *)sender;
    float currentValue = [slider value];
    
    self.openGLView.posX = currentValue;
    
    NSLog(@">> current x is %f", currentValue);
}

- (IBAction)ySliderValueChanged:(id)sender {
    UISlider * slider = (UISlider *)sender;
    float currentValue = [slider value];
    
    self.openGLView.posY = currentValue;
    
    NSLog(@" >> current y is %f", currentValue);
}

- (IBAction)zSliderValueChanged:(id)sender {
    UISlider * slider = (UISlider *)sender;
    float currentValue = [slider value];
    
    self.openGLView.posZ = currentValue;
    
    NSLog(@" >> current z is %f", currentValue);
}

- (IBAction)rotateXSliderValueChanged:(id)sender {
    UISlider * slider = (UISlider *)sender;
    float currentValue = [slider value];
    
    self.openGLView.rotateX = currentValue;
    
    NSLog(@" >> current x rotation is %f", currentValue);
}
- (IBAction)scaleZSliderValueChanged:(id)sender {
    UISlider * slider = (UISlider *)sender;
    float currentValue = [slider value];
    
    self.openGLView.scaleZ = currentValue;
    
    NSLog(@" >> current z scale is %f", currentValue);
    
}

- (IBAction)autoButtonClick:(id)sender {
    
    [self.openGLView toggleDisplayLink];
    
    UIButton * button = (UIButton *)sender;
    NSString * text = button.titleLabel.text;
    if ([text isEqualToString:@"Auto"]) {
        [button setTitle: @"Stop" forState: UIControlStateNormal];
    }
    else {
        [button setTitle: @"Auto" forState: UIControlStateNormal];
    }

}


- (IBAction)resetButtonClick:(id)sender {
    [self.openGLView resetTransform];
    [self.openGLView render];
    
    [self resetControls];
}

- (void)resetControls
{
    [self.posXSlider setValue:self.openGLView.posX];
    [self.posYSlider setValue:self.openGLView.posY];
    [self.posZSlider setValue:self.openGLView.posZ];
    
    [self.scaleZSlider setValue:self.openGLView.scaleZ];
    [self.rotateXSlider setValue:self.openGLView.rotateX];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.openGLView = [[OpenGLView alloc] initWithFrame:([[UIScreen mainScreen] bounds])];
    [self.view addSubview:self.openGLView];
    [self.view sendSubviewToBack:self.openGLView];
    
    self.controlView = nil;
}



@end
