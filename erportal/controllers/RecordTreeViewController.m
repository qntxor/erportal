//
//  RecordTreeViewController.m
//  erportal
//
//  
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "RecordTreeViewController.h"
#import "CoreDataContext.h"
#import "MenuViewController.h"

@interface RecordTreeViewController (){
    AppEntity *app;
}

@end

@implementation RecordTreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //injected temp
    //ERApplicationAssembly *assembly = [[ERApplicationAssembly new] activate];
    //ERStartUpConfigurator *configuration = [assembly defaultConfiguration];
    //NSLog(@"%@",configuration.backgroundColor);
    
    DataService *dataService = [DataService new];
    [dataService syncMo];
    //Проверяем токен в модели, если его нет то перебрасываем на регистрацию приложени
    //[PFObject unpinAllObjectsWithName:PFObjectDefaultPin];
    
    UITapGestureRecognizer *tapCity = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapCity:)];
    self.cityView.userInteractionEnabled = YES;
    [self.cityView addGestureRecognizer:tapCity];
    
    UITapGestureRecognizer *tapMo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapMo:)];
    self.moView.userInteractionEnabled = YES;
    [self.moView addGestureRecognizer:tapMo];
    
    UITapGestureRecognizer *tapSpec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSpec:)];
    self.specView.userInteractionEnabled = YES;
    [self.specView addGestureRecognizer:tapSpec];
    
    UITapGestureRecognizer *tapDoctor = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapDoctor:)];
    self.doctorView.userInteractionEnabled = YES;
    [self.doctorView addGestureRecognizer:tapDoctor];
    
    //Проверяем и показываем экран входа
    PFQuery *queryLocal = [PFQuery queryWithClassName:[AppEntity parseClassName]];
    [queryLocal fromLocalDatastore];
    app = [queryLocal getFirstObject];
    //NSLog(@"%@",app);
    if (app == nil) {
        [self performSegueWithIdentifier:@"ToLogin" sender:self];
        //[self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.pathCityToMo.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"point-four"]];
    self.pathMoToSpec.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"point-four"]];
    self.pathSpecToDoctor.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"point-four"]];
    
    //Получаем необходимую информацию из кэша
    RegionEntity *region = [[GlobalCache shareManager].recordСache objectForKey:@CACHE_KEY_RECORD_REGION];
    self.cityName.text = region.value;
    MoEntity *mo = [[GlobalCache shareManager].recordСache objectForKey:@CACHE_KEY_RECORD_MO];
    self.moName.text = mo.name;
    SpecializationEntity *spec = [[GlobalCache shareManager].recordСache objectForKey:@CACHE_KEY_RECORD_SPECIALIZATION];
    self.specName.text = spec.name;
    DoctorEntity *doctor = [[GlobalCache shareManager].recordСache objectForKey:@CACHE_KEY_RECORD_DOCTOR];
    self.doctorName.text = doctor.fullName;
    
    //Меняем цвета на красоту
    if (self.cityName.text.length) {
        self.cityImageView.image = [UIImage imageNamed:@"appointments-city-icon"];
    }else{
        self.cityImageView.image = [UIImage imageNamed:@"non-appointments-building-icon"];
    }
    if (self.moName.text.length) {
        self.moImageView.image = [UIImage imageNamed:@"appointments-institution-icon"];
    }else{
        self.moImageView.image = [UIImage imageNamed:@"non-appointments-institution-icon"];
    }
    if (self.specName.text.length) {
        self.specImageView.image = [UIImage imageNamed:@"appointments-specialization-icon"];
    }else{
        self.specImageView.image = [UIImage imageNamed:@"non-appointments-specialization-icon"];
    }
    if (self.doctorName.text.length) {
        self.doctorImageView.image = [UIImage imageNamed:@"appointments-doctor-icon"];
    }else{
        self.doctorImageView.image = [UIImage imageNamed:@"non-appointments-doctor-icon"];
    }
    
    //Для ios 10 hack menu label MenuViewController
//    MenuViewController *menuController = (MenuViewController*) [[UIStoryboard storyboardWithName:@"Main"
//                                                                                          bundle: nil]
//                                                                instantiateViewControllerWithIdentifier: @"MenuViewController"];
//    NSManagedObject *object = [app activeProfileObject];
//    NSString *sname = [object valueForKey:@"sname"];
//    NSString *name = [object valueForKey:@"name"];
//    NSString *pname = [object valueForKey:@"pname"];
//    if (![[NSString stringWithFormat:@"%@",sname] isEqualToString:@"(null)"]) {
//        menuController.fioLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@",sname,name,pname];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma handels
- (void)handleTapCity:(UITapGestureRecognizer *)recognizer {
    [self performSegueWithIdentifier:@"ToCity" sender:self];
}

- (void)handleTapMo:(UITapGestureRecognizer *)recognizer {
    if (self.cityName.text.length) {
        [self performSegueWithIdentifier:@"ToMo" sender:self];
    }
}

- (void)handleTapSpec:(UITapGestureRecognizer *)recognizer {
    if (self.moName.text.length) {
        [self performSegueWithIdentifier:@"ToSpec" sender:self];
    }
}

- (void)handleTapDoctor:(UITapGestureRecognizer *)recognizer {
    if (self.specName.text.length) {
        [self performSegueWithIdentifier:@"ToDoctor" sender:self];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
