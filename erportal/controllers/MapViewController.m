//
//  MapViewController.m
//  erportal
//
//   
//  Copyright © 2016 Сергей Першиков. All rights reserved.
//

#import "MapViewController.h"
#import "MoAnnotation.h"

@interface MapViewController (){
    BOOL userLocationShown;
}

@end

@implementation MapViewController


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    //NSLog(@"%@", [self deviceLocation]);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    PFQuery *queryLocal = [PFQuery queryWithClassName:[MoEntity parseClassName]];
    [queryLocal fromLocalDatastore];
    NSArray *mos = [queryLocal findObjects];
    
    for (MoEntity *mo in mos) {
        if (mo.latitude.length > 0) {
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            span.latitudeDelta=1;
            span.longitudeDelta=1;
            
            CLLocationCoordinate2D location;
            location.latitude = [mo.latitude doubleValue];
            location.longitude = [mo.longitude doubleValue];
            region.span=span;
            region.center=location;
            
            // Add an annotation
            MoAnnotation *point = [[MoAnnotation alloc] init];
            point.coordinate = location;
            point.title = mo.name;
            point.subtitle = mo.address;
            point.mo = mo;
            
            
            [self.mapView addAnnotation:point];
            [self.mapView setRegion:region animated:TRUE];
            [self.mapView regionThatFits:region];
        }
    }
    
    [self.mapView setMapType:MKMapTypeStandard];
    self.mapView.showsUserLocation = YES;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MoAnnotation *annotation = (MoAnnotation *)view.annotation;
    
    MoEntity *mo = [MoEntity new];
    mo = annotation.mo;
    
    RegionEntity *region = [RegionEntity new];
    region.value = mo.district;
    region.code = mo.district_code;
    
    [[GlobalCache shareManager].recordСache setObject:region forKey:@CACHE_KEY_RECORD_REGION];
    [[GlobalCache shareManager].recordСache setObject:mo forKey:@CACHE_KEY_RECORD_MO];
    [self performSegueWithIdentifier:@"ToMain" sender:view];
}


#pragma userLocation
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if(userLocationShown) return;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    userLocationShown = YES;
}

//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
//{
//    [mapView deselectAnnotation:view.annotation animated:YES];
//    
//    DetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsPopover"];
//    controller.annotation = view.annotation;
//    self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
//    self.popover.delegate = self;
//    [self.popover presentPopoverFromRect:view.frame
//                                  inView:view.superview
//                permittedArrowDirections:UIPopoverArrowDirectionAny
//                                animated:YES];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
