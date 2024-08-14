#include "../material.hlsl"

/*
contributors:  Inigo Quiles
description: Map of SDF functions to be declare
use: <float4> raymarchMap( in <float3> pos ) 
*/

#ifndef RAYMARCH_MAP_FNC
#define RAYMARCH_MAP_FNC raymarchMap
#endif

#ifndef FNC_RAYMARCH_MAP
#define FNC_RAYMARCH_MAP

Material RAYMARCH_MAP_FNC( in float3 pos );

#endif