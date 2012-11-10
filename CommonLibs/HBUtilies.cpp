//
//  HBUtilies.cpp
//  HBLib
//
//  Created by Limin on 12-9-23.
//  Copyright (c) 2012年 HappyBluefin. All rights reserved.
//

#include "HBUtilies.h"
#include "HBUmeng.h"

CCSprite* createImage(const char* file, float x, float y, CCNode* parent)
{
	CCSprite* image = CCSprite::create(file);
	image->setPosition(ccpRatio(x,y));
	parent->addChild(image);
	return image;
}

CCSprite* createImageWithFrameName(const char* name, float x, float y, CCNode* parent)
{
    CCSprite* sprite = CCSprite::createWithSpriteFrameName(name);
    sprite->setPosition(ccpRatio(x,y));
    parent->addChild(sprite);
    return sprite;
}

CCMenu* createMenu(CCNode* parent)
{
	CCMenu* menu = CCMenu::create(NULL);
	menu->setPosition(CCPointZero);
	parent->addChild(menu);
	return menu;
}

CCSprite* createAnimation(const char* imagePrefix, int frameCount, float x, float y, float duration, CCNode* parent)
{
    CCSprite* sprite = CCSprite::createWithSpriteFrameName(fcs("%s%d.png", imagePrefix, 1));
    sprite->setPosition(ccpRatio(x,y));
    parent->addChild(sprite);
    
    CCSpriteFrameCache* cache = CCSpriteFrameCache::sharedSpriteFrameCache();
    
    CCAnimation* animation = CCAnimation::create();
    for (int i = 0; i < frameCount; i++)
        animation->addSpriteFrame(cache->spriteFrameByName(fcs("%s%d.png", imagePrefix, i+1)));
    animation->setDelayPerUnit(duration);
    animation->setRestoreOriginalFrame(false);
    CCAnimate* action = CCAnimate::create(animation);
    sprite->runAction(CCRepeatForever::create(action));
    
    return sprite;
}

CCMenuItem* createMenuItemWithCache(const char* nmlImage, const char* downImage, float x, float y, int tag, CCMenu* parent, CCObject* target, SEL_MenuHandler selector)
{
    CCSprite* nml = CCSprite::createWithSpriteFrameName(nmlImage);
    CCSprite* down = CCSprite::createWithSpriteFrameName(downImage);
	CCMenuItemSprite* item = CCMenuItemSprite::create(nml, down, target, selector);
	item->setPosition(ccpRatio(x,y));
    item->setTag(tag);
	if (parent)
		parent->addChild(item);
	return item;
}

CCMenuItem* createMenuItem(const char* nmlImage, const char* downImage, float x, float y, int tag, CCMenu* parent, CCObject* target, SEL_MenuHandler selector)
{
	CCMenuItemImage* item = CCMenuItemImage::create(nmlImage, downImage, target, selector);
	item->setPosition(ccpRatio(x,y));
    item->setTag(tag);
	if (parent)
		parent->addChild(item);
	return item;
}

CCMenuItem* createMenuItem(const char* image, float x, float y, int tag, CCMenu* parent, CCObject* target, SEL_MenuHandler selector)
{
	CCSprite* nml = CCSprite::create(image);
	CCSprite* down = CCSprite::create(image);
	down->setColor(ccGRAY);
	CCMenuItemSprite* item = CCMenuItemSprite::create(nml, down, target, selector);
	item->setPosition(ccpRatio(x,y));
	if (parent)
		parent->addChild(item, tag);
	return item;
}

CCLabelTTF* addMenuLabel(CCMenuItem* item, const char* text, const char* fontName, int fontSize, ccColor3B fontColor)
{
	CCLabelTTF* label = CCLabelTTF::create(text, fontName, ccFontRatio(fontSize));
	label->setColor(fontColor);
	label->setPosition(ccp(item->getContentSize().width / 2, item->getContentSize().height / 2 - 1));
	item->addChild(label);
	return label;
}

