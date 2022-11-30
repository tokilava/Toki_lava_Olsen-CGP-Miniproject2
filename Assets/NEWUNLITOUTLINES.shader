
Shader "Unlit/NEWUNLITOUTLINES"
{
    Properties
    {
        
        _Thickness ("Thickness", Float) = 0.1
        //[MaterialToggle] _Outlines("Outlines", Float) = 0
        //[MaterialToggle] _Silhouette("Silhouette", Float) = 0
        // [Toggle (_OUTLINES)]
        // __OUTLINES ("outlineSS", Float) = 0

        // [Toggle (_SILHOUETTE)]
        // __SILHOUETTE ("SILHOUETTE", Float) = 0
        
        
    }
    SubShader
    {
    
       // Tags { "RenderType"="Opaque" }
        //LOD 100
       
        Pass 
       {
        
        Stencil{
            Ref 1
            Comp Always
            Pass replace
            
        }
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag 
        
        

        struct MeshData     //per vertex mesh data
            {
                float4 vertex : POSITION;   //vertex position
            };
        
        struct Interpolators      //data that gets passed from the vertex shader to the fragment shader.
            {
                float4 vertex : POSITION;
            };
        
         Interpolators vert(MeshData p ) {
                Interpolators o1;
                o1.vertex = UnityObjectToClipPos(p.vertex);
                return o1;
            }
        
        float4 frag(void) : COLOR{
            return float4(0.3, 0.3, 0.3, 1.0);
        }
        ENDCG
       }

       
        
        Pass
        {
            
            //Tags{"LightMode" = "Regular"}
            //public void SetShaderPassEnabled(string Regular, bool enabled);
            Cull Off
            //ZTest Always
            
            Stencil {
                Ref 1
                Comp NotEqual
                Pass Keep //Keep was before
                
            }
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag 

            //#pragma shader_feature _OUTLINES

            #include "UnityCG.cginc"

            struct MeshData     //per vertex mesh data
            {
                float4 vertex : POSITION;   //vertex position
                float3 normals : NORMAL;
            };

            struct Interpolators      //data that gets passed from the vertex shader to the fragment shader.
            {
                float4 vertex : POSITION;
                float3 normals : NORMAL;
            };

 
            uniform float _Thickness;
            
 
            Interpolators vert (MeshData v ) {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(float4(v.normals,0.0) * _Thickness + v.vertex);
                return o;
            }


            // float4 frag(void) : COLOR {
            //     #ifdef _OUTLINES
            //         return float4(255.0,191.0,0.0,1.0);
            //     #else 
            //         return float4(0.0, 0.0, 0.0, 0.0);
            //     #endif
            // }

            float4 frag(void) : COLOR {
                
                return float4(255.0,191.0,0.0,0.0);
                
            }

            ENDCG           
        }
        


        // Pass{
        //     ZTest Greater
        //     CGPROGRAM

        //     #pragma vertex vert
        //     #pragma fragment frag
        //     #pragma shader_feature _SILHOUETTE

        //     #include "UnityCG.cginc"

        //     struct MeshData {
        //         float4 vertex : POSITION;
        //         float3 normal : NORMAL;
        //     };

        //     struct Interpolators{
        //         float4 vertex : POSITION;
        //         float3 normal : NORMAL;
        //     };
        //     uniform float _Thickness;

        //     Interpolators vert (MeshData a){
        //         Interpolators t;
        //         t.vertex = UnityObjectToClipPos(float4(a.normal,0.0) * _Thickness + a.vertex);
        //         //t.vertex = fixed4(0,0,0,0);
        //         return t;
        //     }

        //     float4 frag (void) : COLOR0 {       //was COLOR before and void
        //         #ifdef _SILHOUETTE
        //             return float4(255.0, 191.0, 0.0, 1.0);
        //         #else
        //             discard;     //was float 4 before
        //         #endif
        //     }
        //     ENDCG

        // }
    }
}
