Shader "GeometrySky/Skybox"
{
	Properties
	{
		_MainTex("Starmap Texture", 2D) = "white" {}
		_StarIntensity("Stars Intensity", Range(0, 1)) = 1

		_SkyColor1("Top Color", Color) = (0.37, 0.52, 0.73, 0)
		_SkyColor2("Horizon Color", Color) = (0.89, 0.96, 1, 0)
		_SkyColor3("Bottom Color", Color) = (0.89, 0.89, 0.89, 0)
		_SkyBlend1("Top Sky", Range(0, 10)) = 2.15
		_SkyBlend2("Bottom Sky", Range(0, 1)) = 1.25
		_SkyHorizonSharpness("Horizon Sharpness", Range(32, 512)) = 128

		_SunColor("Sun Color", Color) = (1, 0.99, 0.87, 1)
		_SunSize("Sun Intensity", float) = 0.27
		_SunSharpness("Sun Sharpness", float) = 0.27
		_SunHaloSize("Sun Halo Size", Range(0.5, 512)) = 0.5
		_SunHaloIntensity("Sun Halo Intensity", Range(0, 10)) = 0.27

		_HaloColor("Halo Color", Color) = (1, 0.99, 0.87, 1)
		_HaloSize("Halo Size", Range(0.5, 16)) = 0.5
		_HaloIntensity("Halo Intensity", Range(0, 2)) = 0.27
	}
	SubShader
	{
		Tags{ "RenderType" = "Background" "Queue" = "Background" }
		LOD 100

		Pass
		{
			ZWrite Off
			Cull Off
			Fog{ Mode Off }
			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _ STARS_ON
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 uv : TEXCOORD0;
			};

			uniform sampler2D _MainTex;
			uniform half _StarIntensity;

			uniform half3 _SkyColor1;
			uniform half3 _SkyColor2;
			uniform half3 _SkyColor3;

			uniform half _SkyBlend1;
			uniform half _SkyBlend2;
			uniform half _SkyHorizonSharpness;

			uniform half3 _SunColor;
			uniform half _SunSize;
			uniform half _SunSharpness;
			uniform half _SunHaloSize;
			uniform half _SunHaloIntensity;

			uniform half3 _HaloColor;
			uniform half _HaloIntensity;
			uniform half _HaloSize;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			half4 frag (v2f i) : SV_Target
			{
				float3 v = normalize(i.uv);
				float p = v.y;

				//Skygradient
				float bhalf = saturate((-p) * _SkyHorizonSharpness);
				float rbhalf = 1 - bhalf;
				float pbottom = (1  - p - _SkyBlend2) * bhalf * bhalf;

				float p1 = 1 - pow(min(1, 1 - p), _SkyBlend1);
				float p3 = saturate(pbottom);
				float p2 = 1 - p1 - p3;

				half3 c_sky = _SkyColor1 * p1 + _SkyColor2 * p2 + _SkyColor3 * p3;

				//Halos
				float lightAngle = dot(v, _WorldSpaceLightPos0.xyz);

				float light = max(0, lightAngle);

				float psun = min(pow(light, _SunSize) * _SunSharpness, 2) * 0.5;
				half3 c_sun = (_SunColor * psun + half3(1, 1, 1) * psun) * rbhalf;

				float sp = saturate(pow(light * 0.95, _SunHaloSize)) * _SunHaloIntensity /** saturate(1 - p*p + 0.5)*/ 
					* saturate(1 - saturate(-p) * 10);

				float hp = pow(saturate(1 - (abs(p) * _HaloSize)), 8) * _HaloIntensity    * (light + 1) * 0.5f;

				half3 c_halo = _SunColor * sp + _HaloColor * hp;

				half4 c = half4(c_sky + c_sun + c_halo, 0);

			#if STARS_ON
				half4 sceneColor1 = tex2D(_MainTex, i.uv.xz / (i.uv.y * 0.4));
				half4 sceneColor2 = tex2D(_MainTex, i.uv.xz / (i.uv.y * 2.1) + half2(_Time.x, _Time.x));

				half4 c2 = half4(sceneColor1.g, sceneColor1.g, sceneColor1.g, 1) * 1.7 * sceneColor2.r * sceneColor2.b * rbhalf;
				return c + c2 * _StarIntensity;
			#else
				return c;
			#endif
			}
			ENDCG
		}
	}
	CustomEditor "SkyboxInspector"
}
