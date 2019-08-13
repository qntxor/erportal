//
//  QuestionViewController.m
//  erportal
//
//  
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "QuestionViewController.h"
#import "QuestionTableViewCell.h"
#import "UIColor+Hexadecimal.h"

@interface QuestionViewController ()

@property NSMutableArray *dataItems;
@property NSMutableArray *filteredDataItems;
@property QuestionService *service;

@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation QuestionViewController


//override func viewDidAppear(animated: Bool) {
//    super.viewDidAppear(animated)
//    
//    NSNotificationCenter.defaultCenter().addObserverForName(UIContentSizeCategoryDidChangeNotification,
//                                                            object: nil,
//                                                            queue: NSOperationQueue.mainQueue()) {
//        [weak self] _ in self?.tableView.reloadData()
//    }
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)viewDidApper{
    [super viewDidAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIContentSizeCategoryDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self.tableView reloadData];
    }];
    QuestionService *service = [QuestionService new];
    service.controller = self;
    [service loadDataInLocalStore:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    DataService *dataService = [DataService new];
    [dataService syncQuestions];
    
    self.dataItems = [NSMutableArray new];
    self.service = [QuestionService new];
    self.service.controller = self;
    [self.dataItems addObjectsFromArray:[self.service dataItems]];
    
    //init searchController
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = false;
    self.definesPresentationContext = true;
    [self.searchController.searchBar setValue:@"Отмена" forKey:@"_cancelButtonText"];
    self.searchController.searchBar.placeholder = @"Найти вопрос";
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    //self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 110.0;
    
    //For empty dataset
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // A little trick for removing the cell separators
    self.tableView.tableFooterView = [UIView new];
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
    QuestionTableViewCell *cell = (QuestionTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    QuestionEntity *item;
    if (self.searchController.active && ![self.searchController.searchBar.text isEqualToString:@""]) {
        item = [self.filteredDataItems objectAtIndex:indexPath.row];
    }else{
        item = [self.dataItems objectAtIndex:indexPath.row];
    }
    
    //В зависимости от типа учреждения проставляем изображения
    cell.timeLabel.text = [Utils dateToString:item.dateQuestion];
    cell.questionLabel.text = item.textQuestion;
    if (item.textAnswer.length > 0) {
        cell.answerLabel.text = item.textAnswer;
    }else{
        cell.answerLabel.text = @"Вопрос ожидает ответа";
    }
    
//    // 4
//    UIView.animateWithDuration(0.3) {
//        cell.contentView.layoutIfNeeded()
//    }
//    
//    // 5
//    tableView.beginUpdates()
//    tableView.endUpdates()
//    
//    // 6
//    tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    
    return cell;
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.filteredDataItems removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.textQuestion contains[c] %@", searchText];
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

#pragma empty dataSet

//The image for the empty state
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"placeholder_airbnb"];
}

//The attributed string for the title of the empty state
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Вопросов нет";
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
    UIColor *textColor = [UIColor colorWithHex:@"c9c9c9"];
    
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: textColor};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//The attributed string for the description of the empty state:
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Когда у вас будут вопросы, вы здесь их увидите.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    paragraph.lineSpacing = 4.0;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName: [UIColor colorWithHex:@"cfcfcf"],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//The attributed string to be used for the specified button state:
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:[UIFont boldSystemFontOfSize:16.0f] forKey:NSFontAttributeName];
    [attributes setObject:[UIColor colorWithHex:(state == UIControlStateNormal) ? @"007ee5" : @"48a1ea"] forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:@"Задать вопрос" attributes:attributes];
}

//The background color for the empty state:

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

//Notifies when the data set call to action button was tapped:
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    [self performSegueWithIdentifier:@"ToAddAsk" sender:self];
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
