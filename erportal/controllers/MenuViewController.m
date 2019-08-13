//
//  MenuViewController.m
//  CommonService
//


#import "MenuViewController.h"

@interface MenuViewController (){
    AppEntity *app;
}

@end

@implementation MenuViewController

- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue { }


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void) viewDidAppear:(BOOL)animated{
    //set profile date
    PFQuery *query = [PFQuery queryWithClassName:[AppEntity parseClassName]];
    [query fromLocalDatastore];
    app = [query getFirstObject];
    NSManagedObject *object = [app activeProfileObject];
    NSString *sname = [object valueForKey:@"sname"];
    NSString *name = [object valueForKey:@"name"];
    NSString *pname = [object valueForKey:@"pname"];
    if (![[NSString stringWithFormat:@"%@",sname] isEqualToString:@"(null)"]) {
        self.fioLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@",sname,name,pname];
    }    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        
        //add blur background
        self.tableView.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"background-blur"];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.view.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //blurEffectView.alpha = 0.8;
        
        //[imageView addSubview:blurEffectView];
        self.tableView.backgroundView = imageView;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //disign profile
        [DisignContext setBorderBottomView:self.viewLogin width:1 image:[UIImage imageNamed:@"line"]];
        
    } else {
        self.view.backgroundColor = [UIColor blueColor];
    }
    
    CGRect footerRect = CGRectMake(16, self.view.bounds.size.height - 40, 100, 40);
    UILabel *tableFooter = [[UILabel alloc] initWithFrame:footerRect];
    tableFooter.textColor = [UIColor whiteColor];
    tableFooter.font = [UIFont systemFontOfSize:13];
    tableFooter.text = [NSString stringWithFormat:@"v. %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]] ;
    [self.view addSubview:tableFooter];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleExitTap:)];
    [self.cellChangeProfile addGestureRecognizer:singleFingerTap];
    
    app = [AppEntity new];
}

- (void)handleExitTap:(UITapGestureRecognizer*)sender {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Внимание" message:@"Вы хотите сменить учетную запись?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Да" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    NSManagedObjectContext *context = [CoreDataContext shareManager].context;
                                    NSFetchRequest *fetchProfile = [[NSFetchRequest alloc] initWithEntityName:@"Profile"];
                                    NSMutableArray *profileItems = [[context executeFetchRequest:fetchProfile error:nil] mutableCopy];
                                    //Delete all object and insert new profiles, set first object active profile
                                    for (id profileItem in profileItems)
                                        [context deleteObject:profileItem];
                                    NSError *error = nil;
                                    if (![context save:&error]) {
                                        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                                    }
                                    [app unpinInBackground];
                                    
                                    [self performSegueWithIdentifier:@"ToLogin" sender:self];
                                    
                                }];
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Нет" style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * action)
                               {
                                   
                               }];
    [alertView addAction:yesButton];
    [alertView addAction:noButton];
    [self presentViewController:alertView animated:YES completion:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    NSLog(@"%@",@"prepareForSegue");
//    NSManagedObject *object = [app activeProfileObject];
//    NSString *sname = [object valueForKey:@"sname"];
//    NSString *name = [object valueForKey:@"name"];
//    NSString *pname = [object valueForKey:@"pname"];
//    if (![[NSString stringWithFormat:@"%@",sname] isEqualToString:@"(null)"]) {
//        self.fioLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@",sname,name,pname];
//    }
}

@end
