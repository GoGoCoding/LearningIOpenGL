//
//  OpenGLView.h
//  OpenGL ES-01
//
//  Created by 郝琦 on 2019/5/18.
//  Copyright © 2019 GoGoCoding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "ksMatrix.h"

NS_ASSUME_NONNULL_BEGIN

@interface OpenGLView : UIView {
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    GLuint _colorRenderBuffer;
    GLuint _frameBuffer;
    
    GLuint _programHandle;
    GLuint _positionSlot;
    
    GLint _modelViewSlot;
    GLint _projectionSlot;
    
    GLuint _colorSlot;
    
    ksMatrix4 _modelViewMatrix;
    ksMatrix4 _projectionMatrix;
    
}

@property (nonatomic, assign) float posX;
@property (nonatomic, assign) float posY;
@property (nonatomic, assign) float posZ;

@property (nonatomic, assign) float scaleZ;
@property (nonatomic, assign) float rotateX;

- (void)render;
- (void)resetTransform;
- (void)toggleDisplayLink;

@property (nonatomic, assign) float rotateShoulder;
@property (nonatomic, assign) float rotateElbow;

@end

NS_ASSUME_NONNULL_END
