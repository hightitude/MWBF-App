//
//  MoreViewController.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/5/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "MoreViewController.h"
#import "MWBFService.h"
#import "Utils.h"
#import "User.h"
#import <MessageUI/MessageUI.h>
#import <FacebookSDK/FacebookSDK.h>

#define OK_INDEX 0

@interface MoreViewController ()
@property (weak, nonatomic) IBOutlet UIButton *resetUserDataButton;
@property (strong, nonatomic) UIAlertView *deleteActivitiesAlert;
@property (strong, nonatomic) UIAlertView *refreshDataAlert;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UITextView *infoView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePic;
@property (weak, nonatomic) IBOutlet UIButton *messagesButton;
@property (weak, nonatomic) IBOutlet UIButton *numberOfNotificationsButton;
@property (strong,nonatomic) User *user;
@property (strong,nonatomic) MFMailComposeViewController *mcvc;

@end

@implementation MoreViewController

@synthesize resetUserDataButton,deleteActivitiesAlert,refreshButton,refreshDataAlert;
@synthesize userNameLabel;
@synthesize profilePic;
@synthesize messagesButton,numberOfNotificationsButton;
@synthesize user;
@synthesize mcvc;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.user = [User getInstance];
    self.userNameLabel.text = [NSString stringWithFormat:@"%@",self.user.userName];
    
    self.infoView.hidden = YES;
    [Utils setMaskTo:self.infoView byRoundingCorners:UIRectCornerAllCorners];
    [Utils setRoundedView:self.profilePic toDiameter:35];
    self.profilePic.profileID = self.user.fbProfileID;
    
    // Only show this if you have new messages.
    self.numberOfNotificationsButton.hidden = YES;
    
    self.mcvc = [[MFMailComposeViewController alloc] init];
    self.mcvc.mailComposeDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Check if there are new messages
    self.user = [User getInstance];
    //if ([self.user.notificationsList count] > 0 || [self.user.friendsActivitiesList count] > 0 )
    // TODO : Must check the FriendActivityList count too and show the red circle for something new
    /*
    if ([self.user.notificationsList count] > 0 )
    {
        self.numberOfNotificationsButton.hidden = NO;
        NSInteger newMessages = [self.user.notificationsList count] + [self.user.friendsActivitiesList count];
        self.numberOfNotificationsButton.titleLabel.text = [NSString stringWithFormat:@"%lu",(long)newMessages];
    }
    else
        self.numberOfNotificationsButton.hidden = YES;
     */
}

// Dismiss the keyboard when the background is tapped
- (IBAction)backgroundTap:(id)sender
{
    self.infoView.hidden = YES;
}

- (IBAction)resetUserDataClicked:(id)sender
{
    self.deleteActivitiesAlert = [[UIAlertView alloc] initWithTitle: @"Clean up" message: @"Do you really want to delete all your logged activities (irreversible) ?" delegate: self cancelButtonTitle: @"YES"  otherButtonTitles:@"NO",nil];
    
    [self.deleteActivitiesAlert show];
    
}

// Refresh all the users data
- (IBAction)refreshButtonClicked:(id)sender
{
    self.refreshDataAlert = [[UIAlertView alloc] initWithTitle: @"Refresh" message: @"Do you want to refresh all your data (could take a few seconds) ?" delegate: self cancelButtonTitle: @"YES"  otherButtonTitles:@"NO",nil];
    
    [self.refreshDataAlert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"messageDetails"])
    {
        self.numberOfNotificationsButton.titleLabel.text = @"0";
        self.numberOfNotificationsButton.hidden = YES;
    }
}

- (IBAction)inviteFriend:(id)sender
{
    [self.mcvc.navigationBar setBackgroundImage:[UIImage imageNamed:@"background-2.png"] forBarMetrics:UIBarMetricsDefault];
    self.mcvc.navigationBar.tintColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    [self.mcvc setSubject:@"Check out this app : MWBF"];
    [self.mcvc setMessageBody:@"\nLet's get fit together : MWBF, http://signup.mwbflife.com" isHTML:YES];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    UIImage *ui = [UIImage imageNamed:@"mwbf_collage-png"];
    pasteboard.image = ui;
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(ui)];
    [self.mcvc addAttachmentData:imageData mimeType:@"image/png" fileName:@" "];

    [self presentViewController:self.mcvc animated:YES completion:nil];
}



- (IBAction)sendFeedback:(id)sender
{
    [self.mcvc setMailComposeDelegate:self];
    NSString *email =@"feedback@mwbflife.com";
    NSArray *emailArray = [[NSArray alloc] initWithObjects:email, nil];
    [self.mcvc setToRecipients:emailArray];
    [self.mcvc setSubject:@"MWBF Feedback"];
    [self presentViewController:self.mcvc animated:YES completion:nil];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self cycleTheGlobalMailComposer];
}

-(void)cycleTheGlobalMailComposer
{
    // we are cycling the damned GlobalMailComposer... due to horrible iOS issue
    self.mcvc = nil;
    self.mcvc = [[MFMailComposeViewController alloc] init];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( alertView == self.deleteActivitiesAlert )
    {
        if ( buttonIndex == OK_INDEX )
        {
            NSLog(@"Deleting all of the users data.");
            MWBFService *service = [[MWBFService alloc] init];
            BOOL success = [service deleteAllActivitiesForUser];
        
            if (!success)
                [Utils alertStatus:@"Reset Failed!" :@"Unable to delete user data.. Please try again." :0];
        }
    }
    else
    {
        if ( buttonIndex == OK_INDEX )
        {
            self.activityIndicator.hidden = NO;
            [self.activityIndicator startAnimating];
            self.view.userInteractionEnabled = NO;
            
            dispatch_queue_t queue = dispatch_get_global_queue(0,0);
            
            dispatch_async(queue, ^{
                
                [Utils refreshUserData];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.activityIndicator stopAnimating];
                    self.activityIndicator.hidden = YES;
                    self.view.userInteractionEnabled = YES;
                });
            });
        }
    }
}


@end
