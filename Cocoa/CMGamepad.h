/*****************************************************************************
 **
 ** CocoaMSX: MSX Emulator for Mac OS X
 ** http://www.cocoamsx.com
 ** Copyright (C) 2012-2016 Akop Karapetyan
 **
 ** This program is free software; you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation; either version 2 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program; if not, write to the Free Software
 ** Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 **
 ******************************************************************************
 */
#import <Foundation/Foundation.h>
#import <IOKit/hid/IOHIDLib.h>

@interface CMGamepad : NSObject

@property (nonatomic, weak) id delegate;
@property (nonatomic, assign) NSInteger gamepadId;
@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, readonly) NSInteger locationId;
@property (nonatomic, readonly) int vendorId;
@property (nonatomic, readonly) int productId;
@property (nonatomic, readonly) NSString *name;

+ (NSArray *)allGamepads;

- (id)initWithHidDevice:(IOHIDDeviceRef)device;

- (void)registerForEvents;

@property (readonly) UInt32 vendorProductId;
- (NSString *)vendorProductString;

- (NSMutableDictionary *)currentAxisValues;

@end
