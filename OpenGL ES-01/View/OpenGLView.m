//
//  OpenGLView.m
//  OpenGL ES-01
//
//  Created by 郝琦 on 2019/5/18.
//  Copyright © 2019 GoGoCoding. All rights reserved.
//

#import "OpenGLView.h"
#import "../GLESUtils.h"

@interface OpenGLView ()
{
    CADisplayLink * _displayLink;
    
    ksMatrix4 _shouldModelViewMatrix;
    ksMatrix4 _elbowModelViewMatrix;
    
    float _rotateColorCube;
    
}

@end

@implementation OpenGLView
- (void) updateShoulderTransform
{
    ksMatrixLoadIdentity(&_shouldModelViewMatrix);
    
    ksMatrixTranslate(&_shouldModelViewMatrix, -1.5, 0.0, -5.5);
    
    // Rotate the shoulder
    //
    ksMatrixRotate(&_shouldModelViewMatrix, self.rotateShoulder, 0.0, 0.0, 1.0);
    
    // Scale the cube to be a shoulder
    //
    ksMatrixCopy(&_modelViewMatrix, &_shouldModelViewMatrix);
    ksMatrixScale(&_modelViewMatrix, 1.5, 0.6, 0.6);
    
    // Load the model-view matrix
    glUniformMatrix4fv(_modelViewSlot, 1, GL_FALSE, (GLfloat*)&_modelViewMatrix.m[0][0]);
}

- (void) updateElbowTransform
{
    // Relative to shoulder
    //
    ksMatrixCopy(&_elbowModelViewMatrix, &_shouldModelViewMatrix);
    
    // Translate away from shoulder
    //
    ksMatrixTranslate(&_elbowModelViewMatrix, 1.5, 0.0, 0.0);
    
    // Rotate the elbow
    //
    ksMatrixRotate(&_elbowModelViewMatrix, self.rotateElbow, 0.0, 0.0, 1.0);
    
    // Scale the cube to be a elbow
    ksMatrixCopy(&_modelViewMatrix, &_elbowModelViewMatrix);
    ksMatrixScale(&_modelViewMatrix, 1.0, 0.4, 0.4);
    
    // Load the model-view matrix
    glUniformMatrix4fv(_modelViewSlot, 1, GL_FALSE, (GLfloat*)&_modelViewMatrix.m[0][0]);
}


- (void)drawCube:(ksVec4) color
{
    GLfloat vertices[] = {
        0.0f, -0.5f, 0.5f,
        0.0f, 0.5f, 0.5f,
        1.0f, 0.5f, 0.5f,
        1.0f, -0.5f, 0.5f,
        
        1.0f, -0.5f, -0.5f,
        1.0f, 0.5f, -0.5f,
        0.0f, 0.5f, -0.5f,
        0.0f, -0.5f, -0.5f,
    };
    
    GLubyte indices[] = {
        0, 1, 1, 2, 2, 3, 3, 0,
        4, 5, 5, 6, 6, 7, 7, 4,
        0, 7, 1, 6, 2, 5, 3, 4
    };
    
    glVertexAttrib4f(_colorSlot, color.x, color.y, color.z, color.w);
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices );
    glEnableVertexAttribArray(_positionSlot);
    
    glDrawElements(GL_LINES, sizeof(indices)/sizeof(GLubyte), GL_UNSIGNED_BYTE, indices);
}


//- (void)displayLinkCallback:(CADisplayLink*)displayLink{
//    self.rotateX += displayLink.duration * 90;
//}

- (void)toggleDisplayLink
{
    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCallback:)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    else {
        [_displayLink invalidate];
//        [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _displayLink = nil;
    }
}

- (void)displayLinkCallback:(CADisplayLink*)displayLink
{
    _rotateColorCube += displayLink.duration * 90;
    
    [self render];
}


- (void) updateColorCubeTransform
{
    ksMatrixLoadIdentity(&_modelViewMatrix);
    
    ksMatrixTranslate(&_modelViewMatrix, 0.0, -2, -5.5);
    
    ksMatrixRotate(&_modelViewMatrix, _rotateColorCube, 0.0, 1.0, 0.0);
    
    // Load the model-view matrix
    glUniformMatrix4fv(_modelViewSlot, 1, GL_FALSE, (GLfloat*)&_modelViewMatrix.m[0][0]);
}

