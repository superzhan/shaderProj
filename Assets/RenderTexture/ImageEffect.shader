Shader "RenderTexture/ImageEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_LuminosityAmount("GrayScale Amount ", Range(0 ,1 )) = 1.0
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
			fixed _LuminosityAmount;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 renderTex = tex2D(_MainTex, i.uv);
			    
			   //灰度图片的转换方式
			    float luminosity = 0.299 * renderTex.r + 0.587 * renderTex.g +0.114* renderTex.b;
			    // luminosity will auto change to fixed4
			    fixed4 finalColor = lerp(renderTex,luminosity,_LuminosityAmount);
		
				return finalColor;
			}
			ENDCG
		}
	}
}
