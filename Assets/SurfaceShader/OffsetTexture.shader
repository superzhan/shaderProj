Shader "Surface_Example/OffsetTexture" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
       _OffsetTex ("Albedo (RGB)", 2D) = "white" {}
       _Amount ("Offset Scale Amount", Range(0,1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
    LOD 200
    CGPROGRAM
    #pragma surface surf Standard fullforwardshadows
    #pragma target 3.0

    sampler2D _MainTex;
    sampler2D _OffsetTex;
    float _Amount;

    struct Input {
      float2 uv_MainTex;
      float2 uv_OffsetTex;
    };

    void surf (Input IN, inout SurfaceOutputStandard o) {

      // Sample the offset texture
      float3 offset = tex2D (_OffsetTex, IN.uv_OffsetTex);

      // Rotate the uv offset in a cirlce over the target texture
      //float v = _Amount * offset[0];
      float v= _Amount;
      float x = lerp(-v, v, sin(_Time[3]));
      float y = lerp(-v, v, cos(_Time[3]));

      // Generate a new UV for the texture
      float2 uv = float2(IN.uv_MainTex[0] + x, IN.uv_MainTex[1] + y);

      // Sample the original at the new uv
      o.Albedo = tex2D (_MainTex, uv);
    }
    ENDCG
  }
  FallBack "Diffuse"
}
