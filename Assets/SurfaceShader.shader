Shader "Unlit/SurfaceShader"
{
    Properties
    {
       
    }
    SubShader
    {
        

        Pass        //This pass is for the surface of the "background" objects, i.e. floors, walls etc...
        {

            Cull Off    //Render the entire object, 
                        //which the object passes through

            //This stencil test makes sure that when ever the outlined
            //object is behind a wall, the outlines stay in the stencil buffer.
            //The outlines have a Ref = 1, and the SurfaceShader has a Ref = 2
            //therefore they will never be equal, and this stencil test will always pass.
            //and we tell it to keep what was in the stencil buffer, which is the outlines.
            Stencil{        
            Ref 2
            Comp NotEqual
            Pass Keep
            }
            
            //what function is the vertex shader and fragment shader
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct MeshDataSurface
            {
                float4 vertex : POSITION;   //pass the position data into vertex
            };

            struct InterpolatorsSurface
            {
                float4 vertex : POSITION;   //position of the vertex that gets passed from the vertex shader to the fragment shader
            };

            InterpolatorsSurface vert (MeshDataSurface v)   //vertex shader returns the interpolator
            {
                InterpolatorsSurface o;
                o.vertex = UnityObjectToClipPos(v.vertex);     //transform the vertex point from object space to clip space    
                return o;
            }

            fixed4 frag (void) : COLOR
            {
                return float4(0.8, 0.8, 0.8, 1.0);          //sets the color of the surface to be light gray
            }
            ENDCG
        }
    }
}
