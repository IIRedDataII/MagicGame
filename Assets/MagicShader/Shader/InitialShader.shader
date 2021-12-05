Shader "Unlit/InitialShader"
{
    Properties {
        _Pattern("Pattern", 2D) = "white" {}
        _PatternWidth("PatternWidth", int) = 300
        _PatternHeight("PatternHeight", int) = 300
        _PatternOffset("PatternOffset", int) = 0
    }

    SubShader {
        Pass {
            CGPROGRAM
            
            #include "UnityCustomRenderTexture.cginc"
            
            #pragma vertex CustomRenderTextureVertexShader
            #pragma fragment fragment_shader

            sampler2D _Pattern;
            int _PatternWidth;
            int _PatternHeight;
            int _PatternOffset;

            fixed4 fragment_shader(v2f_customrendertexture IN) : COLOR
            {
                return tex2D(_Pattern, float2((IN.vertex.x + _PatternOffset) % _PatternWidth / _PatternWidth, IN.vertex.y % _PatternHeight / _PatternHeight));
            }
            
            ENDCG
        }
    }

}
