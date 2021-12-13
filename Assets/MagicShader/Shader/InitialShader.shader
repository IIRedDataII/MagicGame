Shader "Unlit/InitialShader"
{
    Properties {
        _Pattern("Pattern", 2D) = "white" {}
        _PatternWidth("PatternWidth", int) = 240
        _PatternHeight("PatternHeight", int) = 240
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

            float randomNorm(float2 input)
            {
                float2 temp = float2(
                    23.14069263277926, // e^pi
                     2.665144142690225 // 2^sqrt(2)
                );
                return frac(cos(dot(input, temp)) * 12345.6789);
            }
            
            fixed4 fragment_shader(v2f_customrendertexture IN) : COLOR
            {
                //return tex2D(_Pattern, randomNorm(IN.localTexcoord + float2(_PatternOffset % _PatternWidth / (float) _PatternWidth, 0)));
                return tex2D(_Pattern, float2((IN.vertex.x + _PatternOffset) % _PatternWidth / _PatternWidth, (IN.vertex.y + _PatternOffset) % _PatternHeight / _PatternHeight));
                //return tex2D(_Pattern, float2((IN.vertex.x + _PatternOffset) % _PatternWidth / _PatternWidth, IN.vertex.y % _PatternHeight / _PatternHeight));
            }
            
            ENDCG
        }
    }

}
