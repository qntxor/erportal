//
//  DoctorsViewController.m
//  erportal
//

#import "DoctorsViewController.h"
#import "RecordTableViewCell.h"

@interface DoctorsViewController (){
    NSOperationQueue *queue;
    DoctorService *service;
    NSMutableData *responseData;
}
@property NSMutableArray *dataItems;
@property NSMutableArray *filteredDataItems;

@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation DoctorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataItems = [NSMutableArray new];
    service = [DoctorService new];
    MoEntity *mo = [[GlobalCache shareManager].recordСache objectForKey:@CACHE_KEY_RECORD_MO];
    SpecializationEntity *spec = [[GlobalCache shareManager].recordСache objectForKey:@CACHE_KEY_RECORD_SPECIALIZATION];
    service.moId = mo.idx;
    service.specialityId = spec.idx;
    service.controller = self;
    [service loadData:self.dataItems tableView:self.tableView activityIndicator:self.activityIndicatorView];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    //self.searchController.hidesNavigationBarDuringPresentation = false;
    //self.searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    self.searchController.dimsBackgroundDuringPresentation = false;
    self.definesPresentationContext = true;
    //[self.searchController.searchBar sizeToFit];
    //self.navigationItem.titleView = self.searchController.searchBar;
    [self.searchController.searchBar setValue:@"Отмена" forKey:@"_cancelButtonText"];
    self.searchController.searchBar.placeholder = @"Найти врача";
    self.tableView.tableHeaderView = self.searchController.searchBar;
    //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) dealloc{
    [self.searchController.view removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active && ![self.searchController.searchBar.text isEqualToString:@""]) {
        return [self.filteredDataItems count];
    }
    return [self.dataItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordTableViewCell *cell = (RecordTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"RecordCell" forIndexPath:indexPath];
    DoctorEntity *item;
    if (self.searchController.active && ![self.searchController.searchBar.text isEqualToString:@""]) {
        item = [self.filteredDataItems objectAtIndex:indexPath.row];
    }else{
        item = [self.dataItems objectAtIndex:indexPath.row];
    }
    
    //В зависимости от типа учреждения проставляем изображения
    cell.leftImage.image = [UIImage imageNamed:@"appointments-specialization-icon"];
    cell.titleLabel.text = item.fullName;
    
    NSString *text = [NSString stringWithFormat:@"Кабинет: %@", item.cabinet];
    NSMutableAttributedString *string;
    NSRange rangeAll = [text rangeOfString:text];
    NSRange rangeCount = [text rangeOfString:item.cabinet];
    
    string = [[NSMutableAttributedString alloc] initWithString:text];
    [string addAttribute:NSForegroundColorAttributeName value:OUR_APP_COLOR_TEXT_TITLE range:rangeAll];
    
    [string addAttribute:NSFontAttributeName value:OUR_APP_FONT_TEXT_COUNT range:rangeCount];
    [string addAttribute:NSForegroundColorAttributeName value:OUR_APP_COLOR_TEXT_COUNT range:rangeCount];
    
    [cell.descLabel setAttributedText:string];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DoctorEntity *model;
    if (self.searchController.active && ![self.searchController.searchBar.text isEqualToString:@""]) {
        model = [self.filteredDataItems objectAtIndex:indexPath.row];
    } else {
        model = [self.dataItems objectAtIndex:indexPath.row];
    }
    
    [[GlobalCache shareManager].recordСache setObject:model forKey:@CACHE_KEY_RECORD_DOCTOR];
    
    //self.navigationController.navigationBar.translucent = YES;
    [self.searchController setActive:NO];
    //[self.searchController.view removeFromSuperview];
    [self performSegueWithIdentifier:@"ToQueueDay" sender:self];
}


#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.filteredDataItems removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.fullName contains[c] %@", searchText];
    self.filteredDataItems = [NSMutableArray arrayWithArray:[self.dataItems filteredArrayUsingPredicate:predicate]];
    [self.tableView reloadData];
}



-(void) updateSearchResultsForSearchController:(UISearchController *)searchController{
    [self filterContentForSearchText:searchController.searchBar.text scope:
     [[searchController.searchBar scopeButtonTitles] objectAtIndex:[searchController.searchBar selectedScopeButtonIndex]]];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     ServicesViewController *nextController = (ServicesViewController *)segue.destinationViewController;
//     [nextController setDoctorId:self.segueValue];
//     [nextController setOrganizationId:self.organizationId];
// }



@end
