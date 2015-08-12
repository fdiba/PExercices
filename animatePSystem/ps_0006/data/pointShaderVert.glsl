#define PROCESSING_POINT_SHADER

uniform mat4 projection;
uniform mat4 modelview;
uniform mat4 transform;

uniform bool useColors; //use of colors
uniform sampler2D tex1; //color image
uniform float gWidth;
uniform float gHeight;
uniform float partSystCenter[3];

uniform float dofRatio;
uniform float blurEffect;
 
uniform vec3 psCenter;
uniform vec3 cameraPosition;

attribute vec4 vertex;
attribute vec4 color;
attribute vec2 offset;

varying vec4 vertColor;
varying vec2 center;
varying vec2 texCoord;
varying vec2 pos;

float getDistToPoint(){

  vec3 camPos = cameraPosition;

  vec3 v = vertex.xyz - psCenter;

  //dot returns the dot product of two vectors
  float sn = dot(-camPos, v);

  float sd = camPos.length;
  //float sd = pow(camPos.length, 2);

  sd *= sd;

  camPos *= (sn/sd);

  vec3 isec = vertex.xyz + camPos;

  float dist = length(isec - vertex.xyz);

  return dist;
/*
  float sn = -normal.dot(p.sub(this));
        float sd = normal.magSquared();
        Vec3D isec = p.add(normal.scale(sn / sd));
        return isec.distanceTo(p);*/

}
void main() {

  vec2 m0ffset = vec2(offset);

  float distToFocalPlane = getDistToPoint();
  
  distToFocalPlane /= dofRatio;

  distToFocalPlane += blurEffect;

  distToFocalPlane = clamp(distToFocalPlane, 1., 15.);

  float alpha = (255./(distToFocalPlane*distToFocalPlane))/255.;
  alpha = clamp(alpha, .01, 1.);


  if(m0ffset[0] > 0)m0ffset[0]+=distToFocalPlane;
  if(m0ffset[0] < 0)m0ffset[0]+=-distToFocalPlane;
  if(m0ffset[1] > 0)m0ffset[1]+=distToFocalPlane;
  if(m0ffset[1] < 0)m0ffset[1]+=-distToFocalPlane;


  vec4 col = vec4(1.0, 1.0, 1.0, alpha);


  //vec4 pos = modelview * vertex;
  //vec4 clip = projection * pos;

  vec4 clip = transform * vertex;
  gl_Position = clip + projection * vec4(m0ffset, 0, 0);
  

  if(useColors){
    

    vec2 tex2Pos = vec2(vertex.x/gWidth+.5, vertex.y/gHeight+.5);
    //vec2 tex2Pos = vec2(vertex.x/gWidth, vertex.y/gHeight);
    
    col.rgb = texture2D(tex1, tex2Pos).rgb;


  } 

  vertColor = col;   

  center = clip.xy;
  pos = m0ffset;

}
