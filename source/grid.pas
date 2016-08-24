// Grid functions by Ghost

function GridCreate(x,y,z,step,parent: real): real; stdcall;
var
  GLXyzGrid1: TGLXYZGrid;
begin
  if not (parent = 0) then
    GLXyzGrid1 := TGLXYZGrid.CreateAsChild(TGLBaseSceneObject(trunc64(parent)))
  else
    GLXyzGrid1 := TGLXYZGrid.CreateAsChild(scene.Objects);

  GLXyzGrid1.XSamplingScale.Min:= -x;
  GLXyzGrid1.XSamplingScale.max:=  x;
  GLXyzGrid1.XSamplingScale.step:= step;
  GLXyzGrid1.YSamplingScale.Min:=  -y;
  GLXyzGrid1.YSamplingScale.max:=   y;
  GLXyzGrid1.YSamplingScale.step:= step;
  GLXyzGrid1.ZSamplingScale.Min:= -z;
  GLXyzGrid1.ZSamplingScale.max:=  z;
  GLXyzGrid1.ZSamplingScale.step:= step;
  result:=Integer(GLXyzGrid1);
end;

function GridSetLineStyle(grid,mode: real): real; stdcall;
var
  GLXyzGrid1: TGLXYZGrid;
begin
  GLXyzGrid1:=TGLXYZGrid(trunc64(grid));
  if mode=0 then GLXyzGrid1.LinesStyle:= TXYZGridLinesStyle(glsSegments);
  if mode=1 then GLXyzGrid1.LinesStyle:= TXYZGridLinesStyle(glsLine);
  result:=1;
end;

function GridSetLineSmoothing(grid,mode: real): real; stdcall;
var
  GLXyzGrid1: TGLXYZGrid;
begin
  GLXyzGrid1:=TGLXYZGrid(trunc64(grid));
  if mode=0 then GLXyzGrid1.LinesSmoothing:=false;
  if mode=1 then GLXyzGrid1.LinesSmoothing:=true;
  result:=1;
end;

function GridSetParts(grid, mode: real): real; stdcall;
var
  GLXyzGrid1: TGLXYZGrid;
  pts: TXYZGridParts;
begin
  if (mode=0) then pts:=[gpX,gpY];
  if (mode=1) then pts:=[gpY,gpZ];
  if (mode=2) then pts:=[gpX,gpZ];
  if (mode=3) then pts:=[gpX,gpY,gpZ];
  GLXyzGrid1:=TGLXYZGrid(trunc64(grid));
  GLXyzGrid1.Parts:=pts;
  result:=1;
end;

function GridSetColor(grid, color, alpha: real): real; stdcall;
var
  GLXyzGrid1: TGLXYZGrid;
  GLColor: TGLColor;
begin
  GLXyzGrid1:=TGLXYZGrid(trunc64(grid));
  GLXyzGrid1.LineColor.AsWinColor:=TColor(trunc64(color));
  GLXyzGrid1.LineColor.Alpha:=alpha;
  result:=1;
end;

function GridSetSize(grid, size: real): real; stdcall;
var
  GLXyzGrid1: TGLXYZGrid;
begin
    GLXyzGrid1:=TGLXYZGrid(trunc64(grid));
    GLXyzGrid1.LineWidth:=size;
    result:=1;
end;

function GridSetPattern(grid, pattern: real): real; stdcall;
var
  GLXyzGrid1: TGLXYZGrid;
begin
  GLXyzGrid1:=TGLXYZGrid(trunc64(grid));
  GLXyzGrid1.LinePattern:=trunc64(pattern);
  result:=1;
end;
