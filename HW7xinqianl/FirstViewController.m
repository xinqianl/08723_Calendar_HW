//
//  FirstViewController.m
//  HW7xinqianl
//
//  Created by Xinqian Li on 7/11/16.
//  Copyright © 2016 Xinqian Li. All rights reserved.
//

#import "FirstViewController.h"
#import "CustomViewCell.h"
@interface FirstViewController ()

@end
static NSString *const kKeychainItemName = @"Google Calendar API";
static NSString *const kClientID = @"982039271111-7tk62tnrvdqobtbk63euo45v499ifcf9.apps.googleusercontent.com";
@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailViewController = [[EventDetailViewController alloc]init];
    self.events = [[NSMutableArray alloc]init];
    [self.tableView registerClass:[CustomViewCell class]forCellReuseIdentifier: @"Cell"];
    self.service = [[GTLServiceCalendar alloc] init];
    self.service.authorizer =
    [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                          clientID:kClientID
                                                      clientSecret:nil];
    self.title = @"Calendar Event Table";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.events.count;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSLog(@"showDetail");
        self.detailViewController = [segue destinationViewController];
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.detailViewController.event = self.events[indexPath.row];
    [self.navigationController pushViewController:self.detailViewController animated:YES];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Back"
                                   /// remember to change the target & action parameter to "nil"
                                   style:UIBarButtonItemStyleDone
                                   target:nil
                                   action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    GTLCalendarEvent *event = [self.events objectAtIndex:indexPath.row];
    
    
    GTLDateTime *start = event.start.dateTime ?: event.start.date;
    GTLDateTime *end = event.end.dateTime ?: event.end.date;
    NSString *startString = [NSDateFormatter localizedStringFromDate:[start date]
                                                   dateStyle:NSDateFormatterShortStyle
                                                   timeStyle:NSDateFormatterShortStyle];
    NSString *endString =[NSDateFormatter localizedStringFromDate:[end date]
                                                        dateStyle:NSDateFormatterShortStyle
                                                        timeStyle:NSDateFormatterShortStyle];
    
   
    [cell setSummary:event.summary];
    [cell setDetail:[NSString stringWithFormat:@"%@ - %@ at %@\n", startString, endString, event.location]];
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
// When the view appears, ensure that the Google Calendar API service is authorized, and perform API calls.
- (void)viewDidAppear:(BOOL)animated {
    if (!self.service.authorizer.canAuthorize) {
        // Not yet authorized, request authorization by pushing the login UI onto the UI stack.
        [self presentViewController:[self createAuthController] animated:YES completion:nil];
        
    } else {
        
        [self fetchEvents];
    }
}

// Construct a query and get a list of upcoming events from the user calendar. Display the
// start dates and event summaries in the UITextView.
- (void)fetchEvents {
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsListWithCalendarId:@"5lr4v461mdd2pu55onfcu6prl8@group.calendar.google.com"];
    query.maxResults = 20;
    query.timeMin = [GTLDateTime dateTimeWithDate:[NSDate date]
                                         timeZone:[NSTimeZone localTimeZone]];;
    query.singleEvents = YES;
    query.orderBy = kGTLCalendarOrderByStartTime;
    
    [self.service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(displayResultWithTicket:finishedWithObject:error:)];
}

- (void)displayResultWithTicket:(GTLServiceTicket *)ticket
             finishedWithObject:(GTLCalendarEvents *)events
                          error:(NSError *)error {
    if (error == nil) {
        NSMutableString *eventString = [[NSMutableString alloc] init];
        if (events.items.count > 0) {
            NSLog(@"Upcoming 20 events:\n");
            
            for (GTLCalendarEvent *event in events) {
                [self.events addObject:event];
            }
        } else {
            NSLog(@"No upcoming events found.");
        }
        NSArray *sortedArray;
        sortedArray = [self.events sortedArrayUsingComparator:^NSComparisonResult(GTLCalendarEvent *a, GTLCalendarEvent *b) {
            GTLDateTime *first = a.start.dateTime ?: a.start.date;
            GTLDateTime *second = b.start.dateTime ?: b.start.date;
            
            return second.milliseconds - first.milliseconds;
        }];
        
        [self.tableView reloadData];
        
    } else {
        [self showAlert:@"Error" message:error.localizedDescription];
    }
}



// Creates the auth controller for authorizing access to Google Calendar API.
- (GTMOAuth2ViewControllerTouch *)createAuthController {
    GTMOAuth2ViewControllerTouch *authController;
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    NSArray *scopes = [NSArray arrayWithObjects:kGTLAuthScopeCalendarReadonly, nil];
    authController = [[GTMOAuth2ViewControllerTouch alloc]
                      initWithScope:[scopes componentsJoinedByString:@" "]
                      clientID:kClientID
                      clientSecret:nil
                      keychainItemName:kKeychainItemName
                      delegate:self
                      finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}

// Handle completion of the authorization process, and update the Google Calendar API
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error {
    if (error != nil) {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.service.authorizer = nil;
    }
    else {
        self.service.authorizer = authResult;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
     {
         [alert dismissViewControllerAnimated:YES completion:nil];
     }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}



@end
