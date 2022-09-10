/*
author: Matt DesLauriers
description: adapted versions of gaussian fast blur 13 from https://github.com/Jam3/glsl-fast-gaussian-blur
use: gaussianBlur1D_fast9(<sampler2D> texture, <vec2> st, <vec2> pixel_direction)
options:
    - SAMPLER_FNC(TEX, UV): optional depending the target version of GLSL (texture2D(...) or texture(...))
    - GAUSSIANBLUR1D_FAST9_TYPE
    - GAUSSIANBLUR1D_FAST9_SAMPLER_FNC(POS_UV)
license: |
    The MIT License (MIT) Copyright (c) 2015 Jam3
    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
#ifndef SAMPLER_FNC
#define SAMPLER_FNC(TEX, UV) texture2D(TEX, UV)
#endif

#ifndef GAUSSIANBLUR1D_FAST9_TYPE
#ifdef GAUSSIANBLUR_TYPE
#define GAUSSIANBLUR1D_FAST9_TYPE GAUSSIANBLUR_TYPE
#else
#define GAUSSIANBLUR1D_FAST9_TYPE vec4
#endif
#endif

#ifndef GAUSSIANBLUR1D_FAST9_SAMPLER_FNC
#ifdef GAUSSIANBLUR_SAMPLER_FNC
#define GAUSSIANBLUR1D_FAST9_SAMPLER_FNC(POS_UV) GAUSSIANBLUR_SAMPLER_FNC(POS_UV)
#else
#define GAUSSIANBLUR1D_FAST9_SAMPLER_FNC(POS_UV) SAMPLER_FNC(tex, POS_UV)
#endif
#endif

#ifndef FNC_GAUSSIANBLUR1D_FAST9
#define FNC_GAUSSIANBLUR1D_FAST9
GAUSSIANBLUR1D_FAST9_TYPE gaussianBlur1D_fast9(in sampler2D tex, in vec2 st, in vec2 offset) {
    GAUSSIANBLUR1D_FAST9_TYPE color = GAUSSIANBLUR1D_FAST9_TYPE(0.);
    vec2 off1 = vec2(1.3846153846) * offset;
    vec2 off2 = vec2(3.2307692308) * offset;
    color += GAUSSIANBLUR1D_FAST9_SAMPLER_FNC(st) * .2270270270;
    color += GAUSSIANBLUR1D_FAST9_SAMPLER_FNC(st + (off1)) * .3162162162;
    color += GAUSSIANBLUR1D_FAST9_SAMPLER_FNC(st - (off1)) * .3162162162;
    color += GAUSSIANBLUR1D_FAST9_SAMPLER_FNC(st + (off2)) * .0702702703;
    color += GAUSSIANBLUR1D_FAST9_SAMPLER_FNC(st - (off2)) * .0702702703;
    return color;
}
#endif
