//
//  MissionItem.h
//  Ringalevio
//
//  Created by Sean Lane on 3/12/14.
//
//

#import <Foundation/Foundation.h>

@interface MissionItem : NSObject

// identifying name of mission
@property (readonly) NSString *missionName;

// URL of health website (maybe make a global one if it never changes)
@property NSString *missionHealthURL;

//setter for private lat and long
-(void)setMissionLongitude:(NSNumber *)missionLong;

-(void)setMissionLatitude:(NSNumber *)missionLat;

@end
