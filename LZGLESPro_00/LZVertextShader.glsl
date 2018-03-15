attribute vec3 vPosition;
attribute  vec3 vColor;
varying vec4 outColor;
void main(void)
{
    gl_Position = vec4(vPosition, 1.0);
    outColor = vec4(vColor, 1.0);
}
