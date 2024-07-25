#include "srandom.wgsl"

/*
contributors:
    - Inigo Quilez
    - Stevan Dedovic
description: Returns 2D/3D value noise in the first channel and in the rest the derivatives. For more details read this nice article http://www.iquilezles.org/www/articles/gradientnoise/gradientnoise.htm
use: noised(<vec2|vec3> space)
options:
    NOISED_QUINTIC_INTERPOLATION: Quintic interpolation on/off. Default is off.
examples:
    - /shaders/generative_noised.frag
*/

#ifndef NOISED_RANDOM2_FNC
#define NOISED_RANDOM2_FNC srandom22
#endif

#ifndef NOISED_RANDOM3_FNC
#define NOISED_RANDOM3_FNC srandom33
#endif

#ifndef FNC_NOISED
#define FNC_NOISED

// return gradient noise (in x) and its derivatives (in yz)
fn noised2 (p: vec2f) -> vec3f {
    // grid
    let i = floor( p );
    let f = fract( p );

    // quintic interpolation
    let u = f * f * f * (f * (f * 6. - 15.) + 10.);
    let du = 30. * f * f * (f * (f - 2.) + 1.);

    let ga = NOISED_RANDOM2_FNC(i + vec2(0., 0.));
    let gb = NOISED_RANDOM2_FNC(i + vec2(1., 0.));
    let gc = NOISED_RANDOM2_FNC(i + vec2(0., 1.));
    let gd = NOISED_RANDOM2_FNC(i + vec2(1., 1.));

    let va = dot(ga, f - vec2(0., 0.));
    let vb = dot(gb, f - vec2(1., 0.));
    let vc = dot(gc, f - vec2(0., 1.));
    let vd = dot(gd, f - vec2(1., 1.));

    return vec3( va + u.x*(vb-va) + u.y*(vc-va) + u.x*u.y*(va-vb-vc+vd),   // value
                ga + u.x*(gb-ga) + u.y*(gc-ga) + u.x*u.y*(ga-gb-gc+gd) +  // derivatives
                du * (u.yx*(va-vb-vc+vd) + vec2(vb,vc) - va));
}

fn noised3 (pos: vec3f) -> vec4f {
    // grid
    let p = floor(pos);
    let w = fract(pos);

    // quintic interpolant
    let u = w * w * w * ( w * (w * 6. - 15.) + 10. );
    let du = 30.0 * w * w * ( w * (w - 2.) + 1.);

    // gradients
    let ga = NOISED_RANDOM3_FNC(p + vec3(0., 0., 0.));
    let gb = NOISED_RANDOM3_FNC(p + vec3(1., 0., 0.));
    let gc = NOISED_RANDOM3_FNC(p + vec3(0., 1., 0.));
    let gd = NOISED_RANDOM3_FNC(p + vec3(1., 1., 0.));
    let ge = NOISED_RANDOM3_FNC(p + vec3(0., 0., 1.));
    let gf = NOISED_RANDOM3_FNC(p + vec3(1., 0., 1.));
    let gg = NOISED_RANDOM3_FNC(p + vec3(0., 1., 1.));
    let gh = NOISED_RANDOM3_FNC(p + vec3(1., 1., 1.));

    // projections
    let va = dot(ga, w - vec3(0., 0., 0.));
    let vb = dot(gb, w - vec3(1., 0., 0.));
    let vc = dot(gc, w - vec3(0., 1., 0.));
    let vd = dot(gd, w - vec3(1., 1., 0.));
    let ve = dot(ge, w - vec3(0., 0., 1.));
    let vf = dot(gf, w - vec3(1., 0., 1.));
    let vg = dot(gg, w - vec3(0., 1., 1.));
    let vh = dot(gh, w - vec3(1., 1., 1.));

    // interpolations
    return vec4( va + u.x*(vb-va) + u.y*(vc-va) + u.z*(ve-va) + u.x*u.y*(va-vb-vc+vd) + u.y*u.z*(va-vc-ve+vg) + u.z*u.x*(va-vb-ve+vf) + (-va+vb+vc-vd+ve-vf-vg+vh)*u.x*u.y*u.z,    // value
                ga + u.x*(gb-ga) + u.y*(gc-ga) + u.z*(ge-ga) + u.x*u.y*(ga-gb-gc+gd) + u.y*u.z*(ga-gc-ge+gg) + u.z*u.x*(ga-gb-ge+gf) + (-ga+gb+gc-gd+ge-gf-gg+gh)*u.x*u.y*u.z +   // derivatives
                du * (vec3(vb,vc,ve) - va + u.yzx*vec3(va-vb-vc+vd,va-vc-ve+vg,va-vb-ve+vf) + u.zxy*vec3(va-vb-ve+vf,va-vb-vc+vd,va-vc-ve+vg) + u.yzx*u.zxy*(-va+vb+vc-vd+ve-vf-vg+vh) ));
}

#endif
