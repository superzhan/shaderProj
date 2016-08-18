//水面波浪
Shader "Surface_Example/vertexAnimate" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Color("Color ",Color)=(1,1,1,1)
		_tintAmount("Tint Amout",Range(0,1))= 0.5
		_Speed("speed ",Range(0.1,80)) = 5
		_Frequency("wave Frequency ",Range(0,5)) =2
		_Amplitude("wave Amplitude", Range(-1,1)) =1

	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		float4 _Color;
		float _tintAmount;
		float _Speed;
		float _Frequency;
		float _Amplitude;
		

		struct Input {
			float2 uv_MainTex;
			float vertColor;
		};

       void vert(inout appdata_full v, out Input o)
       {
               UNITY_INITIALIZE_OUTPUT(Input,o);  
               
               //使用sin函数设置水面的高度，从 x方向和z方向
               float time= _Time * _Speed;
               float waveValueA= sin(time + v.vertex.x * _Frequency) * _Amplitude;
               float waveValueB = sin(time+ v.vertex.z * _Frequency)* _Amplitude;
               float final = waveValueA + waveValueB;
               
              // 设置顶点的位置 和顶点的法向量
               v.vertex.xyz= float3(v.vertex.x , v.vertex.y + final, v.vertex.z);
               v.normal = normalize( float3( v.normal.x + final, v.normal.y, v.normal.z));
               o.vertColor= float3(final,final,final);
       }
       
       


		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex)  * _Color * _tintAmount;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
			
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
