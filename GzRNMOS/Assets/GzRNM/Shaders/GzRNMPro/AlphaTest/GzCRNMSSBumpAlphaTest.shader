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
Shader "GzRNMPro/SM2/Alpha Cutout/CRNM SSBumped Diffuse" {
	Properties {
		_Color				("Color", Color) = (1,1,1,1)
		_MainTex 			("Albedo", 2D) = "white" {}
		_SSBump 			("Self-Shadowed Bump", 2D) = "white" {}
		_SSBumpMulti		("SSBump Scale (1 = Just AO, 2 = Normals + AO)", Float) = 1
		_Cutoff				("Alpha cutoff", Range(0,1)) = 0.5
		unity_Lightmap  	("Compressed RNM", 2D) = "black" {}
		unity_LightmapInd 	("Lightmap Color", 2D) = "black" {}
		_deval				("INTERNAL", Float) = 0
	}
	SubShader {
		Tags {"IgnoreProjector"="True" "RenderType"="TransparentCutout"}
		LOD 200
		
		CGPROGRAM
		#pragma surface surf SSBLambert vertex:vert nolightmap alphatest:_Cutoff
		#include "../GzRNMInc.cginc"
		uniform float4		_Color;
		uniform sampler2D 	_MainTex;
		uniform sampler2D	_BumpMap;
		uniform sampler2D	_SSBump;
		uniform float		_SSBumpMulti;
		uniform sampler2D 	unity_Lightmap;
		uniform sampler2D 	unity_LightmapInd;
		uniform float		_deval;

		SSBUMPSURFOUT

		struct Input {
			float2 uv_MainTex;
			float2 uv_SSBump;
			float2 lmapUV;
		};
		
		inline half4 LightingSSBLambert (GzSurfaceOutput s, half3 lightDir, half atten)
		{
			RNMBASIS;
			SSBUMPCOMPUTE;
			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * (diff * atten * 2);
			c.a = s.Alpha;
			return c;
		}
		
		float4 unity_LightmapST;
		void vert(inout appdata_full v, out Input o)
		{
			LUVACCESS;
		}
		
		inline half3 CalcSSRNM(Input IN, GzSurfaceOutput o)
		{
			half3 light;
			CRNMDECODE;
			CRNMSSBUMPCOMPUTE;
			return light * o.Albedo;
		}

		void surf (Input IN, inout GzSurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			SSBUMPASSIGN;
			o.Emission = CalcSSRNM(IN, o);
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
