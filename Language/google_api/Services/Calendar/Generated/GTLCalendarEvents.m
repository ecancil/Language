/* Copyright (c) 2011 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
//  GTLCalendarEvents.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   Calendar API (calendar/v3)
// Description:
//   Lets you manipulate events and other calendar data.
// Documentation:
//   http://code.google.com/apis/calendar/v3/using.html
// Classes:
//   GTLCalendarEvents (0 custom class methods, 10 custom properties)

#import "GTLCalendarEvents.h"

#import "GTLCalendarEvent.h"
#import "GTLCalendarEventReminder.h"

// ----------------------------------------------------------------------------
//
//   GTLCalendarEvents
//

@implementation GTLCalendarEvents
@dynamic accessRole, defaultReminders, descriptionProperty, ETag, items, kind,
         nextPageToken, summary, timeZone, updated;

+ (NSDictionary *)propertyToJSONKeyMap {
  NSDictionary *map =
    [NSDictionary dictionaryWithObjectsAndKeys:
      @"description", @"descriptionProperty",
      @"etag", @"ETag",
      nil];
  return map;
}

+ (NSDictionary *)arrayPropertyToClassMap {
  NSDictionary *map =
    [NSDictionary dictionaryWithObjectsAndKeys:
      [GTLCalendarEventReminder class], @"defaultReminders",
      [GTLCalendarEvent class], @"items",
      nil];
  return map;
}

+ (void)load {
  [self registerObjectClassForKind:@"calendar#events"];
}

@end
