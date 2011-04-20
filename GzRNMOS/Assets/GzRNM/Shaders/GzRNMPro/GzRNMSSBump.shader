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
Shader "GzRNMPro/SM2/RNM SSBumped Diffuse" {
	Properties {
		_Color				("Color", Color) = (1,1,1,1)
		_MainTex 			("Albedo", 2D) = "white" {}
		_SSBump 			("Self-Shadowed Bump", 2D) = "white" {}
		_SSBumpMulti		("SSBump Scale", Float) = 1
		unity_Lightmap  	("RNM X Component", 2D) = "black" {}
		unity_LightmapInd 	("RNM Y Component", 2D) = "black" {}
		unity_LightmapC		("RNM Z Component", 2D) = "black" {}
		_deval				("INTERNAL", Float) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf SSBLambert vertex:vert nolightmap
		#include "GzRNMInc.cginc"
		uniform float4		_Color;
		uniform sampler2D 	_MainTex;
		uniform sampler2D	_SSBump;
		uniform float		_SSBumpMulti;
		uniform sampler2D 	_BumpMap;
		uniform sampler2D 	unity_Lightmap;
		uniform sampler2D 	unity_LightmapInd;
		uniform sampler2D	unity_LightmapC;
		uniform float		_deval;

		SSBUMPSURFOUT

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
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
			RNMDECODE;
			RNMSSBUMPCOMPUTE;
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
