/*****************************************************************************
** $Source: /cygdrive/d/Private/_SVNROOT/bluemsx/blueMSX/Src/Memory/DeviceManager.h,v $
**
** $Revision: 1.5 $
**
** $Date: 2008-03-30 18:38:42 $
**
** More info: http://www.bluemsx.com
**
** Copyright (C) 2003-2006 Daniel Vik
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
#ifndef DEVICE_MANAGER_H
#define DEVICE_MANAGER_H

#include "MsxTypes.h"

typedef struct {
    void  (*destroy)(void*);
    void  (*reset)(void*);
    void  (*saveState)(void*);
    void  (*loadState)(void*);
} DeviceCallbacks;

void deviceManagerCreate(void);
void deviceManagerDestroy(void);

void deviceManagerReset(void);

void deviceManagerLoadState(void);
void deviceManagerSaveState(void);

int deviceManagerRegister(int type, DeviceCallbacks* callbacks, void* ref);
void deviceManagerUnregister(int handle);

#endif
