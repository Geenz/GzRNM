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
Shader "GzRNMPro/SM2/CRNM Bumped Diffuse" {
	Properties {
		_Color				("Color", Color) = (1,1,1,1)
		_MainTex 			("Albedo", 2D) = "white" {}
		_BumpMap 			("Normal Map", 2D) = "bump" {}
		unity_Lightmap  	("Compressed RNM", 2D) = "black" {}
		unity_LightmapInd 	("Normalized Lightmap Color", 2D) = "white" {}
		_deval				("INTERNAL", Float) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert nolightmap
		#include "GzRNMInc.cginc"
		float4		_Color;
		sampler2D 	_MainTex;
		sampler2D 	_BumpMap;
		sampler2D 	unity_Lightmap;
		sampler2D 	unity_LightmapInd;
		float		_deval;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float2 lmapUV;
		};
		
		float4 unity_LightmapST;
		void vert(inout appdata_full v, out Input o)
		{
			LUVACCESS;
		}
		
		inline half3 CalcCRNM(Input IN, SurfaceOutput o)
		{
			half3 light;
			RNMBASIS;
			CRNMDECODE;
			CRNMCOMPUTE;
			return light * o.Albedo;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			o.Emission = CalcCRNM(IN, o);
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
