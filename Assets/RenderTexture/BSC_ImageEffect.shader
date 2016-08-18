// 亮度 饱和度 对比度调整
Shader "RenderTexture/BSC_ImageEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BrightnessAmount("BrightnessAmount", Range(0,1) ) =1
		_satAmount("Saturation Amount", Range(0,1)) =1
		_conAmount("Contrast Amout ",Range(0,1)) =1
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			//#pragma fragmentoption ARB_precision_hint_fastest
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			fixed  _BrightnessAmount;
			fixed _satAmount;
			fixed _conAmount;

           // 亮度 饱和度 对比度调整
           float3 ContrastSaturationBrightness(float3 color, float brt, float sat , float con)
           {
                float AvgLumR = 0.5;
                float AvgLumG = 0.5;
                float AvgLumB = 0.5;
                
                float3 LuminaceCoeff = float3(0.2125,0.7154, 0.0721);
                
                float AvgLumin = float3(AvgLumR,AvgLumG,AvgLumB);
                float3 brtColor = color * brt;
                float intensityf = dot(brtColor,LuminaceCoeff);
                float3 intensity = float3(intensityf,intensityf,intensityf);
                
                float3 satColor = lerp(intensity,brtColor,sat);
                
                float3 conColor = lerp(AvgLumin,satColor,con);
                
                return conColor;
                
           }

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 renderTex = tex2D(_MainTex, i.uv);
			    renderTex.rgb = ContrastSaturationBrightness(renderTex.rgb ,_BrightnessAmount,_satAmount,_conAmount);
				return renderTex;
			}
			ENDCG
		}
	}
}
