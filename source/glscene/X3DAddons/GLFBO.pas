unit GLFBO;

interface

uses
  Classes, Dialogs, VectorTypes, VectorGeometry,
  GLScene, GLTexture, OpenGL1x, GLUtils;

const
  // OpenGL 1.4 required 
  GL_CLAMP_TO_BORDER = $812D;
  GL_TEXTURE_COMPARE_MODE = $884C;
  GL_TEXTURE_COMPARE_FUNC = $884D;
  GL_COMPARE_R_TO_TEXTURE = $884E;
  GL_DEPTH_TEXTURE_MODE = $884B;

  // GL_ARB_texture_float required
  GL_RGBA32F = $8814;
  GL_RGBA16F = $881A;

type

  TGLFBO = class(TPersistent)
    private
        { Private Declarations }
    protected
        { Protected Declarations }
        FInitialized: Boolean;
        FFramebuffer: GLuint;
        FStencilRenderbuffer: GLuint;
        FDepthTextureHandle: GLuint;
        FColorTextureHandle: GLuint;
        
        FTexture: TGLTexture;
        FMainBuffer: TGLSceneBuffer;
        FWidth: Integer;
        FHeight: Integer;
        FCamera: TGLCamera;
        FRenderObject: TGLBaseSceneObject;
        FProjectionSize: Single;

        FOverrideMaterial: TGLLibMaterial;

        // TODO: remove this
        FUseFloatBuffer: Boolean;

        FColorBufferFormat: TGLTextureFormat;
        
        FInternalColorFormat: GLint;
        FColorFormat: GLenum;
        FColorType: GLenum;

        procedure DoInitialize;
        procedure SetTexture(texture: TGLTexture);
    public
        { Public Declarations }
        constructor Create;
        destructor Destroy; override;
        procedure Render(clear: Boolean);
        procedure RenderEx(clearcolor, cleardepth, copycolor, copydepth: Boolean);
        property Texture: TGLTexture read FTexture write SetTexture;
        property MainBuffer: TGLSceneBuffer read FMainBuffer write FMainBuffer;
        property Width: Integer read FWidth write FWidth;
        property Height: Integer read FHeight write FHeight;
        property DepthTextureHandle: GLuint read FDepthTextureHandle write FDepthTextureHandle;
        property ColorTextureHandle: GLuint read FColorTextureHandle write FColorTextureHandle;
        property Camera: TGLCamera read FCamera write FCamera;
        property RenderObject: TGLBaseSceneObject read FRenderObject write FRenderObject;
        property OverrideMaterial: TGLLibMaterial read FOverrideMaterial write FOverrideMaterial;
        property Framebuffer: GLuint read FFramebuffer;
        property UseFloatBuffer: Boolean read FUseFloatBuffer write FUseFloatBuffer;
        procedure DoRender(clear: Boolean);
        procedure DoRender2(clear: Boolean);
        procedure DoRenderEx(clearcolor, cleardepth, copycolor, copydepth: Boolean);
        procedure SetColorBufferFormat(format: TGLTextureFormat);
        procedure Deinitialize;
        procedure Initialize;
  end;

implementation

procedure TGLFBO.SetTexture(texture: TGLTexture);
begin
  FTexture := texture;
end;

procedure TGLFBO.DoInitialize;
begin
  FInitialized := True;

  glGenTextures(1, @FDepthTextureHandle);
  glBindTexture(GL_TEXTURE_2D, FDepthTextureHandle);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
  glTexParameteri(GL_TEXTURE_2D, GL_DEPTH_TEXTURE_MODE, GL_LUMINANCE);
  glTexImage2D(GL_TEXTURE_2D, 0,
      GL_DEPTH24_STENCIL8, Width, Height, 0,
      GL_DEPTH_STENCIL, GL_UNSIGNED_INT_24_8, nil);
  glBindTexture(GL_TEXTURE_2D, 0);

  glGenTextures(1, @FColorTextureHandle);
  glBindTexture(GL_TEXTURE_2D, FColorTextureHandle);
  //if FUseFloatBuffer then
  //  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA32F, Width, Height, 0, GL_RGBA, GL_FLOAT, nil)
  //else
    glTexImage2D(GL_TEXTURE_2D, 0, FInternalColorFormat, Width, Height, 0, FColorFormat, FColorType, nil);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
  glBindTexture(GL_TEXTURE_2D, 0);

  glGenFramebuffers(1, @FFramebuffer);
  glBindFramebuffer(GL_FRAMEBUFFER, FFramebuffer);
  glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, FColorTextureHandle, 0);
  glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_STENCIL_ATTACHMENT, GL_TEXTURE_2D, FDepthTextureHandle, 0);

  glBindFramebuffer(GL_FRAMEBUFFER, 0);
    
