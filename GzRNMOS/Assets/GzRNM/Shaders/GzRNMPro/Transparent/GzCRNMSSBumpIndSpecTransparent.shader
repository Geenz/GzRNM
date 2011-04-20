/*
    GzRNM - A shader library for Radiosity Normal Mapping in Unity3D!    
    Copyright (C) 2011  Jonathan Goodman

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/
Shader "GzRNMPro/SM3/Transparent/CRNM SSBump Indirect Specular" {
	Properties {
		_Color				("Color", Color) = (1,1,1,1)
		_SpecColor			("Specular Color", Color) = (1,1,1,1)
		_Shininess			("Shininess", Range(0.01, 1)) = 0.15
		_MainTex 			("Albedo (RGB) Gloss (A)", 2D) = "white" {}
		_BumpMap 			("Normal Map", 2D) = "bump" {}
		_SSBump				("Self-Shadowed Bump Map", 2D) = "white" {}
		_SSBumpMulti		("SSBump Scale", Float) = 1
		_UseSMap			("Use Dedicated Specular Map?", Range(0, 1)) = 1
		_SpecMap			("Specular Map (RGB)", 2D) = "white" {}
		_SpecMulti			("Specular Multiplier", Float) = 1.0
		unity_Lightmap  	("Compressed RNM", 2D) = "black" {}
		unity_LightmapInd 	("Normalized Lightmap Color", 2D) = "black" {}
		_deval				("INTERNAL", Float) = 0
	}
	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 200
		
		CGPROGRAM
		#pragma surface surf GzBlinnPhong vertex:vert nolightmap alpha
		#pragma glsl
		#pragma target 3.0
		#include "../GzRNMInc.cginc"
		uniform float4		_Color;
		uniform float		_Shininess;
		uniform sampler2D 	_MainTex;
		uniform sampler2D 	_BumpMap;
		uniform sampler2D	_SSBump;
		uniform float		_SSBumpMulti;
		uniform float		_UseSMap;
		uniform sampler2D	_SpecMap;
		uniform float		_SpecMulti;
		uniform sampler2D 	unity_Lightmap;
		uniform sampler2D 	unity_LightmapInd;
		uniform sampler2D	unity_LightmapC;
		uniform float		_deval;
		
		SSBUMPSURFOUT
		
		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float2 uv_SSBump;
			float2 uv_SpecMap;
			float2 lmapUV;
			float3 viewDir;
		};
		
		inline half4 LightingGzBlinnPhong (GzSurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
		{
			
			RNMBASIS;
			SSBUMPCOMPUTE;
			half3 h = normalize (lightDir + viewDir);
	
			float nh = max (0, dot (s.Normal, h));
			half3 spec = pow (nh, s.Specular*128.0) * s.Gloss;
	
			half4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * _SpecColor.rgb * spec) * (atten * 2);
			c.a = s.Alpha + _LightColor0.a * _SpecColor.a * spec * atten;
			return c;
		}
		
		float4 unity_LightmapST;
		void vert(inout appdata_full v, out Input o)
		{
			LUVACCESS;
		}
		
		inline half3 CalcCRNM(Input IN, GzSurfaceOutput o)
		{
			half3 light;
			half3 spec = normalize(IN.viewDir);
			RNMBASIS;
			RNMSPECBASIS;
			CRNMDECODE;
			SSBUMPCRNMSPECCOMPUTE;
			CRNMSSBUMPCOMPUTE;
			return light * o.Albedo + spec;
		}

		void surf (Input IN, inout GzSurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo 	= c.rgb;
			SSBUMPNORMASSIGN;
			SPECLERP;
			o.Specular	= _Shininess;
			o.Emission 	= CalcCRNM(IN, o);
			o.Alpha 	= c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
