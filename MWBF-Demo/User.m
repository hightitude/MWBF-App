//
//  User.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/1/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize userId = _userId;
@synthesize userEmail = _userEmail;
@synthesize userName = _userName;
@synthesize friendsList = _friendsList;
@synthesize bestDay,bestWeek,bestMonth,bestYear,bestDayPoints,bestWeekPoints,bestMonthPoints,bestYearPoints;
@synthesize challengesList;
@synthesize fbProfileID;
@synthesize notificationsList,friendsActivitiesList;
@synthesize favActivityList;
@synthesize activityNotifications,friendsAndChallengesNotifications;
@synthesize backgroundImageName;
@synthesize weeklyPointsUser,weeklyPointsFriendsAverage,weeklyPointsLeader;
@synthesize randomQuote;

@synthesize bestDayLeader,bestWeekLeader,bestMonthLeader,bestYearLeader;
@synthesize bestDayLeaderPoints,bestWeekLeaderPoints,bestMonthLeaderPoints,bestYearLeaderPoints;
@synthesize dayLeader,weekLeader,monthLeader,yearLeader;

+ (User *) getInstance
{
    static User *theUser =nil;
    
    if (!theUser )
    {
        theUser = [[super allocWithZone:nil] init];
    }
    
    return theUser;
}

+ (id) allocWithZone:(struct _NSZone *)zone
{
    return [self getInstance];
}

- (id) init
{
    self = [super init];
    if (self)
    {
        self.friendsList = [NSMutableArray array];
        self.notificationsList = [NSMutableArray array];
        self.friendsActivitiesList = [NSMutableArray array];
        self.favActivityList = [NSMutableArray array];
        self.activityNotifications = YES;
        self.friendsAndChallengesNotifications = YES;
        self.backgroundImageName = @"background.jpg";
        
        // Initialize personal stats, so they don't show as "null"
        self.bestDay = @" ";
        self.bestWeek = @"-";
        self.bestMonth = @" ";
        self.bestYear = @" ";
        
        self.bestDayPoints = @" ";
        self.bestWeekPoints = @" ";
        self.bestMonthPoints = @" ";
        self.bestYearPoints = @" ";

        // Initialize the leader stats, so they don't show as "null"
        self.bestDayLeader = @" ";
        self.bestWeekLeader = @"-";
        self.bestMonthLeader = @" ";
        self.bestYearLeader = @" ";
        
        self.bestDayLeaderPoints = @" ";
        self.bestWeekLeaderPoints = @" ";
        self.bestMonthLeaderPoints = @" ";
        self.bestYearLeaderPoints = @" ";
    }
    
    return self;
}

- (NSMutableDictionary *)toNSDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.userId forKey:@"id"];
    
    return dictionary;
}

@end
