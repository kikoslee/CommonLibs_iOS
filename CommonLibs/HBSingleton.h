//
//  HBSingleton.h
//  HBLib
//
//  Created by Limin on 12-9-13.
//  Copyright (c) 2012年 HappyBluefin. All rights reserved.
//

#ifndef _HBSingleton_H_
#define _HBSingleton_H_

template <typename T> class HBSingleton
{
public:
	static T* shared()
	{
        static T* ms_Singleton = new T;
        return ms_Singleton;
    }
};

#endif
