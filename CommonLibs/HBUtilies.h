//
//  HBUtilies.h
//  HBLib
//
//  Created by Limin on 12-9-23.
//  Copyright (c) 2012年 HappyBluefin. All rights reserved.
//

#ifndef _HBUtilies_H_
#define _HBUtilies_H_

#include "cocos2d.h"
using namespace cocos2d;

// 按屏幕比例缩放
void HBSetRatioScale(CCSprite* sprite);
// 按屏幕比例计算
CCPoint ccpRatio(float x, float y);
// 单纯x2计算
CCPoint ccpRatio2(float x, float y);
// 按比例计算
CCRect HBRectRatio(float x, float y, float w, float h);
// 单纯x2计算
CCRect ccRectRatio2(float x, float y, float w, float h);
int ccFontRatio(int size);

#define fcs(format,...) CCString::createWithFormat(format,## __VA_ARGS__)->getCString()

const CCPoint gPointCenter = ccp(240, 160);
const CCPoint gAnchorCenter = ccp(0.5, 0.5);
const CCPoint gAnchorLeft = ccp(0, 0.5);
const CCPoint gAnchorRight = ccp(1, 0.5);
const CCPoint gAnchorTop = ccp(0.5, 0);
const CCPoint gAnchorBottom = ccp(0.5, 1);

CCSprite* createImage(const char* file, float x, float y, CCNode* parent);
CCSprite* createImageWithFrameName(const char* name, float x, float y, CCNode* parent);
CCMenu* createMenu(CCNode* parent);
CCSprite* createAnimation(const char* imagePrefix, int frameCount, float x, float y, float duration, CCNode* parent);
CCMenuItem* createMenuItemWithCache(const char* nmlImage, const char* downImage, float x, float y, int tag, CCMenu* parent, CCObject* target, SEL_MenuHandler selector);
CCMenuItem* createMenuItem(const char* nmlImage, const char* downImage, float x, float y, int tag, CCMenu* parent, CCObject* target, SEL_MenuHandler selector);
CCMenuItem* createMenuItem(const char* image, float x, float y, int tag, CCMenu* parent, CCObject* target, SEL_MenuHandler selector);
CCLabelTTF* addMenuLabel(CCMenuItem* item, const char* text, const char* fontName, int fontSize, ccColor3B fontColor);
CCLabelTTF* addMenuLabelWithStroke(CCMenuItem* item, const char* text, const char* fontName, int fontSize, ccColor3B fontColor, float strokeSize, ccColor3B strokeColor);
CCLabelTTF* createLabel(const char* label, const char* fontName, int fontSize, const CCPoint& anchor, const ccColor3B& color, float x, float y, CCNode* parent);
CCLabelTTF* createLabelWithStroke(const char* label, const char* fontName, int fontSize, const CCPoint& anchor, const ccColor3B& color, float x, float y, CCNode* parent, float strokeSize, ccColor3B strokeColor);
CCLabelAtlas* createLabelAtlas(const char* label, const char* fontName, int width, int height, char startChar, float x, float y, const CCPoint& anchor, CCNode* parent);

CCRenderTexture* createStroke(CCLabelTTF* label, float size, ccColor3B color);

const char* getLocalizedString(const char* str);

class HBUtilies
{
public:
    static void gotoReview();
};


#endif
