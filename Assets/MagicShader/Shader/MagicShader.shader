Shader "Unlit/MagicC7Shader"
{
    Properties {
        _CurrentColumn("Column", int) = 0
        _Heightmap("Heightmap", 2D) = "white" {}
        _Aether("Aether", 2D) = "white" {}
        _PatternWidth("PatternWidth", int) = 300
        _PatternHeight("PatternHeight", int) = 300
        _ScreenWidth("ScreenWidth", int) = 1920
        _ScreenHeight("ScreenHeight", int) = 1080
    }

    SubShader {
        Pass {
            CGPROGRAM
            
            #include "UnityCustomRenderTexture.cginc"
            
            #pragma vertex CustomRenderTextureVertexShader
            #pragma fragment fragment_shader

            int _CurrentColumn;
            sampler2D _Heightmap;
            sampler2D _Aether;
            int _PatternWidth;
            int _PatternHeight;
            int _ScreenWidth;
            int _ScreenHeight;

            
            bool empty_lookup(float4 lookup)
            {
                return all(lookup.xy < float2(0.f, 0.f));
            }

            fixed4 fix_limbo(float2 pos, float2 uv, float accuracy)
            {
                if (abs(tex2D(_Heightmap, float2(uv.x - _PatternWidth / (float) _ScreenWidth, uv.y)).r) <= accuracy)
                    return tex2D(_Aether, float2(uv.x - _PatternWidth / (float) _ScreenWidth, uv.y));  // case: no limbo
                return tex2D(_Aether, float2(pos.x % _PatternHeight / _ScreenWidth, (pos.y + _PatternHeight / 7.f * _CurrentColumn) % _PatternHeight / _ScreenHeight));    // case: limbo
            }

            float4 find_lookup(float2 pos, int layers, int layerDistance, float accuracy)
            {
                for (int i = layers; i > 0; i--)
                {
                    int testedShift = layerDistance * i;
                    float2 lookupScreen = float2(pos.x - _PatternWidth + testedShift, pos.y);
                    float2 lookupNorm = float2(lookupScreen.x / (float) _ScreenWidth, lookupScreen.y / (float) _ScreenHeight);
                    int actualShift = round(tex2D(_Heightmap, lookupNorm).x * layers) * layerDistance;
                    if (abs((lookupScreen.x + _PatternWidth - actualShift) - pos.x) <= accuracy)
                        return float4(lookupScreen.xy, lookupNorm.xy);
                }
                return float4(-1.f, -1.f, -1.f, -1.f);
            }
            
            
            fixed4 fragment_shader(v2f_customrendertexture IN) : COLOR
            {
                if (IN.vertex.x < _PatternWidth * _CurrentColumn || IN.vertex.x >= _PatternWidth * (_CurrentColumn+1))
                    return tex2D(_Aether, IN.localTexcoord);   // case: pixel is not in this shader's column
                
                int maxDepth = 100;
                int layers = 100;
                int layerDistance = maxDepth / layers;

                float4 firstLookup = find_lookup(IN.vertex.xy, layers, layerDistance, 0.5f / _ScreenWidth);
                if (empty_lookup(firstLookup))   // case: no first lookup found
                    return fix_limbo(IN.vertex.xy, IN.localTexcoord.xy, 1.f / layers);  // case: ...
                
                if (firstLookup.x < _PatternWidth * _CurrentColumn)
                    return tex2D(_Aether, firstLookup.zw);  // case: no second lookup needed, apply first lookup
                
                float4 secondLookup = find_lookup(firstLookup.xy, layers, layerDistance, 0.5f / _ScreenWidth);
                if (empty_lookup(secondLookup))   // case: no second lookup found
                    return fix_limbo(firstLookup.xy, firstLookup.zw, 1.f / layers);  // case: ...
                
                return tex2D(_Aether, secondLookup.zw); // case: second lookup needed, apply second lookup
            }
            
            ENDCG
        }
    }

}
