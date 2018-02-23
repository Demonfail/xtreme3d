/*
Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
*/

module derelict.xtreme3d.functions;

private {
    import derelict.util.system;
}

extern(Windows) @nogc nothrow
{
    alias _x3d_func0_D = double function();
    alias _x3d_funcD_D = double function(double);
    alias _x3d_funcDD_D = double function(double, double);
    alias _x3d_funcDDD_D = double function(double, double, double);
    alias _x3d_funcDDDD_D = double function(double, double, double, double);
    alias _x3d_funcDDDDD_D = double function(double, double, double, double, double);
    alias _x3d_funcDDDDDD_D = double function(double, double, double, double, double, double);
    alias _x3d_funcDDDDDDD_D = double function(double, double, double, double, double, double, double);
    alias _x3d_funcDDDDDDDD_D = double function(double, double, double, double, double, double, double, double);
    alias _x3d_funcDDDDDDDDD_D = double function(double, double, double, double, double, double, double, double, double);
    alias _x3d_funcDDDDDDDDDD_D = double function(double, double, double, double, double, double, double, double, double, double);
    
    alias _x3d_funcP_D = double function(char*);
    alias _x3d_funcPP_D = double function(char*, char*);
    alias _x3d_funcDP_D = double function(double, char*);
    alias _x3d_funcPD_D = double function(char*, double);
    alias _x3d_funcDD_P = char* function(double, double);
    alias _x3d_funcPDD_D = double function(char*, double, double);
    alias _x3d_funcPPD_D = double function(char*, char*, double);
    alias _x3d_funcDPD_D = double function(double, char*, double);
    alias _x3d_funcDPP_D = double function(double, char*, char*);
    alias _x3d_funcDDP_D = double function(double, double, char*);
    alias _x3d_funcPDDD_D = double function(char*, double, double, double);
    alias _x3d_funcDDPD_D = double function(double, double, char*, double);
    alias _x3d_funcDDDP_D = double function(double, double, double, char*);
    alias _x3d_funcDPDD_D = double function(double, char*, double, double);
    alias _x3d_funcDPPP_D = double function(double, char*, char*, char*);
    alias _x3d_funcPDPD_D = double function(char*, double, char*, double);
    alias _x3d_funcPDDDDDDD_D = double function(char*, double, double, double, double, double, double, double);
    
    alias _x3d_funcD_P = char* function(double);
    alias _x3d_funcP_P = char* function(char*);
    alias _x3d_funcDDD_P = char* function(double, double, double);
}

__gshared
{
    mixin(import("xtreme3d_function_headers.txt"));
}

