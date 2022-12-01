
Shader "Unlit/newOutlines"
{
    Properties      //input data
    {
        
        _ThicknessOfEdge ("ThicknessOfOutline", Float) = 0.03
         [Toggle (_OUTLINES)]
         __OUTLINES ("Outlines", Float) = 0

         [Toggle (_SILHOUETTE)]
         __SILHOUETTE ("Silhouette", Float) = 0
        
        
    }
    SubShader
    {
       
        Pass        //This pass renders a color to the object, a dark grey color in this case
       {

        Stencil{    //this stencil test, makes sure that the object itself always renders, it replaces what ever what in the stencil buffer at sets that value to 1
                    //this is for the prime color of the object itself         
            Ref 1
            Comp Always
            Pass replace
            
        }
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag 
        
        

        struct MeshData     //per vertex mesh data
            {
                float4 vertex : POSITION;   //pass the position data into vertex
            };
        
        struct Interpolators      //data that gets passed from the vertex shader to the fragment shader.
            {
                float4 vertex : POSITION;   //position of the vertex that gets passed from the vertex shader to the fragment shader
            };      
        
         Interpolators vert(MeshData p ) {  //vertex shader returns the interpolator
                Interpolators o1;
                o1.vertex = UnityObjectToClipPos(p.vertex);     //transform the vertex point from object space to clip space
                return o1;
            }
        
        float4 frag(void) : COLOR{      //gives the object the color of dark grey
            return float4(0.3, 0.3, 0.3, 1.0);
        }
        ENDCG
       }

       
        
         Pass       //This pass is for the outlines of the object. It creates a larger version of the object and only renders if the outlines are not occluding the object
         {
             Blend SrcAlpha OneMinusSrcAlpha    //allows us to set an alpha value for the float4 Color
             ZTest Always       //ZTest is a depth testing tool. We have set it to always, which means that we will always render the outlines no matter what the depth is
                                //this allows us to see the outlines behind other objects and surfaces.
             
             Stencil {          //this stencil test allows the outlines to be rendered, but only when they arent occluding the "normal" object itself

                 Ref 1          //reference value 
                 Comp NotEqual  //we only pass when what was in the stencil buffer before is not equal to this ref. this allows us to keep the original color of the 3d-object because that has a reference value of 1 too.
                 Pass Keep      // we keep what was in the stencil buffer if the comp test succeeds
                
             }
            
             CGPROGRAM
             #pragma vertex vert
             #pragma fragment frag 
                                            //declare the shader keyword _OUTLINES which allows us to switch the outlines on or off
             #pragma shader_feature _OUTLINES       

             #include "UnityCG.cginc"

             struct MeshData     //per vertex mesh data
             {
                 float4 vertex : POSITION;   //pass the position data into vertex
                 float3 normals : NORMAL;   //pass the normal direction into normals variable
             };

             struct Interpolators      //data that gets passed from the vertex shader to the fragment shader.
             {
                 float4 vertex : POSITION;      //position of the vertex that gets passed from the vertex shader to the fragment shader
                 float3 normals : NORMAL;       //the normals also gets passed from the vertex to fragment shader
             };

 
             uniform float _ThicknessOfEdge;      //define the variable for the outline thickness
            
 
             Interpolators vert (MeshData v ) {     //vertex shader returns interpolators
                 Interpolators o;                                                                           
                                                                                                            //transform the vertex point from object space to clip space
                 o.vertex = UnityObjectToClipPos(float4(v.normals,0.0) * _ThicknessOfEdge + v.vertex);      //we multiply the normal vector with the thickness and the vertexposition to move the vertex along its normal vectors,
                                                                                                            // effectively making a larger version of the 3d-object which covers the object
                 return o;      //return the vertex and pass it to the fragment shader
             }


               float4 frag(void) : COLOR {
                   #ifdef _OUTLINES         //ifdef works like an if statement, where if the variable _OUTLINES is defined we return the color black which is the color of our outlines
                       return float4(0.0,0.0,0.0,1.0);
                   #else                    //in the else statement we also return a black color, but make it fully transparent (alpha = 0) so we can't see it, to give an illusion of switching the outlines "off"
                       return float4(0.0, 0.0, 0.0, 0.0);
                   #endif
               }
               ENDCG       
         }
        
        


          Pass{
              ZTest Greater     //ZTest is a depth testing tool. if the depth is greater it makes sure that the silhouette always renders when its behind other objects which is why we use "Greater"
              Blend SrcAlpha OneMinusSrcAlpha        //allows us to set an alpha value for the float4 Color
              CGPROGRAM

              #pragma vertex vert
              #pragma fragment frag
                                        //declare the shader keyword _SILHOUETTE so we can use it later in the fragment shaders
              #pragma shader_feature _SILHOUETTE        

              #include "UnityCG.cginc"

              struct MeshData {
                  float4 vertex : POSITION;     //declare the position for the vertices
              };

              struct Interpolators{
                  float4 vertex : POSITION;     //position of the vertex that gets passed from the vertex shader to the fragment shader
              };


              Interpolators vert (MeshData a){
                  Interpolators t;
                  t.vertex = UnityObjectToClipPos(a.vertex);   //transform the vertex point from object space to clip space     
                  return t;
              }

              float4 frag (void) : COLOR {       
                  #ifdef _SILHOUETTE            //if _SILHOUETTE is defined we cover the 3d-object in a black color
                      return float4(0.0, 0.0, 0.0, 1.0);
                  #else                         //if _SILHOUETTE is not defined we also cover the ball in a black color but set the alpha value = 0 to make the illusion for switching the silhouette "off"
                     return float4(0,0,0,0);     
                 #endif
             }
             ENDCG

         }
    }
}
