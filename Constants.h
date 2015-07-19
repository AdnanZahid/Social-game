//
//  Constants.h
//  Social game
//
//  Created by Adnan Zahid on 7/11/15.
//  Copyright © 2015 Adnan Zahid. All rights reserved.
//

typedef NS_ENUM(uint32_t, KeyType) {
    
    FORWARD_KEY = 0x7E,
    BACK_KEY    = 0x7D,
    LEFT_KEY    = 0x7B,
    RIGHT_KEY   = 0x7C,
    
    SPACE_KEY   = 0x31,
    
    W_KEY    = 0x0D,
    S_KEY    = 0x01,
    A_KEY    = 0x00,
    D_KEY    = 0x02
};

typedef NS_ENUM(uint32_t, CategoryType) {
    
    HEROCATEGORY = 0x1 << 1,
    PLAYERCATEGORY = 0x1 << 2,
    BULLETCATEGORY = 0x1 << 3
};