//
//  ViewController.m
//  LPLabel
//
//  Created by Penny on 13/03/13.
//  Copyright (c) 2013 Penny. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    LPLabel *label = [[LPLabel alloc] initWithFrame: CGRectMake(0, 0, 200, 0)];
    label.text = @"22岁的詹妮弗劳伦斯，是历史上第二位年轻的奥斯卡影后。虽然他此次战胜86岁的传奇巨星艾玛纽里瓦招来不少质疑，但学院的投票人显然更喜欢这位带有好莱坞黄金年代女性特征的“美国女孩”--健美而非性感、聪明却不精明、自信有敢说敢做。";
    label.linespacing = 16;
    label.font = [UIFont systemFontOfSize: 12];
    [self.view addSubview: label];
    
    label.frame = CGRectMake(20, 20, 200, label.height);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
