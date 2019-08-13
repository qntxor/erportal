//
//  HistoryViewController.m
//  erportal
//


#import "HistoryViewController.h"
#import "SlotFinishViewController.h"
#import "TalonTableViewCell.h"

@interface HistoryViewController (){
    NSOperationQueue *queue;
    SlotService *service;
    NSMutableData *responseData;
}
@property NSMutableArray *dataItems;
@property NSManagedObjectContext *context;
@property NSMutableArray *filteredDataItems;

@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation HistoryViewController


- (void)loadInitialData {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Talons"];
    for (NSManagedObject *object in [[self.context executeFetchRequest:fetchRequest error:nil] mutableCopy]) {
        TalonEntity *talon = [TalonEntity new];
        [talon initFromObject:object];
        [self.dataItems addObject:talon];
    }
    [self.activityInicator stopAnimating];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.context = [CoreDataContext shareManager].context;
    self.dataItems = [NSMutableArray new];
    service = [SlotService new];
    [service syncTalons];
    [self loadInitialData];
    
    //Настраиваем поиск
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
    self.searchController.searchBar.placeholder = @"Найти талон";
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    TalonTableViewCell *cell = (TalonTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"TalonCell" forIndexPath:indexPath];
    TalonEntity *item;
    if (self.searchController.active && ![self.searchController.searchBar.text isEqualToString:@""]) {
        item = [self.filteredDataItems objectAtIndex:indexPath.row];
    }else{
        item = [self.dataItems objectAtIndex:indexPath.row];
    }
    
    cell.doctorLabel.text = item.queueName;
    cell.specialityLabel.text = item.speciality;
    cell.moLabel.text = item.moName;
    
    //TODO check to service
    AFHTTPRequestOperation *op = [[ServicePortal instance] statusSlotWithId:item.idx withHash:item.hashTalon];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *data = [responseObject valueForKey:@"data"];
        if(data && data != (id)[NSNull null] && data.count > 0){
            item.status = [[data objectAtIndex:0] valueForKey:@"state"];
            if ([item.status isEqualToString:@"accepted"]) {
                cell.dateLabel.backgroundColor = OUR_APP_COLOR_DAY_FREE;
            }else{
                cell.dateLabel.backgroundColor = OUR_APP_COLOR_DAY_BUSY;
            }
        }else{
            [self presentViewController:[PSIAlertHelper viewAlertBasicMessage:[[responseObject valueForKey:@"_sysinfo"] valueForKey:@"message"]] animated:true completion:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self  presentViewController:[PSIAlertHelper viewAlertAFHTTPRequestOperation:error] animated:true completion:nil];
    }];
    [op start];
    
    NSDateFormatter *formatDate = [NSDateFormatter new];
    formatDate.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
    [formatDate setDateFormat:@"dd MMM"];
    NSString *textDate = [formatDate stringFromDate:[Utils stringToDate:item.date]];
    
    NSString *text = [NSString stringWithFormat:@"%@ %@", textDate, item.time];
    NSMutableAttributedString *string;
    NSRange rangeAll = [text rangeOfString:text];
    NSRange rangeDate = [text rangeOfString:textDate];
    
    string = [[NSMutableAttributedString alloc] initWithString:text];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"arial" size:15.0] range:rangeAll];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"arial" size:12.0] range:rangeDate];
    
    [cell.dateLabel setAttributedText:string];
    
    return cell;
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.filteredDataItems removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.moName contains[c] %@ or self.queueName contains[c] %@ or self.date contains[c] %@", searchText, searchText, searchText];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TalonEntity *model = [self.dataItems objectAtIndex:indexPath.row];
    SlotFinishViewController * vc = (SlotFinishViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle: nil] instantiateViewControllerWithIdentifier:@"SlotFinishViewController"];
    [vc setTalon:model];
    [self.navigationController pushViewController:vc animated:YES];
//    
//    self.segueValue = model;
//    [self performSegueWithIdentifier:@"ToFinishSlot" sender:nil];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier  isEqual: @"ToFinishSlot"]) {
//        SlotFinishViewController *nextController = (SlotFinishViewController *)[segue destinationViewController];
//        [nextController setTalon:self.segueValue];
//    }
    
}
@end
