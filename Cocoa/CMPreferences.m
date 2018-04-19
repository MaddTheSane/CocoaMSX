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
#import "CMPreferences.h"
#import "CMEmulatorController.h"

#import "CMInputDeviceLayout.h"

#import "NSString+CMExtensions.h"

NSString * const CMKeyboardLayoutPrefKey = @"msxKeyboardLayout";
static NSString * const CMJoystickOneLayoutPrefKey = @"msxJoystickOneLayout";
static NSString * const CMJoystickTwoLayoutPrefKey = @"msxJoystickTwoLayout";

static NSString * const CMAudioCaptureDirectoryKey = @"audioCaptureDirectory";
static NSString * const CMVideoCaptureDirectoryKey = @"videoCaptureDirectory";
static NSString * const CMSramDirectoryKey = @"sramDirectory";
static NSString * const CMCassetteDataDirectoryKey = @"cassetteDataDirectory";
static NSString * const CMDatabaseDirectoryKey = @"databaseDirectory";
static NSString * const CMMachineDirectoryKey = @"machineDirectory";
static NSString * const CMSnapshotDirectoryKey = @"snapshotDirectory";

static NSString * const CMCassetteDirectoryKey = @"cassetteDirectory";
static NSString * const CMCartridgeDirectoryKey = @"cartridgeDirectory";
static NSString * const CMDiskDirectoryKey = @"diskDirectory";

@interface CMPreferences ()

- (NSString *)appSupportSubdirectoryForKey:(NSString *)preferenceKey
                             defaultSuffix:(NSString *)defaultSuffix;
- (void)setAppSupportSubdirectoryForKey:(NSString *)preferenceKey
                      withDefaultSuffix:(NSString *)defaultSuffix
                            toDirectory:(NSString *)directory;
- (NSURL *)appSupportURLForKey:(NSString *)preferenceKey
                 defaultSuffix:(NSString *)defaultSuffix;
- (void)setAppSupportURLForKey:(NSString *)preferenceKey
             withDefaultSuffix:(NSString *)defaultSuffix
                         toURL:(NSURL *)directory;

@end

@implementation CMPreferences

+ (CMPreferences *)preferences
{
    static CMPreferences *preferences = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        preferences = [[CMPreferences alloc] init];
    });
    
    return preferences;
}

#pragma mark - Private Methods

- (NSString *)appSupportDirectory
{
    return [[self appSupportUrl] path];
}

- (NSURL *)appSupportUrl
{
    NSFileManager* fm = [NSFileManager defaultManager];
    NSURL *appSupportUrl = [[fm URLsForDirectory:NSApplicationSupportDirectory
                                       inDomains:NSUserDomainMask] lastObject];
    
    if (!appSupportUrl)
        return nil;
    
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *appName = [[bundlePath lastPathComponent] stringByDeletingPathExtension];
    
    return [appSupportUrl URLByAppendingPathComponent:appName];
}

- (NSString *)appSupportSubdirectoryForKey:(NSString *)preferenceKey
                             defaultSuffix:(NSString *)defaultSuffix
{
    return [[self appSupportURLForKey:preferenceKey defaultSuffix:defaultSuffix] path];
}

- (NSURL *)appSupportURLForKey:(NSString *)preferenceKey
                 defaultSuffix:(NSString *)defaultSuffix
{
    NSURL *directory = [[NSUserDefaults standardUserDefaults] URLForKey:preferenceKey];
    if (!directory)
        directory = [[self appSupportUrl] URLByAppendingPathComponent:defaultSuffix isDirectory:YES];
    
    return directory;
}

- (void)setAppSupportSubdirectoryForKey:(NSString *)preferenceKey
                      withDefaultSuffix:(NSString *)defaultSuffix
                            toDirectory:(NSString *)directory
{
    [self setAppSupportURLForKey:preferenceKey
               withDefaultSuffix:defaultSuffix
                           toURL:[NSURL fileURLWithPath:directory
                                            isDirectory:YES]];
}

- (void)setAppSupportURLForKey:(NSString *)preferenceKey
             withDefaultSuffix:(NSString *)defaultSuffix
                         toURL:(NSURL *)directory
{
    [[NSUserDefaults standardUserDefaults] setURL:directory
                                           forKey:preferenceKey];
}

#pragma mark - Input Devices

- (CMInputDeviceLayout *)keyboardLayout;
{
    NSData *layoutData = [[NSUserDefaults standardUserDefaults] objectForKey:CMKeyboardLayoutPrefKey];
    return [NSKeyedUnarchiver unarchiveObjectWithData:layoutData];
}

- (void)setKeyboardLayout:(CMInputDeviceLayout *) keyboardLayout;
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:keyboardLayout];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:CMKeyboardLayoutPrefKey];
}

