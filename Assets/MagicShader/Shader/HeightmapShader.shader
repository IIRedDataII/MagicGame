Shader "Unlit/HeightmapShader"
{
    Properties {
    }

    SubShader {
        Pass {
            CGPROGRAM
            
            #include "UnityCG.cginc"
            
            #pragma vertex vert_img
            #pragma fragment fragment_shader

            float scaler = 10.f;
            
            fixed4 fragment_shader(v2f_img IN) : SV_Target
            {
                float whiteness = IN.pos.z * 10.f;
                if (whiteness < 0.f)
                    whiteness = 0.f;
                return fixed4(whiteness, 0, 0, 1);
            }
            
            ENDCG
        }
    }

}
