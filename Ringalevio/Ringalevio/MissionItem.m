//
//  MissionItem.m
//  Ringalevio
//
//  Created by Sean Lane on 3/12/14.
//
//

#import "MissionItem.h"

// interface for private data members
@interface MissionItem ()

// mission longitude and latitude center (for maps? different params if need be)
@property (nonatomic)  NSNumber *missionLatitude;
@property (nonatomic)  NSNumber *missionLongitude;

@end

@implementation MissionItem

// setter for mission coordinates (for caching maps, may need to be more complicated than a single number)
-(void)setMissionLongitude:(NSNumber *)missionLong
{
    _missionLongitude = missionLong;
}

-(void)setMissionLatitude:(NSNumber *)missionLat
{
    _missionLatitude = missionLat;
}

@end
