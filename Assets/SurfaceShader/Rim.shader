Shader "Surface_Example/Rim" {
	
	 Properties {
    _MainTex ("Albedo (RGB)", 2D) = "white" {}
    _Color ("Color", Color) = (1, 1, 1, 1)
    _Rim ("Rim", Range(0,1)) = 0.1
  }
  SubShader {
    Tags { "RenderType" = "Opaque" }
    CGPROGRAM
    #pragma surface surf Standard

    sampler2D _MainTex;
    float4 _Color;
    float _Rim;
    #define RIM (1.0 - _Rim)

    struct Input {
        float2 uv_MainTex;
        float3 worldNormal;
        float3 viewDir;
    };

    void surf (Input IN, inout SurfaceOutputStandard o) {

      // Calculate the angle between normal and view direction
      float diff = 1.0 - dot(IN.worldNormal, IN.viewDir);

      // Cut off the diff to the rim size using the RIM value.
      diff = step(RIM, diff) * diff;

      // Smooth value
      float value = step(RIM, diff) * (diff - RIM) / RIM;

      // Sample texture and add rim color
      float3 rgb = tex2D(_MainTex, IN.uv_MainTex).rgb;
      o.Albedo = value * _Color + rgb;
    }
    ENDCG
  }
  FallBack "Diffuse"
}
