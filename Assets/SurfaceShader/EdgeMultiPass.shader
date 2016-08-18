
//描边
Shader "Surface_Example/EdgeMultiPass" {
	
	 Properties {
    _MainTex ("Albedo (RGB)", 2D) = "white" {}
    _OutlineSize ("Outline Size", float) = 0.05
    _OutlineColor ("Outline Color", Color) = (1, 1, 1, 1)
  }
  SubShader {
     Tags { "RenderType" = "Opaque" }

    // Render the normal content as a second pass overlay.
    // This is a normal texture map.
    CGPROGRAM
      #pragma surface surf Standard

      sampler2D _MainTex;

      struct Input {
        float2 uv_MainTex;
      };

      void surf (Input IN, inout SurfaceOutputStandard o) {
        fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
        o.Albedo = c.rgb;
      }
    ENDCG

    // Cull rendered pixels on this surface
    Cull Front

    // Render scaled background geometry
    CGPROGRAM
      #pragma surface surf Standard vertex:vert

      float4 _OutlineColor;
      float _OutlineSize;

      // Linearly expand using surface normal
      void vert (inout appdata_full v) {
        v.vertex.xyz += v.normal * _OutlineSize;
      }

      struct Input {
        float2 uv_MainTex;
      };

      void surf (Input IN, inout SurfaceOutputStandard o) {
        o.Albedo = _OutlineColor.rgb;
      }
    ENDCG
  }
  FallBack "Diffuse"
}
