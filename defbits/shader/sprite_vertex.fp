varying mediump vec2 var_texcoord0;
varying mediump vec4 var_mycolor;

uniform lowp sampler2D texture_sampler;

void main()
{
    lowp vec4 tint_pm = vec4(var_mycolor.xyz * var_mycolor.w, var_mycolor.w);
    gl_FragColor = texture2D(texture_sampler, var_texcoord0.xy) * tint_pm;
}