- (void) drawColorCube
{
    GLfloat vertices[] = {
        -0.5f, -0.5f, 0.5f, 1.0, 0.0, 0.0, 1.0,     // red
        -0.5f, 0.5f, 0.5f, 1.0, 1.0, 0.0, 1.0,      // yellow
        0.5f, 0.5f, 0.5f, 0.0, 0.0, 1.0, 1.0,       // blue
        0.5f, -0.5f, 0.5f, 1.0, 1.0, 1.0, 1.0,      // white
        
        0.5f, -0.5f, -0.5f, 1.0, 1.0, 0.0, 1.0,     // yellow
        0.5f, 0.5f, -0.5f, 1.0, 0.0, 0.0, 1.0,      // red
        -0.5f, 0.5f, -0.5f, 1.0, 1.0, 1.0, 1.0,     // white
        -0.5f, -0.5f, -0.5f, 0.0, 0.0, 1.0, 1.0,    // blue
    };
    
    GLubyte indices[] = {
        // Front face
        0, 3, 2, 0, 2, 1,
        
        // Back face
        7, 5, 4, 7, 6, 5,
        
        // Left face
        0, 1, 6, 0, 6, 7,
        
        // Right face
        3, 4, 5, 3, 5, 2,
        
        // Up face
        1, 2, 5, 1, 5, 6,
        
        // Down face
        0, 7, 4, 0, 4, 3
    };
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 7 * sizeof(float), vertices);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, 7 * sizeof(float), vertices + 3);
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_colorSlot);
    glDrawElements(GL_TRIANGLES, sizeof(indices)/sizeof(GLubyte), GL_UNSIGNED_BYTE, indices);
    glDisableVertexAttribArray(_colorSlot);
}

- (void)layoutSubviews {
    
    [self setupLayer];
    [self setupContext];
    [self destoryRenderAndFrameBuffer];
    [self setupRenderBuffer];
    [self setupFrameBuffer];
    [self setupProgram];
    [self setupProjection];
    [self resetTransform];
    [self render];
    
}

+(Class)layerClass{
    // 只有 [CAEAGLLayer class] 类型的 layer 才支持在其上描绘 OpenGL 内容。
    return [CAEAGLLayer class];
}

- (void)setupLayer{
    _eaglLayer = (CAEAGLLayer*) self.layer;
    
    // CALayer 默认是透明的，必须将它设为不透明才能让其可见
    _eaglLayer.opaque = YES;
    _eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:NO],kEAGLDrawablePropertyRetainedBacking,
                                     kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat, nil];
    
}

- (void)drawTriCone{
    GLfloat vertices[] = {
        0.5f,   0.5f,   0.0f,
        0.5f,   -0.5f,  0.0f,
        -0.5f,  -0.5f,  0.0f,
        -0.5f,  0.5f,   0.0f,
        0.0f,   0.0f,   -0.707f,
    };
    
    GLubyte indices[] = {
        0,  1,  1,  2,  2,  3,  3,  0,
        4,  0,  4,  1,  4,  2,  4,  3
    };
    
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    //Draw lines
    glDrawElements(GL_LINES, sizeof(indices)/sizeof(GLubyte), GL_UNSIGNED_BYTE, indices);
}

- (void)render
{
    ksVec4 colorRed = {1, 0, 0, 1};
    ksVec4 colorWhite = {1, 1, 1, 1};
    
    glClearColor(0.0, 1.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Setup viewport
    //
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    // Draw color cube
    //
    [self updateColorCubeTransform];
    [self drawColorCube];
    
    // Draw shoulder
    //
    [self updateShoulderTransform];
    [self drawCube:colorRed];
    
    // Draw elbow
    //
    [self updateElbowTransform];
    [self drawCube:colorWhite];
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}


//- (void)render {
//    glClearColor(0, 1.0, 0, 1.0 );
//    glClear(GL_COLOR_BUFFER_BIT);
//
//    //Setup viewport
//    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
//
//#pragma -Draw triangle
////    GLfloat vertices[] = {
////        0.0f,   0.5f,   0.0f,
////        -0.5f,  -0.5f,  0.0f,
////        0.5f,   -0.5f,  0.0f
////    };
////
//////    //Load the vertex data
////    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
////    glEnableVertexAttribArray(_positionSlot);
////
////    //Draw triangle
////
////    glDrawArrays(GL_TRIANGLES, 0, 3);
//
//#pragma -Draw TriCone
//    [self drawTriCone];
//
//    [_context presentRenderbuffer:GL_RENDERBUFFER];
//}


- (void)setupContext {
    // 指定 OpenGL 渲染 API 的版本，在这里我们使用 OpenGL ES 2.0
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    // 设置为当前上下文
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
    }
}