+ (CMInputDeviceLayout *)defaultKeyboardLayout
{
    NSURL *bundleResourcePath = [[NSBundle mainBundle] URLForResource:@"Defaults" withExtension:@"plist"];
    NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfURL:bundleResourcePath];
    
    NSData *layoutData = [defaults objectForKey:CMKeyboardLayoutPrefKey];
    return [NSKeyedUnarchiver unarchiveObjectWithData:layoutData];
}

+ (CMInputDeviceLayout *)defaultJoystickOneLayout
{
    NSURL *bundleResourcePath = [[NSBundle mainBundle] URLForResource:@"Defaults" withExtension:@"plist"];
    NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfURL:bundleResourcePath];

    NSData *layoutData = [defaults objectForKey:CMJoystickOneLayoutPrefKey];
    return [NSKeyedUnarchiver unarchiveObjectWithData:layoutData];
}

+ (CMInputDeviceLayout *)defaultJoystickTwoLayout
{
    NSURL *bundleResourcePath = [[NSBundle mainBundle] URLForResource:@"Defaults" withExtension:@"plist"];
    NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfURL:bundleResourcePath];

    NSData *layoutData = [defaults objectForKey:CMJoystickTwoLayoutPrefKey];
    return [NSKeyedUnarchiver unarchiveObjectWithData:layoutData];
}

#pragma mark - File Management

- (BOOL)createAudioCaptureDirectory
{
    return [[NSUserDefaults standardUserDefaults] URLForKey:CMAudioCaptureDirectoryKey] == nil;
}

- (NSString *)audioCaptureDirectory
{
    return [self.audioCaptureURLDirectory path];
}

- (void)setAudioCaptureDirectory:(NSString *)directory
{
    self.audioCaptureURLDirectory = [NSURL fileURLWithPath:directory
                                               isDirectory:YES];
}

- (NSURL *)audioCaptureURLDirectory
{
    return [self appSupportURLForKey:CMAudioCaptureDirectoryKey
                       defaultSuffix:@"Audio Capture"];
}

- (void)setAudioCaptureURLDirectory:(NSURL *)audioCaptureURLDirectory
{
    [self setAppSupportURLForKey:CMAudioCaptureDirectoryKey
               withDefaultSuffix:@"Audio Capture"
                           toURL:audioCaptureURLDirectory];
}

- (BOOL)createVideoCaptureDirectory
{
    return [[NSUserDefaults standardUserDefaults] URLForKey:CMVideoCaptureDirectoryKey] == nil;
}

- (NSString *)videoCaptureDirectory
{
    return [self.videoCaptureURLDirectory path];
}

- (void)setVideoCaptureDirectory:(NSString *)directory
{
    self.videoCaptureURLDirectory = [NSURL fileURLWithPath:directory
                                               isDirectory:YES];
}

- (NSURL *)videoCaptureURLDirectory
{
    return [self appSupportURLForKey:CMVideoCaptureDirectoryKey
                       defaultSuffix:@"Video Capture"];
}

- (void)setVideoCaptureURLDirectory:(NSURL *)audioCaptureURLDirectory
{
    [self setAppSupportURLForKey:CMVideoCaptureDirectoryKey
               withDefaultSuffix:@"Video Capture"
                           toURL:audioCaptureURLDirectory];
}

- (BOOL)createSramDirectory
{
    return [[NSUserDefaults standardUserDefaults] URLForKey:CMSramDirectoryKey] == nil;
}

- (NSString *)sramDirectory
{
    return [self.sramURLDirectory path];
}

- (void)setSramDirectory:(NSString *)directory
{
    self.sramURLDirectory = [NSURL fileURLWithPath:directory
                                       isDirectory:YES];
}

- (NSURL *)sramURLDirectory
{
    return [self appSupportURLForKey:CMSramDirectoryKey
                       defaultSuffix:@"SRAM"];
}

- (void)setSramURLDirectory:(NSURL *)audioCaptureURLDirectory
{
    [self setAppSupportURLForKey:CMSramDirectoryKey
               withDefaultSuffix:@"SRAM"
                           toURL:audioCaptureURLDirectory];
}

- (BOOL)createCassetteDataDirectory
{
    return [[NSUserDefaults standardUserDefaults] URLForKey:CMCassetteDataDirectoryKey] == nil;
}

- (NSString *)cassetteDataDirectory
{
    return [self.cassetteDataURLDirectory path];
}

- (void)setCassetteDataDirectory:(NSString *)directory
{
    self.cassetteDataURLDirectory = [NSURL fileURLWithPath:directory
                                               isDirectory:YES];
}

- (NSURL *)cassetteDataURLDirectory
{
    return [self appSupportURLForKey:CMCassetteDataDirectoryKey
                       defaultSuffix:@"Cassettes"];
}

- (void)setCassetteDataURLDirectory:(NSURL *)audioCaptureURLDirectory
{
    [self setAppSupportURLForKey:CMCassetteDataDirectoryKey
               withDefaultSuffix:@"Cassettes"
                           toURL:audioCaptureURLDirectory];
}

