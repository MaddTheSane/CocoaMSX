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

typedef NSString *CMMachineSystemName NS_STRING_ENUM;
extern CMMachineSystemName const CMMsxMachine;
extern CMMachineSystemName const CMMsx2Machine;
extern CMMachineSystemName const CMMsx2PMachine;
extern CMMachineSystemName const CMMsxTurboRMachine;

typedef NS_ENUM(NSInteger, CMMachineSystem) {
    CMUnknown   = 0,
    CMMsx       = 1,
    CMMsx2      = 2,
    CMMsx2Plus  = 3,
    CMMsxTurboR = 4
};

typedef NS_ENUM(NSInteger, CMMachineStatus) {
    CMMachineDownloadable = 1,
    CMMachineDownloading  = 2,
    CMMachineInstalled    = 3
};

@interface CMMachine : NSObject<NSCopying, NSCoding>

@property (nonatomic, copy) NSString *machineId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *checksum;
@property (nonatomic, strong) NSURL *machineUrl;
@property (nonatomic, assign) CMMachineSystem system;
@property (nonatomic, assign) CMMachineStatus status;
@property (nonatomic, assign, getter=isActive) BOOL active;

+ (instancetype)machineWithPath:(NSString *)path;

- (id)initWithPath:(NSString *)path;
- (id)initWithPath:(NSString *)path
         machineId:(NSString *)machineId
              name:(NSString *)name
        systemName:(CMMachineSystemName)systemName;

- (CMMachineSystemName)systemName;
- (NSString *)downloadPath;

@end
