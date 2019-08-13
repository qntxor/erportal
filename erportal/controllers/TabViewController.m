//
//  TabViewController.m
//  erportal
//


#import "TabViewController.h"
#import "DoctorsViewController.h"
#import "SpecialityViewController.h"
#import "DoctorsViewController.h"
#import "SpecialityViewController.h"

@interface TabViewController ()

@end

@implementation TabViewController

- (void)viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *barButtonLeft = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(Back)];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = barButtonLeft;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:122.0/185.0 blue:1.0 alpha:1.0];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController *vc = [self viewControllerForSegmentIndex:self.typeSegmentedControl.selectedSegmentIndex];
    [self addChildViewController:vc];
    vc.view.frame = self.contentView.bounds;
    [self.contentView addSubview:vc.view];
    self.currentViewController = vc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)Back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIViewController *)viewControllerForSegmentIndex:(NSInteger)index {
    UIViewController *vc;
    switch (index) {
        case 0:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ServicesController"];
            break;
        case 1:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DoctorsController"];
            [(DoctorsViewController *) vc setOrganizationId:self.organizationId];
            break;
        case 2:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SpecialitesController"];
            [(SpecialityViewController *) vc setOrganizationId:self.organizationId];
            break;
    }
    return vc;
}

- (IBAction)switchControllers:(UISegmentedControl *)sender {
    UIViewController *vc = [self viewControllerForSegmentIndex:sender.selectedSegmentIndex];
    [self addChildViewController:vc];
    [self transitionFromViewController:self.currentViewController toViewController:vc duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [self.currentViewController.view removeFromSuperview];
        vc.view.frame = self.contentView.bounds;
        [self.contentView addSubview:vc.view];
    } completion:^(BOOL finished) {
        [vc didMoveToParentViewController:self];
        [self.currentViewController removeFromParentViewController];
        self.currentViewController = vc;
    }];
    self.navigationItem.title = vc.title;
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