- (BOOL)createDatabaseDirectory
{
    return [[NSUserDefaults standardUserDefaults] URLForKey:CMDatabaseDirectoryKey] == nil;
}

- (NSString *)databaseDirectory
{
    return [self.databaseURLDirectory path];
}

- (void)setDatabaseDirectory:(NSString *)directory
{
    self.databaseURLDirectory = [NSURL fileURLWithPath:directory
                                           isDirectory:YES];
}

- (NSURL *)databaseURLDirectory
{
    return [self appSupportURLForKey:CMDatabaseDirectoryKey
                       defaultSuffix:@"Databases"];
}

- (void)setDatabaseURLDirectory:(NSURL *)audioCaptureURLDirectory
{
    [self setAppSupportURLForKey:CMDatabaseDirectoryKey
               withDefaultSuffix:@"Databases"
                           toURL:audioCaptureURLDirectory];
}

- (BOOL)createMachineDirectory
{
    return [[NSUserDefaults standardUserDefaults] URLForKey:CMMachineDirectoryKey] == nil;
}

- (NSString *)machineDirectory
{
    return [self.machineURLDirectory path];
}

- (void)setMachineDirectory:(NSString *)directory
{
    self.machineURLDirectory = [NSURL fileURLWithPath:directory
                                          isDirectory:YES];
}

- (NSURL *)machineURLDirectory
{
    return [self appSupportURLForKey:CMMachineDirectoryKey
                       defaultSuffix:@"Machines"];
}

- (void)setMachineURLDirectory:(NSURL *)audioCaptureURLDirectory
{
    [self setAppSupportURLForKey:CMMachineDirectoryKey
               withDefaultSuffix:@"Machines"
                           toURL:audioCaptureURLDirectory];
}

- (BOOL)createSnapshotDirectory
{
    return [[NSUserDefaults standardUserDefaults] URLForKey:CMSnapshotDirectoryKey] == nil;
}

- (NSString *)snapshotDirectory
{
    return [self.snapshotURLDirectory path];
}

- (void)setSnapshotDirectory:(NSString *)directory
{
    self.snapshotURLDirectory = [NSURL fileURLWithPath:directory
                                           isDirectory:YES];
}

- (NSURL *)snapshotURLDirectory
{
    return [self appSupportURLForKey:CMSnapshotDirectoryKey
                       defaultSuffix:@"Snapshots"];
}

- (void)setSnapshotURLDirectory:(NSURL *)audioCaptureURLDirectory
{
    [self setAppSupportURLForKey:CMSnapshotDirectoryKey
               withDefaultSuffix:@"Snapshots"
                           toURL:audioCaptureURLDirectory];
}

#pragma mark Emulation

- (void)setCassetteURLDirectory:(NSURL *)cassetteURLDirectory
{
    [[NSUserDefaults standardUserDefaults] setURL:cassetteURLDirectory
                                           forKey:CMCassetteDirectoryKey];
}

- (NSURL *)cassetteURLDirectory
{
    return [[NSUserDefaults standardUserDefaults] URLForKey:CMCassetteDirectoryKey];
}

- (void)setCassetteDirectory:(NSString *)directory
{
    self.cassetteURLDirectory = [NSURL fileURLWithPath:directory
                                           isDirectory:YES];
}

- (NSString *)cassetteDirectory
{
    return [self.cassetteURLDirectory path];
}

- (void)setCartridgeURLDirectory:(NSURL *)cassetteURLDirectory
{
    [[NSUserDefaults standardUserDefaults] setURL:cassetteURLDirectory
                                           forKey:CMCartridgeDirectoryKey];
}

- (NSURL *)cartridgeURLDirectory
{
    return [[NSUserDefaults standardUserDefaults] URLForKey:CMCartridgeDirectoryKey];
}

- (void)setCartridgeDirectory:(NSString *)directory
{
    self.cartridgeURLDirectory = [NSURL fileURLWithPath:directory
                                            isDirectory:YES];
}

- (NSString *)cartridgeDirectory
{
    return [self.cartridgeURLDirectory path];
}

- (void)setDiskURLDirectory:(NSURL *)cassetteURLDirectory
{
    [[NSUserDefaults standardUserDefaults] setURL:cassetteURLDirectory
                                           forKey:CMDiskDirectoryKey];
}

- (NSURL *)diskURLDirectory
{
    return [[NSUserDefaults standardUserDefaults] URLForKey:CMDiskDirectoryKey];
}

- (void)setDiskDirectory:(NSString *)directory
{
    self.diskURLDirectory = [NSURL fileURLWithPath:directory
                                       isDirectory:YES];
}

- (NSString *)diskDirectory
{
    return [self.diskURLDirectory path];
}

@end
