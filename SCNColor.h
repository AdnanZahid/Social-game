//
//  SCNColor.h
//  Social game
//
//  Created by Adnan Zahid on 7/10/15.
//  Copyright © 2015 Adnan Zahid. All rights reserved.
//

#if TARGET_OS_IPHONE
    #define SCNColor UIColor
#else
    #define SCNColor NSColor
#endif