CCLabelTTF* addMenuLabelWithStroke(CCMenuItem* item, const char* text, const char* fontName, int fontSize, ccColor3B fontColor, float strokeSize, ccColor3B strokeColor)
{
    CCLabelTTF* label = CCLabelTTF::create(text, fontName, ccFontRatio(fontSize));
    label->setColor(fontColor);
    label->setPosition(ccp(item->getContentSize().width / 2, item->getContentSize().height / 2 - 1));
    createStroke(label, strokeSize, strokeColor);
    item->addChild(label);
    return label;
}

CCLabelTTF* createLabelWithStroke(const char* label, const char* fontName, int fontSize, const CCPoint& anchor, const ccColor3B& color, float x, float y, CCNode* parent, float strokeSize, ccColor3B strokeColor)
{
	CCLabelTTF* labelTTF = CCLabelTTF::create(label, fontName, ccFontRatio(fontSize));
	labelTTF->setAnchorPoint(anchor);
	labelTTF->setColor(color);
	labelTTF->setPosition(ccpRatio(x,y));
    createStroke(labelTTF, strokeSize, strokeColor);
	parent->addChild(labelTTF);
	return labelTTF;
}

CCLabelTTF* createLabel(const char* label, const char* fontName, int fontSize, const CCPoint& anchor, const ccColor3B& color, float x, float y, CCNode* parent)
{
	CCLabelTTF* labelTTF = CCLabelTTF::create(label, fontName, ccFontRatio(fontSize));
	labelTTF->setAnchorPoint(anchor);
	labelTTF->setColor(color);
	labelTTF->setPosition(ccpRatio(x,y));
	parent->addChild(labelTTF);
	return labelTTF;
}

CCLabelAtlas* createLabelAtlas(const char* label, const char* fontName, int width, int height, char startChar, float x, float y, const CCPoint& anchor, CCNode* parent)
{
    CCLabelAtlas* labelAtlas = CCLabelAtlas::create(label, fontName, ccFontRatio(width), ccFontRatio(height), startChar);
    labelAtlas->setPosition(ccpRatio(x,y));
    labelAtlas->setAnchorPoint(anchor);
    parent->addChild(labelAtlas);
    return labelAtlas;
}

CCRenderTexture* createStroke(CCLabelTTF* label, float size, ccColor3B color)
{
    if (HBUmeng::getParamValue("isStrokeEnable") != 1)
        return NULL;
    
    size = ccFontRatio(size);
    CCSize labelSize = label->getTexture()->getContentSize();
    int w = labelSize.width + size * 2;
    int h = labelSize.height + size * 2;
	
    CCRenderTexture* rt = CCRenderTexture::create(w,h);
	CCPoint originalPos = label->getPosition();
	ccColor3B originalColor = label->getColor();
    bool originalVisibility = label->isVisible();
	label->setColor(color);
    label->setVisible(true);
	ccBlendFunc originalBlend = label->getBlendFunc();
	label->setBlendFunc((ccBlendFunc) { GL_SRC_ALPHA, GL_ONE });
    
	CCPoint center = ccp(labelSize.width * 0.5 + size,labelSize.height * 0.5 + size);
    
	rt->begin();
	for (int i = 0; i < 360; i += 10)
	{
		label->setPosition(ccp(center.x + sin(CC_DEGREES_TO_RADIANS(i)) * size,
                               center.y + cos(CC_DEGREES_TO_RADIANS(i)) * size));
		label->visit();
	}
	rt->end();
    
	label->setPosition(originalPos);
	label->setColor(originalColor);
	label->setBlendFunc(originalBlend);
    label->setVisible(originalVisibility);
    
    CCPoint strokePosition = ccp(labelSize.width/2,labelSize.height/2);
    rt->setPosition(strokePosition);
    label->addChild(rt,-1);
    
    return rt;
}

