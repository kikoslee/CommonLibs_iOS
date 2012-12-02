//
//  AdMoGoAdapterAdwoController.m
//  TestMOGOSDKAPP
//
//  Created by Daxiong on 12-10-29.
//
//

#import "AdMoGoAdapterAdwoController.h"

@interface AdMoGoAdapterAdwoController ()

@end

@implementation AdMoGoAdapterAdwoController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setAdView:(AWAdView *)adView{
    [self.view addSubview:adView];
}
@end
