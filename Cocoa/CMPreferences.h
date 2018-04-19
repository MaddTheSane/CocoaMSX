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

NS_ASSUME_NONNULL_BEGIN

@class CMInputDeviceLayout;

@interface CMPreferences : NSObject

typedef NS_ENUM(NSInteger, CMSnapshotIconStyle) {
    CMSnapshotIconStyleNone      = 0,
    CMSnapshotIconStyleScreen    = 1,
    CMSnapshotIconStyleFilmstrip = 2
};

@property (class, readonly, strong) CMPreferences *preferences;

@property (strong) CMInputDeviceLayout *keyboardLayout;

+ (CMInputDeviceLayout *)defaultKeyboardLayout;
+ (CMInputDeviceLayout *)defaultJoystickOneLayout;
+ (CMInputDeviceLayout *)defaultJoystickTwoLayout;

@property (readonly, copy) NSURL *appSupportUrl;
@property (readonly, copy) NSString *appSupportDirectory;

- (NSString *)audioCaptureDirectory;
- (void)setAudioCaptureDirectory:(NSString *)directory;
- (NSString *)videoCaptureDirectory;
- (void)setVideoCaptureDirectory:(NSString *)directory;
- (NSString *)sramDirectory;
- (void)setSramDirectory:(NSString *)directory;
- (NSString *)cassetteDataDirectory;
- (void)setCassetteDataDirectory:(NSString *)directory;
- (NSString *)databaseDirectory;
- (void)setDatabaseDirectory:(NSString *)directory;
- (NSString *)machineDirectory;
- (void)setMachineDirectory:(NSString *)directory;
- (NSString *)snapshotDirectory;
- (void)setSnapshotDirectory:(NSString *)directory;

@property (copy) NSURL *audioCaptureURLDirectory;
@property (copy) NSURL *videoCaptureURLDirectory;
@property (copy) NSURL *sramURLDirectory;
@property (copy) NSURL *cassetteDataURLDirectory;
@property (copy) NSURL *databaseURLDirectory;
@property (copy) NSURL *machineURLDirectory;
@property (copy) NSURL *snapshotURLDirectory;

@property (readonly) BOOL createAudioCaptureDirectory;
@property (readonly) BOOL createVideoCaptureDirectory;
@property (readonly) BOOL createSramDirectory;
@property (readonly) BOOL createCassetteDataDirectory;
@property (readonly) BOOL createDatabaseDirectory;
@property (readonly) BOOL createMachineDirectory;
@property (readonly) BOOL createSnapshotDirectory;

- (void)setCassetteDirectory:(NSString *)directory;
- (NSString *)cassetteDirectory;
- (void)setCartridgeDirectory:(NSString *)directory;
- (NSString *)cartridgeDirectory;
- (void)setDiskDirectory:(NSString *)directory;
- (NSString *)diskDirectory;

@property (copy, nullable) NSURL *cassetteURLDirectory;
@property (copy, nullable) NSURL *cartridgeURLDirectory;
@property (copy, nullable) NSURL *diskURLDirectory;

@end

NS_ASSUME_NONNULL_END