end;

procedure TGLFBO.Deinitialize;
begin
  if FInitialized then
  begin
    FInitialized := False;
    if (glIsTexture(FDepthTextureHandle)) then
      glDeleteTextures(1, @FDepthTextureHandle);
    if (glIsTexture(FColorTextureHandle)) then
      glDeleteTextures(1, @FColorTextureHandle);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glDeleteFramebuffers(1, @FFramebuffer);
  end;
end;

constructor TGLFBO.Create;
begin
  inherited Create;
  Width := 256;
  Height := 256;
  FInitialized := false;
  FProjectionSize := 20.0;
  FUseFloatBuffer := false;

  FColorBufferFormat := tfDefault;
  
  FInternalColorFormat := GL_RGBA8;
  FColorFormat := GL_RGBA;
  FColorType := GL_UNSIGNED_BYTE;
end;

destructor TGLFBO.Destroy;
begin
  Deinitialize();
  inherited Destroy;
end;

procedure TGLFBO.SetColorBufferFormat(format: TGLTextureFormat);
begin
  if format = tfDefault then
  begin
    FColorBufferFormat := format;
    FInternalColorFormat := GL_RGBA8;
    FColorFormat := GL_RGBA;
    FColorType := GL_UNSIGNED_BYTE;
  end
  else if format = tfRGB then
  begin
    FColorBufferFormat := format;
    FInternalColorFormat := GL_RGB8;
    FColorFormat := GL_RGB;
    FColorType := GL_UNSIGNED_BYTE;
  end
  else if format = tfRGBA then
  begin
    FColorBufferFormat := format;
    FInternalColorFormat := GL_RGBA8;
    FColorFormat := GL_RGBA;
    FColorType := GL_UNSIGNED_BYTE;
  end
  else if format = tfRGB16 then
  begin
    FColorBufferFormat := format;
    FInternalColorFormat := GL_RGB5;
    FColorFormat := GL_RGB;
    FColorType := GL_UNSIGNED_BYTE;
  end
  else if format = tfRGBA16 then
  begin
    FColorBufferFormat := format;
    FInternalColorFormat := GL_RGBA4;
    FColorFormat := GL_RGBA;
    FColorType := GL_UNSIGNED_BYTE;
  end
  else if format = tfAlpha then
  begin
    FColorBufferFormat := format;
    FInternalColorFormat := GL_ALPHA8;
    FColorFormat := GL_ALPHA;
    FColorType := GL_UNSIGNED_BYTE;
  end
  else if format = tfLuminance then
  begin
    FColorBufferFormat := format;
    FInternalColorFormat := GL_LUMINANCE8;
    FColorFormat := GL_LUMINANCE;
    FColorType := GL_UNSIGNED_BYTE;
  end
  else if format = tfLuminanceAlpha then
  begin
    FColorBufferFormat := format;
    FInternalColorFormat := GL_LUMINANCE8_ALPHA8;
    FColorFormat := GL_LUMINANCE_ALPHA;
    FColorType := GL_UNSIGNED_BYTE;
  end
  else if format = tfIntensity then
  begin
    FColorBufferFormat := format;
    FInternalColorFormat := GL_INTENSITY8;
    FColorFormat := GL_LUMINANCE;
    FColorType := GL_UNSIGNED_BYTE;
  end
  // tfNormalMap is not supported
  else if format = tfRGBAFloat16 then
  begin
    FColorBufferFormat := format;
    FInternalColorFormat := GL_RGBA16F;
    FColorFormat := GL_RGBA;
    FColorType := GL_FLOAT;
  end
  else if format = tfRGBAFloat32 then
  begin
    FColorBufferFormat := format;
    FInternalColorFormat := GL_RGBA32F;
    FColorFormat := GL_RGBA;
    FColorType := GL_FLOAT;
  end
  else
  begin
    FColorBufferFormat := format;
    FInternalColorFormat := GL_RGBA8;
    FColorFormat := GL_RGBA;
    FColorType := GL_UNSIGNED_BYTE;
  end;

  Deinitialize();
end;

procedure TGLFBO.Initialize;
begin
   if not FInitialized then
     DoInitialize;
end;

procedure TGLFBO.DoRender(clear: Boolean);
var
   oldWidth, oldHeight: Integer;
   oldCamera: TGLCamera;
   oldOverrideMat: TGLLibMaterial;
