/*
original_author: Brad Larson
description: adapted version of mean average sampling on four coorners of a sampled point from https://github.com/BradLarson/GPUImage2
use: mean(<sampler2D> texture, <vec2> st, <vec2> pixel)
options:
    - MEAN_TYPE: defaults to vec4
    - AVERAGE_SAMPLER_FNC(POS_UV): defaults to texture2D(tex,POS_UV)
    - SAMPLER_FNC(TEX, UV): optional depending the target version of GLSL (texture2D(...) or texture(...))
*/

#ifndef SAMPLER_FNC
#define SAMPLER_FNC(TEX, UV) texture2D(TEX, UV)
#endif

#ifndef MEAN_TYPE
#define MEAN_TYPE vec4
#endif

#ifndef MEAN_AMOUNT
#define MEAN_AMOUNT mean4
#endif

#ifndef MEAN_SAMPLER_FNC
#define MEAN_SAMPLER_FNC(POS_UV) SAMPLER_FNC(tex, POS_UV)
#endif

#ifndef FNC_AVERAGE
#define FNC_AVERAGE
MEAN_TYPE mean4(in sampler2D tex, in vec2 st, in vec2 pixel) {
    MEAN_TYPE topLeft = MEAN_SAMPLER_FNC(st - pixel);
    MEAN_TYPE bottomLeft = MEAN_SAMPLER_FNC(st + vec2(-pixel.x, pixel.y));
    MEAN_TYPE topRight = MEAN_SAMPLER_FNC(st + vec2(pixel.x, -pixel.y));
    MEAN_TYPE bottomRight = MEAN_SAMPLER_FNC(st + pixel);
    return 0.25 * (topLeft + topRight + bottomLeft + bottomRight);
}

MEAN_TYPE mean(in sampler2D tex, in vec2 st, in vec2 pixel) {
    return MEAN_AMOUNT(tex, st, pixel);
}
#endif
