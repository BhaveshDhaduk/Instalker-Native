//
//  LoadingViewController.m
//  Instalker
//
//  Created by umut on 23/02/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import "LoadingViewController.h"

@interface LoadingViewController ()
@property (nonatomic,strong) NSTimer* timer;

@property (nonatomic,strong) UIImageView *outerEye;
@property (nonatomic,strong) UIImageView *innerEye;



@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _outerEye = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"outer-eye.png"]];
    _outerEye.frame = _imageViewOuterView.frame;
    _outerEye.contentMode = UIViewContentModeCenter;
    
    _innerEye = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"inner-eye.png"]];
    _innerEye.frame = _imageViewInnerEye.frame;
    _innerEye.contentMode = UIViewContentModeCenter;
    
    [self.view addSubview:_outerEye];
    [self.view addSubview:_innerEye];
    
    _imageViewInnerEye.hidden=YES;
    _imageViewOuterView.hidden=YES;
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startAnimation];

   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - INITILIZATION

-(void)startAnimation
{
    
    [self startLabelAnimation];
    [self startEyeAnimation];
}

-(void)startLabelAnimation
{
    
    [self startLoadingAnimation];
//    UIImageView* dotsImageView= [[UIImageView alloc] initWithFrame:CGRectMake(182, 326, 24, 4)];
//    
//    // load all the frames of your animation
//    dotsImageView.animationImages = @[[UIImage imageNamed:@"dot.png"],
//                                      [UIImage imageNamed:@"dot.png"],
//                                      [UIImage imageNamed:@"dot.png"]];
//    
//    // set how long it will take to go through all images
//    dotsImageView.animationDuration = 10.0;
//    // repeat the animation forever
//    dotsImageView.animationRepeatCount = 0;
//    // start the animation
//    [dotsImageView startAnimating];
//    // add it to the view
//    [self.view addSubview:dotsImageView];
//    
    
}

-(void)startEyeAnimation
{
    
    [self turnAroundOuterEye];
//    [self startFlipAnimation];
    
}

- (void)addCircleMaskToView:(UIView *)view {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.bounds;
    maskLayer.path = [UIBezierPath bezierPathWithOvalInRect:view.bounds].CGPath;
    maskLayer.fillColor = [UIColor whiteColor].CGColor;
    view.layer.mask = maskLayer;
}

- (void)startFlipAnimation{
    [self addCircleMaskToView:_outerEye];
    [self addCircleMaskToView:_outerEye];
    
    [UIView transitionFromView:self.outerEye toView:self.outerEye
                      duration:1.0 options:UIViewAnimationOptionTransitionFlipFromTop
     | UIViewAnimationOptionShowHideTransitionViews
                    completion:nil];
}




-(void)turnAroundOuterEye
{
 
    
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
    
//        _innerEye.alpha = 0.5;
//            _outerEye.transform = CGAffineTransformConcat(                                                            _outerEye.transform,                                                               CGAffineTransformMakeRotation(M_PI*2));
            [_outerEye setTransform:CGAffineTransformMakeRotation(M_PI)];
            [_innerEye setTransform:CGAffineTransformMakeRotation(M_PI)];
            [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
//        _innerEye.alpha=1;
        [self.view layoutIfNeeded];

        
    }];

}

#pragma mark - DOT animation

- (void)startLoadingAnimation {
    [self.labelStalking setText:@"Stalking"];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(updateLoadingLabel) userInfo:nil repeats:YES];
}

- (void)updateLoadingLabel {
    NSString *ellipses = @" . . .";
    
    if ([self.labelStalking.text rangeOfString:ellipses].location == NSNotFound) {
        [self.labelStalking setText:[NSString stringWithFormat:@"%@ .",self.labelStalking.text]];
    } else {
        [self.labelStalking setText:@"Stalking"];
    }
}

- (void)endLoadingAnimation {
    [self.timer invalidate];
    self.timer = nil;
    [self.labelStalking setText:@"Stalking"];
}


- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end