- (void)setupRenderBuffer {
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    // 为 color renderbuffer 分配存储空间
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

- (void)setupFrameBuffer {
    glGenFramebuffers(1, &_frameBuffer);
    // 设置为当前 framebuffer
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    // 将 _colorRenderBuffer 装配到 GL_COLOR_ATTACHMENT0 这个装配点上color colour corlor
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
}

- (void)destoryRenderAndFrameBuffer{
    glDeleteFramebuffers(1, &_frameBuffer);
    _frameBuffer = 0;
    glDeleteRenderbuffers(1, &_colorRenderBuffer);
    _colorRenderBuffer = 0;
}

- (void)setupProgram{
    //Load shaders
    
    NSString* vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"VertexShader" ofType:@"glsl"];
    
    NSString* fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"FragmentShader" ofType:@"glsl"];
    
    GLuint vertexShader = [GLESUtils loadShader:GL_VERTEX_SHADER withFilePath: vertexShaderPath];
    GLuint fragmentShader = [GLESUtils loadShader:GL_FRAGMENT_SHADER withFilePath:fragmentShaderPath];
    
    //Create program, arrach shaders
    _programHandle = glCreateProgram();
    if (!_programHandle) {
        NSLog(@"Failed to create program");
        return;
    }
    
    glAttachShader(_programHandle, vertexShader);
    glAttachShader(_programHandle, fragmentShader);
    
    //Link program
    glLinkProgram(_programHandle);
    
    //Check the link status
    GLint linked;
    glGetProgramiv(_programHandle, GL_LINK_STATUS, &linked);
    
    if (!linked) {
        GLint infoLen = 0;
        glGetProgramiv(_programHandle, GL_INFO_LOG_LENGTH, &infoLen);
        
        if (infoLen > 1) {
            char* infoLog = malloc(sizeof(char) * infoLen);
            glGetProgramInfoLog(_programHandle, infoLen, NULL, infoLog);
            NSLog(@"Error linking program: \n%s\n", infoLog);
            
            free(infoLog);
        }
        
        glDeleteProgram(_programHandle);
        _programHandle = 0;
        return;
    }
    
    glUseProgram(_programHandle);
    
    //Get attribute slot from program
    
    _positionSlot = glGetAttribLocation(_programHandle, "vPosition");
    
    _modelViewSlot = glGetUniformLocation(_programHandle, "modelView");
    
    _projectionSlot = glGetUniformLocation(_programHandle, "projection");
    
    _colorSlot = glGetAttribLocation(_programHandle, "vSourceColor");
}

- (void)setupProjection{
    // Generate a perspective matrix with a 60 degree FOV
    float aspect = self.frame.size.width / self.frame.size.height;
    
    ksMatrixLoadIdentity(&_projectionMatrix);
    ksPerspective(&_projectionMatrix, 60.0, aspect, 1.0f, 20.0f);
    
    //Load projection matrix
    glUniformMatrix4fv(_projectionSlot, 1, GL_FALSE, (GLfloat *)&_projectionMatrix.m[0][0]);
    
    glEnable(GL_CULL_FACE);
}

- (void)updateTransform{
    // Generate a model view matrix to rotate/translate/scale
    ksMatrixLoadIdentity(&_modelViewMatrix);
    
    // Translate away from the viewer
    ksMatrixTranslate(&_modelViewMatrix, self.posX, self.posY, self.posZ);
    
    //Rotate the triangle
    ksMatrixRotate(&_modelViewMatrix, self.rotateX, 1.0, 0.0, 0.0);
    
    //Scale the triangle
    ksMatrixScale(&_modelViewMatrix, 1.0, 1.0, self.scaleZ);
    
    glUniformMatrix4fv(_modelViewSlot, 1, GL_FALSE, (GLfloat*)&_modelViewMatrix.m[0][0]);
    
}

- (void)resetTransform
{
    _posX = 0.0;
    _posY = 0.0;
    _posZ = -5.5;
    
    _scaleZ = 1.0;
    _rotateX = 0.0;
    
    [self updateTransform];
}

- (void)setPosX:(float)x
{
    _posX = x;
    
    [self updateTransform];
    [self render];
}

- (void)setPosY:(float)y
{
    _posY = y;
    
    [self updateTransform];
    [self render];
}

- (void)setPosZ:(float)z
{
    _posZ = z;
    
    [self updateTransform];
    [self render];
}

-(void)setScaleZ:(float)scaleZ{
    _scaleZ = scaleZ;
    [self updateTransform];
    [self render];
}

-(void)setRotateX:(float)rotateX{
    _rotateX  = rotateX;
    [self updateTransform];
    [self render];
}

- (void)setRotateShoulder:(float)rotateShoulder{
    _rotateShoulder = rotateShoulder;
    [self updateShoulderTransform];
    [self render];
}


-(void)setRotateElbow:(float)rotateElbow{
    _rotateElbow = rotateElbow;
    [self updateElbowTransform];
    [self render];
}

@end
