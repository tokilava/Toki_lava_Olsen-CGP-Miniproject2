Shader "Unlit/SurfaceShader"
{
    Properties
    {
       
    }
    SubShader
    {
        

        Pass
        {
            
            //Blend Zero One
            //Cull Off

            Stencil{
            Ref 2
            Comp NotEqual
            Pass DecrWrap
            }
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct MeshDataSurface
            {
                float4 vertex : POSITION;
            };

            struct InterpolatorsSurface
            {
                float4 vertex : POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            InterpolatorsSurface vert (MeshDataSurface v)
            {
                InterpolatorsSurface o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                return o;
            }

            fixed4 frag (void) : COLOR
            {
                return float4(0.8, 0.8, 0.8, 1.0);
            }
            ENDCG
        }
    }
}
