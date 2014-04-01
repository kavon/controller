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

@end

@implementation MissionItem

// encoder to serialize missionItem entirely
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_missionName forKey:@"missionName"];
    [encoder encodeObject:_missionHealthURL forKey:@"missionHealthURL"];
    [encoder encodeDouble:_missionNortheast.latitude forKey:@"missionNortheast_lat"];
    [encoder encodeDouble:_missionNortheast.longitude forKey:@"missionNortheast_long"];
    [encoder encodeDouble:_missionSouthwest.latitude forKey:@"missionSouthwest_lat"];
    [encoder encodeDouble:_missionSouthwest.longitude forKey:@"missionSouthwest_long"];
    [encoder encodeObject:_cache forKey:@"cache"];
}

// init constructor to create from encoded file
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        // decode mission name and URL
        self.missionName = [decoder decodeObjectForKey:@"missionName"];
        self.missionHealthURL = [decoder decodeObjectForKey:@"missionHealthURL"];
        
        
        // decode CLLocationCoordinate2D
        // decode missionNortheast first
        double lat_i = [decoder decodeDoubleForKey:@"missionNortheast_lat"];
        double long_i = [decoder decodeDoubleForKey:@"missionNortheast_long"];
        
        CLLocationCoordinate2D coord_i;
        coord_i.latitude = lat_i;
        coord_i.longitude = long_i;
        self.missionNortheast = coord_i;
        
        
        // decode missionSouthwest
        lat_i = [decoder decodeDoubleForKey:@"missionSouthwest_lat"];
        long_i = [decoder decodeDoubleForKey:@"missionSouthwest_long"];
        
        coord_i.latitude = lat_i;
        coord_i.longitude = long_i;
        self.missionSouthwest = coord_i;
        
        
        // decode cache
        self.cache = [decoder decodeObjectForKey:@"cache"];
    }
    return self;
}


@end
