//
//  SRRecorderControl.h
//  ShortcutRecorder
//
//  Copyright 2006-2007 Contributors. All rights reserved.
//
//  License: BSD
//
//  Contributors:
//      David Dauer
//      Jesper
//      Jamie Kirkpatrick

#import <Cocoa/Cocoa.h>
#import "SRRecorderCell.h"

@interface SRRecorderControl : NSControl
{
	IBOutlet id delegate;
}

#pragma mark *** Aesthetics ***
- (BOOL)animates;
- (void)setAnimates:(BOOL)an;

#pragma mark *** Delegate ***
- (id)delegate;
- (void)setDelegate:(id)aDelegate;

#pragma mark *** Key Combination Control ***

- (NSUInteger)allowedFlags;
- (void)setAllowedFlags:(NSUInteger)flags;

- (BOOL)allowsKeyOnly;
- (void)setAllowsKeyOnly:(BOOL)nAllowsKeyOnly escapeKeysRecord:(BOOL)nEscapeKeysRecord;
- (BOOL)escapeKeysRecord;

- (BOOL)canCaptureGlobalHotKeys;
- (void)setCanCaptureGlobalHotKeys:(BOOL)inState;

- (BOOL)useSingleKeyMode;
- (void)setUseSingleKeyMode:(BOOL)singleKey;

- (BOOL)tableCellMode;
- (void)setTableCellMode:(BOOL)tableCellMode;

- (NSUInteger)requiredFlags;
- (void)setRequiredFlags:(NSUInteger)flags;

- (KeyCombo)keyCombo;
- (void)setKeyCombo:(KeyCombo)aKeyCombo;

- (NSString *)keyChars;
- (NSString *)keyCharsIgnoringModifiers;

#pragma mark -

// Returns the displayed key combination if set
- (NSString *)keyComboString;

#pragma mark *** Conversion Methods ***

- (NSUInteger)cocoaToCarbonFlags:(NSUInteger)cocoaFlags;
- (NSUInteger)carbonToCocoaFlags:(NSUInteger)carbonFlags;

#pragma mark *** Binding Methods ***

- (NSDictionary *)objectValue;
- (void)setObjectValue:(NSDictionary *)shortcut;

@end

// Delegate Methods
@interface NSObject (SRRecorderDelegate)
- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder isKeyCode:(NSInteger)keyCode andFlagsTaken:(NSUInteger)flags reason:(NSString **)aReason;
- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo;
@end