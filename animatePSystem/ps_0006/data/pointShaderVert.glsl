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

void main() {

  vec4 col;
  vec2 m0ffset = vec2(offset);

  //---------- get distance to focalPlane ----------//

  vec3 camPos = cameraPosition; //normal

  //vec3 v = vertex.xyz - psCenter; //psCenter origin
  vec3 v =  psCenter - vertex.xyz;

  //dot returns the dot product of two vectors

  float sn = dot(-camPos, v);

  float sd = length(camPos);
  sd = pow(sd, 2);

  camPos *= (sn/sd);

  vec3 isec = vertex.xyz + camPos;

  float dist = distance(isec, vertex.xyz);

  float distToFocalPlane = dist;


  //---------- end get distance to focalPlane ----------//


  //float distToFocalPlane = getDistToPoint();
  //float distToFocalPlane = 1.;
  
  distToFocalPlane /= dofRatio;

  //distToFocalPlane += blurEffect;

  distToFocalPlane = clamp(distToFocalPlane, 1., 15.);

  if(distToFocalPlane>10.){

    col = vec4(0.0, 1.0, .0, 1.0);

  } else if(distToFocalPlane>1.){

    col = vec4(1.0, .0, .0, 1.0);

  } else if (distToFocalPlane==1.){

    col = vec4(.0, 1.0, 1.0, 1.0);

  } else {
    //purple
    col = vec4(1.0, .0, 1.0, 1.0); 

  }

  float alpha = (255./(distToFocalPlane*distToFocalPlane))/255.;

  alpha = clamp(alpha, .1, 1.);

  col.a = alpha;

  //alpha = 1.;

  if(m0ffset[0] > 0)m0ffset[0]+=distToFocalPlane;
  if(m0ffset[0] < 0)m0ffset[0]+=-distToFocalPlane;
  if(m0ffset[1] > 0)m0ffset[1]+=distToFocalPlane;
  if(m0ffset[1] < 0)m0ffset[1]+=-distToFocalPlane;


  //vec4 col = vec4(1.0, 1.0, 1.0, alpha);
  //vec4 col = vec4(alpha, alpha, alpha, 1.);


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
