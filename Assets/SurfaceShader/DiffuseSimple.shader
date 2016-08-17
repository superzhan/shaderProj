Shader "Surface_Example/DiffuseSimple" {
	
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
	
		#pragma surface surf Lambert

		struct Input {
			float4 color : COLOR;
		};


		void surf (Input IN, inout SurfaceOutput  o) {
		    o.Albedo=0.5f;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
