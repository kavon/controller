//
//  MissionItem.h
//  Ringalevio
//
//  Created by Sean Lane on 3/12/14.
//
//

#import <Foundation/Foundation.h>
#import <Mapbox/Mapbox.h>
#import <MapKit/MapKit.h>

@interface MissionItem : NSObject

// identifying name of mission
@property NSString *missionName;

// URL of health website (maybe make a global one if it never changes)
@property NSString *missionHealthURL;

// mission longitude and latitude center (for maps? different params if need be)
@property CLLocationCoordinate2D missionNortheast;
@property CLLocationCoordinate2D missionSouthwest;

// Mapbox cache system
@property RMTileCache *cache;


@end