begin
   if not Assigned(FCamera) then
     Exit;

   oldWidth := MainBuffer.Width;
   oldHeight := MainBuffer.Height;
   oldCamera := MainBuffer.Camera;
   MainBuffer.Resize(FWidth, FHeight);
   MainBuffer.SetViewPort(0, 0, oldWidth, oldHeight);
   MainBuffer.Camera := FCamera;

   if not FInitialized then
     DoInitialize;
   
   glBindFramebuffer(GL_FRAMEBUFFER, FFramebuffer);
   oldOverrideMat := MainBuffer.OverrideMaterial;
   if FOverrideMaterial <> nil then
   begin
     MainBuffer.OverrideMaterial := FOverrideMaterial;
   end;
   MainBuffer.SimpleRender2(FRenderObject, False, False, clear, clear, clear, False);
   MainBuffer.OverrideMaterial := oldOverrideMat;
   glBindFramebuffer(GL_FRAMEBUFFER, 0);

   MainBuffer.Resize(oldWidth, oldHeight);
   MainBuffer.Camera := oldCamera;
end;

procedure TGLFBO.DoRenderEx(clearcolor, cleardepth, copycolor, copydepth: Boolean);
var
   oldWidth, oldHeight: Integer;
   oldCamera: TGLCamera;
   oldOverrideMat: TGLLibMaterial;
begin
   if not Assigned(FCamera) then
     Exit;

   oldWidth := MainBuffer.Width;
   oldHeight := MainBuffer.Height;
   oldCamera := MainBuffer.Camera;
   MainBuffer.Resize(FWidth, FHeight);
   MainBuffer.SetViewPort(0, 0, oldWidth, oldHeight);
   MainBuffer.Camera := FCamera;

   if not FInitialized then
     DoInitialize;
   
   glBindFramebuffer(GL_FRAMEBUFFER, FFramebuffer);
   oldOverrideMat := MainBuffer.OverrideMaterial;
   if FOverrideMaterial <> nil then
   begin
     MainBuffer.OverrideMaterial := FOverrideMaterial;
   end;
   MainBuffer.SimpleRender2(FRenderObject, False, False, clearcolor, cleardepth, True, False);

   MainBuffer.OverrideMaterial := oldOverrideMat;
   glBindFramebuffer(GL_FRAMEBUFFER, 0);

   glBindFramebuffer(GL_READ_FRAMEBUFFER, FFramebuffer);
   if copycolor then begin
     if copydepth then
       glBlitFramebuffer(0, 0, width, height, 0, 0, width, height, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT, GL_NEAREST)
     else
       glBlitFramebuffer(0, 0, width, height, 0, 0, width, height, GL_COLOR_BUFFER_BIT, GL_NEAREST);
   end
   else if copydepth then
     glBlitFramebuffer(0, 0, width, height, 0, 0, width, height, GL_DEPTH_BUFFER_BIT, GL_NEAREST);
   glBindFramebuffer(GL_READ_FRAMEBUFFER, 0);

   MainBuffer.Resize(oldWidth, oldHeight);
   MainBuffer.Camera := oldCamera;
end;

procedure TGLFBO.DoRender2(clear: Boolean);
var
   oldWidth, oldHeight: Integer;
   oldCamera: TGLCamera;
   oldOverrideMat: TGLLibMaterial;
begin
   if not Assigned(FCamera) then
     Exit;

   oldWidth := MainBuffer.Width;
   oldHeight := MainBuffer.Height;
   oldCamera := MainBuffer.Camera;
   MainBuffer.Resize(FWidth, FHeight);
   MainBuffer.SetViewPort(0, 0, oldWidth, oldHeight);
   MainBuffer.Camera := FCamera;

   if not FInitialized then
     DoInitialize;
   
   glBindFramebuffer(GL_FRAMEBUFFER, FFramebuffer);
   oldOverrideMat := MainBuffer.OverrideMaterial;
   if FOverrideMaterial <> nil then
   begin
     MainBuffer.OverrideMaterial := FOverrideMaterial;
   end;
   //MainBuffer.SimpleRender3(FRenderObject);
   MainBuffer.SimpleRender2(FRenderObject, False, False, clear, clear, clear, False);
   MainBuffer.OverrideMaterial := oldOverrideMat;
   glBindFramebuffer(GL_FRAMEBUFFER, 0);

   MainBuffer.Resize(oldWidth, oldHeight);
   MainBuffer.Camera := oldCamera;
end;

procedure TGLFBO.Render(clear: Boolean);
begin
   MainBuffer.RenderingContext.Activate;
   DoRender(clear);
   MainBuffer.RenderingContext.Deactivate;
end;

procedure TGLFBO.RenderEx(clearcolor, cleardepth, copycolor, copydepth: Boolean);
begin
   MainBuffer.RenderingContext.Activate;
   DoRenderEx(clearcolor, cleardepth, copycolor, copydepth);
   MainBuffer.RenderingContext.Deactivate;
end;

end.
