//
//  ProfileInfoViewController.m
//  erportal
//
//  
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "ProfileInfoViewController.h"
#import "ProfileInfoTableViewCell.h"
#import "UIScrollView+APParallaxHeader.h"

#import "PFNavigationDropdownMenu.h"

#define PARALLAX_VIEW_HEIGHT	110

@interface ProfileInfoViewController (){
    NSMutableArray *profileItems;
    AppEntity *app;
    NSMutableArray *items;
}

@property NSManagedObjectContext *context;
@property ProfileEntity *profileEntity;
@property NSMutableArray *dataItems;


//menu
@property (weak, nonatomic) IBOutlet UILabel *selectedCellLabel;

@end

@implementation ProfileInfoViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.profileEntity.profile = [app activeProfileObject];
    [self.profileEntity initFromObject:self.profileEntity.profile];
    
    //NSLog(@"%@",app);
    self.selectedCellLabel.text = items[app.indexActiveProfile];
    
    [self.dataItems removeAllObjects];
    [self.dataItems addObjectsFromArray:[NSArray arrayWithObjects:@[@"ФИО", self.profileEntity.fullName],@[@"Дата рождения", self.profileEntity.birthday],@[@"Полис", self.profileEntity.enp],@[@"Пол", self.profileEntity.sex?@"Муж.":@"Жен."],@[@"email", self.profileEntity.email],@[@"Телефон", self.profileEntity.phone], nil]];
    
    
    // Adding parallax header
    UIImageView *parallaxView = [[UIImageView alloc] init];
    CGRect baseFrame = [PSIDisignContext mainScreenBoundsForCurrentOrientation];
    [parallaxView setFrame:CGRectMake(-20, 0, baseFrame.size.width+40, PARALLAX_VIEW_HEIGHT)];
    parallaxView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    parallaxView.contentMode = UIViewContentModeScaleAspectFill;
    parallaxView.image = [UIImage imageNamed:@"background-profile"];
    [_tableView addParallaxWithView:parallaxView andHeight:PARALLAX_VIEW_HEIGHT];
    
    [_tableView reloadData];
    
    

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Создаем массив для отображения профиля
    self.profileEntity = [ProfileEntity new];
    self.context = [CoreDataContext shareManager].context;
    profileItems = [NSMutableArray new];
    self.dataItems = [NSMutableArray new];
    
    PFQuery *query = [PFQuery queryWithClassName:[AppEntity parseClassName]];
    [query fromLocalDatastore];
    app = [query getFirstObject];
    
    NSFetchRequest *fetchProfile = [[NSFetchRequest alloc] initWithEntityName:@"Profile"];
    profileItems = [[self.context executeFetchRequest:fetchProfile error:nil] mutableCopy];

    items = [NSMutableArray new];
    
    for (NSManagedObject *object in profileItems) {
        [items addObject:[NSString stringWithFormat:@"%@ %@. %@.",[object valueForKey:@"sname"],[(NSString *)[object valueForKey:@"name"] substringToIndex:1],[(NSString *)[object valueForKey:@"pname"] substringToIndex:1]]];
    }
    //Config menu
    
    self.navigationController.navigationBar.translucent = NO;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    PFNavigationDropdownMenu *menuView = [[PFNavigationDropdownMenu alloc] initWithFrame:CGRectMake(0, 0, 300, 44)
                                                                                   title:items[app.indexActiveProfile]
                                                                                   items:items
                                                                           containerView:self.view];
    
    menuView.cellHeight = 50;
    menuView.cellBackgroundColor = self.navigationController.navigationBar.barTintColor;
    menuView.cellSelectionColor = [UIColor colorWithRed:0/255.0 green:160/255.0 blue:195/255.0 alpha: 1.0];
    menuView.cellTextLabelColor = [UIColor whiteColor];
    menuView.cellTextLabelFont = [UIFont fontWithName:@"Avenir-Heavy" size:17];
    menuView.arrowPadding = 15;
    menuView.animationDuration = 0.5f;
    menuView.maskBackgroundColor = [UIColor blackColor];
    menuView.maskBackgroundOpacity = 0.3f;
    menuView.didSelectItemAtIndexHandler = ^(NSUInteger indexPath){
        [app saveActiveProfile:indexPath];
        self.selectedCellLabel.text = items[indexPath];
        [self.profileEntity initFromObject:[app activeProfileObject]];
        [self.dataItems removeAllObjects];
        [self.dataItems addObjectsFromArray:[NSArray arrayWithObjects:@[@"ФИО", self.profileEntity.fullName],@[@"Дата рождения", self.profileEntity.birthday],@[@"Полис", self.profileEntity.enp],@[@"Пол", self.profileEntity.sex?@"Муж.":@"Жен."],@[@"email", self.profileEntity.email],@[@"Телефон", self.profileEntity.phone], nil]];
        
        [app saveActiveProfile:indexPath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    };
    
    self.navigationItem.titleView = menuView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileInfoTableViewCell *cell = (ProfileInfoTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSArray *item = [self.dataItems objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = item[0];
    cell.nameLabel.text = item[1];
    
    return cell;
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
