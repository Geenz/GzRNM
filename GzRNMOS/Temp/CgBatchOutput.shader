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
		
			
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
Program "vp" {
// Vertex combos: 4
//   opengl - ALU: 38 to 74
//   d3d9 - ALU: 41 to 77
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 15 [unity_SHAr]
Vector 16 [unity_SHAg]
Vector 17 [unity_SHAb]
Vector 18 [unity_SHBr]
Vector 19 [unity_SHBg]
Vector 20 [unity_SHBb]
Vector 21 [unity_SHC]
Float 22 [_deval]
Vector 23 [unity_LightmapST]
Vector 24 [_MainTex_ST]
Vector 25 [_BumpMap_ST]
"!!ARBvp1.0
# 38 ALU
PARAM c[26] = { { 1 },
		state.matrix.mvp,
		program.local[5..25] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[13].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[17];
DP4 R2.y, R0, c[16];
DP4 R2.x, R0, c[15];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[20];
DP4 R3.y, R1, c[19];
DP4 R3.x, R1, c[18];
MOV R1.xyz, vertex.attrib[14];
ADD R3.xyz, R2, R3;
MAD R0.x, R0, R0, -R0.y;
MUL R2.xyz, R0.x, c[21];
MUL R0.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R1.zxyw, -R0;
ADD result.texcoord[3].xyz, R3, R2;
MOV R1, c[14];
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
MUL R0.xyz, R0, vertex.attrib[14].w;
DP3 result.texcoord[2].y, R2, R0;
MAD R0.xy, vertex.texcoord[1], c[23], c[23].zwzw;
ADD R0.xy, R0, -vertex.texcoord[1];
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, R2, vertex.attrib[14];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[25].xyxy, c[25];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[24], c[24].zwzw;
MAD result.texcoord[1].xy, R0, c[22].x, vertex.texcoord[1];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 38 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Float 21 [_deval]
Vector 22 [unity_LightmapST]
Vector 23 [_MainTex_ST]
Vector 24 [_BumpMap_ST]
"vs_2_0
; 41 ALU
def c25, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mul r1.xyz, v2, c12.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c25.x
dp4 r2.z, r0, c16
dp4 r2.y, r0, c15
dp4 r2.x, r0, c14
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c19
dp4 r3.y, r1, c18
dp4 r3.x, r1, c17
mad r0.x, r0, r0, -r0.y
mul r1.xyz, r0.x, c20
add r2.xyz, r2, r3
mov r0.xyz, v1
add oT3.xyz, r2, r1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mov r0, c10
dp4 r3.z, c13, r0
mul r2.xyz, r1, v1.w
mov r0, c9
dp4 r3.y, c13, r0
mov r1, c8
dp4 r3.x, c13, r1
mad r0.xy, v4, c22, c22.zwzw
add r0.xy, r0, -v4
dp3 oT2.y, r3, r2
dp3 oT2.z, v2, r3
dp3 oT2.x, r3, v1
mad oT0.zw, v3.xyxy, c24.xyxy, c24
mad oT0.xy, v3, c23, c23.zwzw
mad oT1.xy, r0, c21.x, v4
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightmapST;

uniform highp float _deval;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  highp vec4 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  mat3 tmpvar_7;
  tmpvar_7[0] = tmpvar_1.xyz;
  tmpvar_7[1] = (cross (tmpvar_2, tmpvar_1.xyz) * tmpvar_1.w);
  tmpvar_7[2] = tmpvar_2;
  mat3 tmpvar_8;
  tmpvar_8[0].x = tmpvar_7[0].x;
  tmpvar_8[0].y = tmpvar_7[1].x;
  tmpvar_8[0].z = tmpvar_7[2].x;
  tmpvar_8[1].x = tmpvar_7[0].y;
  tmpvar_8[1].y = tmpvar_7[1].y;
  tmpvar_8[1].z = tmpvar_7[2].y;
  tmpvar_8[2].x = tmpvar_7[0].z;
  tmpvar_8[2].y = tmpvar_7[1].z;
  tmpvar_8[2].z = tmpvar_7[2].z;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = (tmpvar_6 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_11;
  mediump vec4 normal;
  normal = tmpvar_10;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAr, normal);
  x1.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAg, normal);
  x1.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAb, normal);
  x1.z = tmpvar_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBr, tmpvar_15);
  x2.x = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBg, tmpvar_15);
  x2.y = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBb, tmpvar_15);
  x2.z = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (unity_SHC.xyz * vC);
  x3 = tmpvar_20;
  tmpvar_11 = ((x1 + x2) + x3);
  shlight = tmpvar_11;
  tmpvar_5 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = mix (_glesMultiTexCoord1.xy, ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw), vec2(_deval));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec2 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0.xy;
  highp vec2 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD0.zw;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, tmpvar_1);
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * _Color);
  c_i0 = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = c_i0.xyz;
  tmpvar_3 = tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_9 = ((texture2D (_BumpMap, tmpvar_2).xyz * 2.0) - 1.0);
  mediump vec3 tmpvar_10;
  mediump vec3 LMap;
  mediump vec3 CRNM;
  vec3 bumpBasis[3];
  bumpBasis[0] = vec3(0.816497, 0.0, 0.57735);
  bumpBasis[1] = vec3(-0.408248, 0.707107, 0.57735);
  bumpBasis[2] = vec3(-0.408248, -0.707107, 0.57735);
  lowp vec3 tmpvar_11;
  tmpvar_11 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz);
  CRNM = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD1).xyz);
  LMap = tmpvar_12;
  tmpvar_10 = ((vec3((((max (0.0, dot (bumpBasis[0], tmpvar_9)) * CRNM.x) + (max (0.0, dot (bumpBasis[1], tmpvar_9)) * CRNM.y)) + (max (0.0, dot (bumpBasis[2], tmpvar_9)) * CRNM.z))) * LMap) * tmpvar_3);
  tmpvar_4 = tmpvar_10;
  mediump float tmpvar_13;
  tmpvar_13 = c_i0.w;
  tmpvar_5 = tmpvar_13;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_3 * _LightColor0.xyz) * (max (0.0, dot (tmpvar_9, xlv_TEXCOORD2)) * 2.0));
  c_i0_i1.w = tmpvar_5;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_3 * xlv_TEXCOORD3));
  c.xyz = (c.xyz + tmpvar_4);
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [_ProjectionParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 16 [unity_SHAr]
Vector 17 [unity_SHAg]
Vector 18 [unity_SHAb]
Vector 19 [unity_SHBr]
Vector 20 [unity_SHBg]
Vector 21 [unity_SHBb]
Vector 22 [unity_SHC]
Float 23 [_deval]
Vector 24 [unity_LightmapST]
Vector 25 [_MainTex_ST]
Vector 26 [_BumpMap_ST]
"!!ARBvp1.0
# 43 ALU
PARAM c[27] = { { 1, 0.5 },
		state.matrix.mvp,
		program.local[5..26] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[14].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[18];
DP4 R2.y, R0, c[17];
DP4 R2.x, R0, c[16];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[21];
DP4 R3.y, R1, c[20];
DP4 R3.x, R1, c[19];
MOV R1.xyz, vertex.attrib[14];
DP4 R0.w, vertex.position, c[4];
ADD R3.xyz, R2, R3;
MAD R0.x, R0, R0, -R0.y;
MUL R2.xyz, R0.x, c[22];
MUL R0.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R1.zxyw, -R0;
MUL R0.xyz, R0, vertex.attrib[14].w;
MOV R1, c[15];
ADD result.texcoord[3].xyz, R3, R2;
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
DP3 result.texcoord[2].y, R2, R0;
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].y;
MUL R1.y, R1, c[13].x;
MOV result.position, R0;
MAD R0.xy, vertex.texcoord[1], c[24], c[24].zwzw;
ADD R0.xy, R0, -vertex.texcoord[1];
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, R2, vertex.attrib[14];
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.texcoord[4].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[26].xyxy, c[26];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[25], c[25].zwzw;
MAD result.texcoord[1].xy, R0, c[23].x, vertex.texcoord[1];
END
# 43 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 16 [unity_SHAr]
Vector 17 [unity_SHAg]
Vector 18 [unity_SHAb]
Vector 19 [unity_SHBr]
Vector 20 [unity_SHBg]
Vector 21 [unity_SHBb]
Vector 22 [unity_SHC]
Float 23 [_deval]
Vector 24 [unity_LightmapST]
Vector 25 [_MainTex_ST]
Vector 26 [_BumpMap_ST]
"vs_2_0
; 46 ALU
def c27, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mul r1.xyz, v2, c14.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c27.x
dp4 r2.z, r0, c18
dp4 r2.y, r0, c17
dp4 r2.x, r0, c16
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c21
dp4 r3.y, r1, c20
dp4 r3.x, r1, c19
mad r0.x, r0, r0, -r0.y
mul r1.xyz, r0.x, c22
add r2.xyz, r2, r3
mov r0.xyz, v1
add oT3.xyz, r2, r1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mov r0, c10
dp4 r3.z, c15, r0
mov r0, c9
dp4 r3.y, c15, r0
mul r2.xyz, r1, v1.w
mov r1, c8
dp4 r3.x, c15, r1
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c27.y
mul r1.y, r1, c12.x
mov oPos, r0
mad r0.xy, v4, c24, c24.zwzw
add r0.xy, r0, -v4
dp3 oT2.y, r3, r2
dp3 oT2.z, v2, r3
dp3 oT2.x, r3, v1
mad oT4.xy, r1.z, c13.zwzw, r1
mov oT4.zw, r0
mad oT0.zw, v3.xyxy, c26.xyxy, c26
mad oT0.xy, v3, c25, c25.zwzw
mad oT1.xy, r0, c23.x, v4
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightmapST;

uniform highp float _deval;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  highp vec4 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  mat3 tmpvar_8;
  tmpvar_8[0] = tmpvar_1.xyz;
  tmpvar_8[1] = (cross (tmpvar_2, tmpvar_1.xyz) * tmpvar_1.w);
  tmpvar_8[2] = tmpvar_2;
  mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_8[0].x;
  tmpvar_9[0].y = tmpvar_8[1].x;
  tmpvar_9[0].z = tmpvar_8[2].x;
  tmpvar_9[1].x = tmpvar_8[0].y;
  tmpvar_9[1].y = tmpvar_8[1].y;
  tmpvar_9[1].z = tmpvar_8[2].y;
  tmpvar_9[2].x = tmpvar_8[0].z;
  tmpvar_9[2].y = tmpvar_8[1].z;
  tmpvar_9[2].z = tmpvar_8[2].z;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = (tmpvar_7 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_12;
  mediump vec4 normal;
  normal = tmpvar_11;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal);
  x1.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal);
  x1.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal);
  x1.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC);
  x3 = tmpvar_21;
  tmpvar_12 = ((x1 + x2) + x3);
  shlight = tmpvar_12;
  tmpvar_5 = shlight;
  highp vec4 o_i0_i1;
  highp vec4 tmpvar_22;
  tmpvar_22 = (tmpvar_6 * 0.5);
  o_i0_i1 = tmpvar_22;
  highp vec2 tmpvar_23;
  tmpvar_23.x = tmpvar_22.x;
  tmpvar_23.y = (tmpvar_22.y * _ProjectionParams.x);
  o_i0_i1.xy = (tmpvar_23 + tmpvar_22.w);
  o_i0_i1.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = mix (_glesMultiTexCoord1.xy, ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw), vec2(_deval));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = o_i0_i1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec2 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0.xy;
  highp vec2 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD0.zw;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, tmpvar_1);
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * _Color);
  c_i0 = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = c_i0.xyz;
  tmpvar_3 = tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_9 = ((texture2D (_BumpMap, tmpvar_2).xyz * 2.0) - 1.0);
  mediump vec3 tmpvar_10;
  mediump vec3 LMap;
  mediump vec3 CRNM;
  vec3 bumpBasis[3];
  bumpBasis[0] = vec3(0.816497, 0.0, 0.57735);
  bumpBasis[1] = vec3(-0.408248, 0.707107, 0.57735);
  bumpBasis[2] = vec3(-0.408248, -0.707107, 0.57735);
  lowp vec3 tmpvar_11;
  tmpvar_11 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz);
  CRNM = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD1).xyz);
  LMap = tmpvar_12;
  tmpvar_10 = ((vec3((((max (0.0, dot (bumpBasis[0], tmpvar_9)) * CRNM.x) + (max (0.0, dot (bumpBasis[1], tmpvar_9)) * CRNM.y)) + (max (0.0, dot (bumpBasis[2], tmpvar_9)) * CRNM.z))) * LMap) * tmpvar_3);
  tmpvar_4 = tmpvar_10;
  mediump float tmpvar_13;
  tmpvar_13 = c_i0.w;
  tmpvar_5 = tmpvar_13;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (tmpvar_9, xlv_TEXCOORD2)) * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x) * 2.0));
  c_i0_i1.w = tmpvar_5;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_3 * xlv_TEXCOORD3));
  c.xyz = (c.xyz + tmpvar_4);
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 15 [unity_4LightPosX0]
Vector 16 [unity_4LightPosY0]
Vector 17 [unity_4LightPosZ0]
Vector 18 [unity_4LightAtten0]
Vector 19 [unity_LightColor0]
Vector 20 [unity_LightColor1]
Vector 21 [unity_LightColor2]
Vector 22 [unity_LightColor3]
Vector 23 [unity_SHAr]
Vector 24 [unity_SHAg]
Vector 25 [unity_SHAb]
Vector 26 [unity_SHBr]
Vector 27 [unity_SHBg]
Vector 28 [unity_SHBb]
Vector 29 [unity_SHC]
Float 30 [_deval]
Vector 31 [unity_LightmapST]
Vector 32 [_MainTex_ST]
Vector 33 [_BumpMap_ST]
"!!ARBvp1.0
# 69 ALU
PARAM c[34] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..33] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[13].w;
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[16];
DP3 R3.w, R3, c[6];
DP3 R4.x, R3, c[5];
DP3 R3.x, R3, c[7];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[15];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MAD R2, R4.x, R0, R2;
MOV R4.w, c[0].x;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[17];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[18];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[20];
MAD R1.xyz, R0.x, c[19], R1;
MAD R0.xyz, R0.z, c[21], R1;
MAD R1.xyz, R0.w, c[22], R0;
MUL R0, R4.xyzz, R4.yzzx;
DP4 R3.z, R0, c[28];
DP4 R3.y, R0, c[27];
DP4 R3.x, R0, c[26];
MUL R1.w, R3, R3;
MAD R0.x, R4, R4, -R1.w;
DP4 R2.z, R4, c[25];
DP4 R2.y, R4, c[24];
DP4 R2.x, R4, c[23];
ADD R2.xyz, R2, R3;
MUL R3.xyz, R0.x, c[29];
ADD R3.xyz, R2, R3;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
ADD result.texcoord[3].xyz, R3, R1;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MOV R0, c[14];
DP4 R2.z, R0, c[11];
DP4 R2.y, R0, c[10];
DP4 R2.x, R0, c[9];
MUL R1.xyz, R1, vertex.attrib[14].w;
MAD R0.xy, vertex.texcoord[1], c[31], c[31].zwzw;
ADD R0.xy, R0, -vertex.texcoord[1];
DP3 result.texcoord[2].y, R2, R1;
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, R2, vertex.attrib[14];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[33].xyxy, c[33];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[32], c[32].zwzw;
MAD result.texcoord[1].xy, R0, c[30].x, vertex.texcoord[1];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 69 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_4LightPosX0]
Vector 15 [unity_4LightPosY0]
Vector 16 [unity_4LightPosZ0]
Vector 17 [unity_4LightAtten0]
Vector 18 [unity_LightColor0]
Vector 19 [unity_LightColor1]
Vector 20 [unity_LightColor2]
Vector 21 [unity_LightColor3]
Vector 22 [unity_SHAr]
Vector 23 [unity_SHAg]
Vector 24 [unity_SHAb]
Vector 25 [unity_SHBr]
Vector 26 [unity_SHBg]
Vector 27 [unity_SHBb]
Vector 28 [unity_SHC]
Float 29 [_deval]
Vector 30 [unity_LightmapST]
Vector 31 [_MainTex_ST]
Vector 32 [_BumpMap_ST]
"vs_2_0
; 72 ALU
def c33, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mul r3.xyz, v2, c12.w
dp4 r0.x, v0, c5
add r1, -r0.x, c15
dp3 r3.w, r3, c5
dp3 r4.x, r3, c4
dp3 r3.x, r3, c6
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c14
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c33.x
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c16
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c17
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c33.x
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c33.y
mul r0, r0, r1
mul r1.xyz, r0.y, c19
mad r1.xyz, r0.x, c18, r1
mad r0.xyz, r0.z, c20, r1
mad r1.xyz, r0.w, c21, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r3.z, r0, c27
dp4 r3.y, r0, c26
dp4 r3.x, r0, c25
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c28
dp4 r2.z, r4, c24
dp4 r2.y, r4, c23
dp4 r2.x, r4, c22
add r2.xyz, r2, r3
add r2.xyz, r2, r0
mov r0.xyz, v1
add oT3.xyz, r2, r1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mov r0, c10
dp4 r3.z, c13, r0
mul r2.xyz, r1, v1.w
mov r0, c8
dp4 r3.x, c13, r0
mov r1, c9
dp4 r3.y, c13, r1
mad r0.xy, v4, c30, c30.zwzw
add r0.xy, r0, -v4
dp3 oT2.y, r3, r2
dp3 oT2.z, v2, r3
dp3 oT2.x, r3, v1
mad oT0.zw, v3.xyxy, c32.xyxy, c32
mad oT0.xy, v3, c31, c31.zwzw
mad oT1.xy, r0, c29.x, v4
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightmapST;
uniform highp vec3 unity_LightColor3;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp float _deval;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  highp vec4 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (tmpvar_2 * unity_Scale.w));
  mat3 tmpvar_8;
  tmpvar_8[0] = tmpvar_1.xyz;
  tmpvar_8[1] = (cross (tmpvar_2, tmpvar_1.xyz) * tmpvar_1.w);
  tmpvar_8[2] = tmpvar_2;
  mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_8[0].x;
  tmpvar_9[0].y = tmpvar_8[1].x;
  tmpvar_9[0].z = tmpvar_8[2].x;
  tmpvar_9[1].x = tmpvar_8[0].y;
  tmpvar_9[1].y = tmpvar_8[1].y;
  tmpvar_9[1].z = tmpvar_8[2].y;
  tmpvar_9[2].x = tmpvar_8[0].z;
  tmpvar_9[2].y = tmpvar_8[1].z;
  tmpvar_9[2].z = tmpvar_8[2].z;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_7;
  mediump vec3 tmpvar_12;
  mediump vec4 normal;
  normal = tmpvar_11;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHAr, normal);
  x1.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAg, normal);
  x1.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAb, normal);
  x1.z = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHBr, tmpvar_16);
  x2.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBg, tmpvar_16);
  x2.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBb, tmpvar_16);
  x2.z = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (unity_SHC.xyz * vC);
  x3 = tmpvar_21;
  tmpvar_12 = ((x1 + x2) + x3);
  shlight = tmpvar_12;
  tmpvar_5 = shlight;
  highp vec3 tmpvar_22;
  tmpvar_22 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_23;
  tmpvar_23 = (unity_4LightPosX0 - tmpvar_22.x);
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosY0 - tmpvar_22.y);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosZ0 - tmpvar_22.z);
  highp vec4 tmpvar_26;
  tmpvar_26 = (((tmpvar_23 * tmpvar_23) + (tmpvar_24 * tmpvar_24)) + (tmpvar_25 * tmpvar_25));
  highp vec4 tmpvar_27;
  tmpvar_27 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_23 * tmpvar_7.x) + (tmpvar_24 * tmpvar_7.y)) + (tmpvar_25 * tmpvar_7.z)) * inversesqrt (tmpvar_26))) * 1.0/((1.0 + (tmpvar_26 * unity_4LightAtten0))));
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_5 + ((((unity_LightColor0 * tmpvar_27.x) + (unity_LightColor1 * tmpvar_27.y)) + (unity_LightColor2 * tmpvar_27.z)) + (unity_LightColor3 * tmpvar_27.w)));
  tmpvar_5 = tmpvar_28;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = mix (_glesMultiTexCoord1.xy, ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw), vec2(_deval));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec2 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0.xy;
  highp vec2 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD0.zw;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, tmpvar_1);
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * _Color);
  c_i0 = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = c_i0.xyz;
  tmpvar_3 = tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_9 = ((texture2D (_BumpMap, tmpvar_2).xyz * 2.0) - 1.0);
  mediump vec3 tmpvar_10;
  mediump vec3 LMap;
  mediump vec3 CRNM;
  vec3 bumpBasis[3];
  bumpBasis[0] = vec3(0.816497, 0.0, 0.57735);
  bumpBasis[1] = vec3(-0.408248, 0.707107, 0.57735);
  bumpBasis[2] = vec3(-0.408248, -0.707107, 0.57735);
  lowp vec3 tmpvar_11;
  tmpvar_11 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz);
  CRNM = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD1).xyz);
  LMap = tmpvar_12;
  tmpvar_10 = ((vec3((((max (0.0, dot (bumpBasis[0], tmpvar_9)) * CRNM.x) + (max (0.0, dot (bumpBasis[1], tmpvar_9)) * CRNM.y)) + (max (0.0, dot (bumpBasis[2], tmpvar_9)) * CRNM.z))) * LMap) * tmpvar_3);
  tmpvar_4 = tmpvar_10;
  mediump float tmpvar_13;
  tmpvar_13 = c_i0.w;
  tmpvar_5 = tmpvar_13;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_3 * _LightColor0.xyz) * (max (0.0, dot (tmpvar_9, xlv_TEXCOORD2)) * 2.0));
  c_i0_i1.w = tmpvar_5;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_3 * xlv_TEXCOORD3));
  c.xyz = (c.xyz + tmpvar_4);
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [_ProjectionParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 16 [unity_4LightPosX0]
Vector 17 [unity_4LightPosY0]
Vector 18 [unity_4LightPosZ0]
Vector 19 [unity_4LightAtten0]
Vector 20 [unity_LightColor0]
Vector 21 [unity_LightColor1]
Vector 22 [unity_LightColor2]
Vector 23 [unity_LightColor3]
Vector 24 [unity_SHAr]
Vector 25 [unity_SHAg]
Vector 26 [unity_SHAb]
Vector 27 [unity_SHBr]
Vector 28 [unity_SHBg]
Vector 29 [unity_SHBb]
Vector 30 [unity_SHC]
Float 31 [_deval]
Vector 32 [unity_LightmapST]
Vector 33 [_MainTex_ST]
Vector 34 [_BumpMap_ST]
"!!ARBvp1.0
# 74 ALU
PARAM c[35] = { { 1, 0, 0.5 },
		state.matrix.mvp,
		program.local[5..34] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[14].w;
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[17];
DP3 R3.w, R3, c[6];
DP3 R4.x, R3, c[5];
DP3 R3.x, R3, c[7];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[16];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MAD R2, R4.x, R0, R2;
MOV R4.w, c[0].x;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[18];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[19];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[21];
MAD R1.xyz, R0.x, c[20], R1;
MAD R0.xyz, R0.z, c[22], R1;
MAD R1.xyz, R0.w, c[23], R0;
MUL R0, R4.xyzz, R4.yzzx;
DP4 R3.z, R0, c[29];
DP4 R3.y, R0, c[28];
DP4 R3.x, R0, c[27];
MUL R1.w, R3, R3;
MAD R0.x, R4, R4, -R1.w;
DP4 R2.z, R4, c[26];
DP4 R2.y, R4, c[25];
DP4 R2.x, R4, c[24];
ADD R2.xyz, R2, R3;
MUL R3.xyz, R0.x, c[30];
ADD R3.xyz, R2, R3;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
ADD result.texcoord[3].xyz, R3, R1;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MOV R0, c[15];
DP4 R2.z, R0, c[11];
DP4 R2.y, R0, c[10];
DP4 R2.x, R0, c[9];
MUL R1.xyz, R1, vertex.attrib[14].w;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
DP3 result.texcoord[2].y, R2, R1;
MUL R1.xyz, R0.xyww, c[0].z;
MUL R1.y, R1, c[13].x;
MOV result.position, R0;
MAD R0.xy, vertex.texcoord[1], c[32], c[32].zwzw;
ADD R0.xy, R0, -vertex.texcoord[1];
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, R2, vertex.attrib[14];
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.texcoord[4].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[34].xyxy, c[34];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[33], c[33].zwzw;
MAD result.texcoord[1].xy, R0, c[31].x, vertex.texcoord[1];
END
# 74 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 16 [unity_4LightPosX0]
Vector 17 [unity_4LightPosY0]
Vector 18 [unity_4LightPosZ0]
Vector 19 [unity_4LightAtten0]
Vector 20 [unity_LightColor0]
Vector 21 [unity_LightColor1]
Vector 22 [unity_LightColor2]
Vector 23 [unity_LightColor3]
Vector 24 [unity_SHAr]
Vector 25 [unity_SHAg]
Vector 26 [unity_SHAb]
Vector 27 [unity_SHBr]
Vector 28 [unity_SHBg]
Vector 29 [unity_SHBb]
Vector 30 [unity_SHC]
Float 31 [_deval]
Vector 32 [unity_LightmapST]
Vector 33 [_MainTex_ST]
Vector 34 [_BumpMap_ST]
"vs_2_0
; 77 ALU
def c35, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mul r3.xyz, v2, c14.w
dp4 r0.x, v0, c5
add r1, -r0.x, c17
dp3 r3.w, r3, c5
dp3 r4.x, r3, c4
dp3 r3.x, r3, c6
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c16
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c35.x
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c18
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c19
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c35.x
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c35.y
mul r0, r0, r1
mul r1.xyz, r0.y, c21
mad r1.xyz, r0.x, c20, r1
mad r0.xyz, r0.z, c22, r1
mad r1.xyz, r0.w, c23, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r3.z, r0, c29
dp4 r3.y, r0, c28
dp4 r3.x, r0, c27
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c30
dp4 r2.z, r4, c26
dp4 r2.y, r4, c25
dp4 r2.x, r4, c24
add r2.xyz, r2, r3
add r2.xyz, r2, r0
mov r0.xyz, v1
add oT3.xyz, r2, r1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mov r0, c10
dp4 r3.z, c15, r0
mov r0, c8
dp4 r3.x, c15, r0
mul r2.xyz, r1, v1.w
mov r1, c9
dp4 r3.y, c15, r1
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c35.z
mul r1.y, r1, c12.x
mov oPos, r0
mad r0.xy, v4, c32, c32.zwzw
add r0.xy, r0, -v4
dp3 oT2.y, r3, r2
dp3 oT2.z, v2, r3
dp3 oT2.x, r3, v1
mad oT4.xy, r1.z, c13.zwzw, r1
mov oT4.zw, r0
mad oT0.zw, v3.xyxy, c34.xyxy, c34
mad oT0.xy, v3, c33, c33.zwzw
mad oT1.xy, r0, c31.x, v4
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightmapST;
uniform highp vec3 unity_LightColor3;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp float _deval;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  highp vec4 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (tmpvar_2 * unity_Scale.w));
  mat3 tmpvar_9;
  tmpvar_9[0] = tmpvar_1.xyz;
  tmpvar_9[1] = (cross (tmpvar_2, tmpvar_1.xyz) * tmpvar_1.w);
  tmpvar_9[2] = tmpvar_2;
  mat3 tmpvar_10;
  tmpvar_10[0].x = tmpvar_9[0].x;
  tmpvar_10[0].y = tmpvar_9[1].x;
  tmpvar_10[0].z = tmpvar_9[2].x;
  tmpvar_10[1].x = tmpvar_9[0].y;
  tmpvar_10[1].y = tmpvar_9[1].y;
  tmpvar_10[1].z = tmpvar_9[2].y;
  tmpvar_10[2].x = tmpvar_9[0].z;
  tmpvar_10[2].y = tmpvar_9[1].z;
  tmpvar_10[2].z = tmpvar_9[2].z;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_8;
  mediump vec3 tmpvar_13;
  mediump vec4 normal;
  normal = tmpvar_12;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal);
  x1.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal);
  x1.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal);
  x1.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC);
  x3 = tmpvar_22;
  tmpvar_13 = ((x1 + x2) + x3);
  shlight = tmpvar_13;
  tmpvar_5 = shlight;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosX0 - tmpvar_23.x);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosY0 - tmpvar_23.y);
  highp vec4 tmpvar_26;
  tmpvar_26 = (unity_4LightPosZ0 - tmpvar_23.z);
  highp vec4 tmpvar_27;
  tmpvar_27 = (((tmpvar_24 * tmpvar_24) + (tmpvar_25 * tmpvar_25)) + (tmpvar_26 * tmpvar_26));
  highp vec4 tmpvar_28;
  tmpvar_28 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_24 * tmpvar_8.x) + (tmpvar_25 * tmpvar_8.y)) + (tmpvar_26 * tmpvar_8.z)) * inversesqrt (tmpvar_27))) * 1.0/((1.0 + (tmpvar_27 * unity_4LightAtten0))));
  highp vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_5 + ((((unity_LightColor0 * tmpvar_28.x) + (unity_LightColor1 * tmpvar_28.y)) + (unity_LightColor2 * tmpvar_28.z)) + (unity_LightColor3 * tmpvar_28.w)));
  tmpvar_5 = tmpvar_29;
  highp vec4 o_i0_i1;
  highp vec4 tmpvar_30;
  tmpvar_30 = (tmpvar_6 * 0.5);
  o_i0_i1 = tmpvar_30;
  highp vec2 tmpvar_31;
  tmpvar_31.x = tmpvar_30.x;
  tmpvar_31.y = (tmpvar_30.y * _ProjectionParams.x);
  o_i0_i1.xy = (tmpvar_31 + tmpvar_30.w);
  o_i0_i1.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = mix (_glesMultiTexCoord1.xy, ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw), vec2(_deval));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = o_i0_i1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  highp vec2 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0.xy;
  highp vec2 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD0.zw;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, tmpvar_1);
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * _Color);
  c_i0 = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = c_i0.xyz;
  tmpvar_3 = tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_9 = ((texture2D (_BumpMap, tmpvar_2).xyz * 2.0) - 1.0);
  mediump vec3 tmpvar_10;
  mediump vec3 LMap;
  mediump vec3 CRNM;
  vec3 bumpBasis[3];
  bumpBasis[0] = vec3(0.816497, 0.0, 0.57735);
  bumpBasis[1] = vec3(-0.408248, 0.707107, 0.57735);
  bumpBasis[2] = vec3(-0.408248, -0.707107, 0.57735);
  lowp vec3 tmpvar_11;
  tmpvar_11 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz);
  CRNM = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD1).xyz);
  LMap = tmpvar_12;
  tmpvar_10 = ((vec3((((max (0.0, dot (bumpBasis[0], tmpvar_9)) * CRNM.x) + (max (0.0, dot (bumpBasis[1], tmpvar_9)) * CRNM.y)) + (max (0.0, dot (bumpBasis[2], tmpvar_9)) * CRNM.z))) * LMap) * tmpvar_3);
  tmpvar_4 = tmpvar_10;
  mediump float tmpvar_13;
  tmpvar_13 = c_i0.w;
  tmpvar_5 = tmpvar_13;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (tmpvar_9, xlv_TEXCOORD2)) * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x) * 2.0));
  c_i0_i1.w = tmpvar_5;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_3 * xlv_TEXCOORD3));
  c.xyz = (c.xyz + tmpvar_4);
  gl_FragData[0] = c;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 2
//   opengl - ALU: 33 to 35, TEX: 4 to 5
//   d3d9 - ALU: 33 to 34, TEX: 4 to 5
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 33 ALU, 4 TEX
PARAM c[5] = { program.local[0..1],
		{ 2, 1, 0, 8 },
		{ -0.40820312, -0.70703125, 0.57714844, 0.70703125 },
		{ 0.81640625, 0, 0.57714844 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[1], texture[3], 2D;
TEX R3.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
TEX R1, fragment.texcoord[1], texture[2], 2D;
TEX R2, fragment.texcoord[0], texture[0], 2D;
MAD R3.xy, R3.wyzw, c[2].x, -c[2].y;
MUL R3.z, R3.y, R3.y;
MAD R3.z, -R3.x, R3.x, -R3;
MUL R1.xyz, R1.w, R1;
ADD R3.z, R3, c[2].y;
RSQ R3.z, R3.z;
RCP R3.z, R3.z;
DP3 R3.w, R3, c[3].xwzw;
MAX R1.w, R3, c[2].z;
MUL R1.xyz, R1, c[2].w;
MUL R1.w, R1.y, R1;
DP3 R3.w, R3, c[4];
MAX R3.w, R3, c[2].z;
MUL R0.xyz, R0.w, R0;
DP3 R0.w, R3, fragment.texcoord[2];
MAD R1.w, R1.x, R3, R1;
DP3 R1.y, R3, c[3];
MAX R1.x, R1.y, c[2].z;
MAD R3.w, R1.x, R1.z, R1;
MUL R1, R2, c[1];
MUL R0.xyz, R0, R3.w;
MUL R2.xyz, R1, fragment.texcoord[3];
MUL R3.xyz, R1, c[0];
MAX R0.w, R0, c[2].z;
MUL R3.xyz, R0.w, R3;
MAD R2.xyz, R3, c[2].x, R2;
MUL R0.xyz, R0, R1;
MAD result.color.xyz, R0, c[2].w, R2;
MOV result.color.w, R1;
END
# 33 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"ps_2_0
; 33 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c2, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c3, -0.40820312, -0.70703125, 0.57714844, 8.00000000
def c4, 0.81640625, 0.00000000, 0.57714844, 0
def c5, -0.40820312, 0.70703125, 0.57714844, 0
dcl t0
dcl t1.xy
dcl t2.xyz
dcl t3.xyz
texld r3, t0, s0
texld r4, t1, s3
texld r5, t1, s2
mul_pp r5.xyz, r5.w, r5
mul_pp r5.xyz, r5, c3.w
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s1
mov r0.x, r0.w
mad_pp r6.xy, r0, c2.x, c2.y
mul_pp r0.x, r6.y, r6.y
mad_pp r0.x, -r6, r6, -r0
add_pp r0.x, r0, c2.z
rsq_pp r0.x, r0.x
rcp_pp r6.z, r0.x
dp3_pp r0.x, r6, c3
dp3_pp r1.x, r6, c4
dp3_pp r2.x, r6, c5
max_pp r2.x, r2, c2.w
mul_pp r2.x, r5.y, r2
max_pp r1.x, r1, c2.w
mad_pp r1.x, r5, r1, r2
mul r2, r3, c1
max_pp r0.x, r0, c2.w
mad_pp r0.x, r0, r5.z, r1
mul_pp r1.xyz, r4.w, r4
mul_pp r1.xyz, r1, r0.x
dp3_pp r0.x, r6, t2
mul_pp r1.xyz, r1, r2
mul_pp r3.xyz, r2, c0
max_pp r0.x, r0, c2.w
mul_pp r2.xyz, r2, t3
mul_pp r0.xyz, r0.x, r3
mad_pp r0.xyz, r0, c2.x, r2
mov_pp r0.w, r2
mad_pp r0.xyz, r1, c3.w, r0
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
SetTexture 4 [_ShadowMapTexture] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 35 ALU, 5 TEX
PARAM c[5] = { program.local[0..1],
		{ 2, 1, 0, 8 },
		{ -0.40820312, -0.70703125, 0.57714844, 0.70703125 },
		{ 0.81640625, 0, 0.57714844 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[1], texture[3], 2D;
TEX R1, fragment.texcoord[1], texture[2], 2D;
TEX R3.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
TEX R2, fragment.texcoord[0], texture[0], 2D;
TXP R4.x, fragment.texcoord[4], texture[4], 2D;
MAD R3.xy, R3.wyzw, c[2].x, -c[2].y;
MUL R3.z, R3.y, R3.y;
MAD R3.z, -R3.x, R3.x, -R3;
MUL R1.xyz, R1.w, R1;
ADD R3.z, R3, c[2].y;
RSQ R3.z, R3.z;
RCP R3.z, R3.z;
DP3 R3.w, R3, c[3].xwzw;
MUL R0.xyz, R0.w, R0;
DP3 R0.w, R3, fragment.texcoord[2];
MAX R0.w, R0, c[2].z;
MUL R1.xyz, R1, c[2].w;
MAX R1.w, R3, c[2].z;
MUL R3.w, R1.y, R1;
DP3 R1.w, R3, c[4];
MAX R1.w, R1, c[2].z;
MAD R1.w, R1.x, R1, R3;
DP3 R1.y, R3, c[3];
MAX R1.x, R1.y, c[2].z;
MAD R3.w, R1.x, R1.z, R1;
MUL R1, R2, c[1];
MUL R0.xyz, R0, R3.w;
MUL R2.xyz, R1, fragment.texcoord[3];
MUL R3.xyz, R1, c[0];
MUL R0.w, R0, R4.x;
MUL R3.xyz, R0.w, R3;
MAD R2.xyz, R3, c[2].x, R2;
MUL R0.xyz, R0, R1;
MAD result.color.xyz, R0, c[2].w, R2;
MOV result.color.w, R1;
END
# 35 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
SetTexture 4 [_ShadowMapTexture] 2D
"ps_2_0
; 34 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c2, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c3, -0.40820312, -0.70703125, 0.57714844, 8.00000000
def c4, 0.81640625, 0.00000000, 0.57714844, 0
def c5, -0.40820312, 0.70703125, 0.57714844, 0
dcl t0
dcl t1.xy
dcl t2.xyz
dcl t3.xyz
dcl t4
texldp r7, t4, s4
texld r4, t1, s3
texld r3, t0, s0
texld r5, t1, s2
mul_pp r5.xyz, r5.w, r5
mul_pp r5.xyz, r5, c3.w
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s1
mov r0.x, r0.w
mad_pp r6.xy, r0, c2.x, c2.y
mul_pp r0.x, r6.y, r6.y
mad_pp r0.x, -r6, r6, -r0
add_pp r0.x, r0, c2.z
rsq_pp r0.x, r0.x
rcp_pp r6.z, r0.x
dp3_pp r0.x, r6, c3
dp3_pp r1.x, r6, c4
dp3_pp r2.x, r6, c5
max_pp r2.x, r2, c2.w
mul_pp r2.x, r5.y, r2
max_pp r1.x, r1, c2.w
mad_pp r1.x, r5, r1, r2
max_pp r0.x, r0, c2.w
mad_pp r0.x, r0, r5.z, r1
mul r1, r3, c1
mul_pp r2.xyz, r4.w, r4
mul_pp r0.xyz, r2, r0.x
mul_pp r2.xyz, r0, r1
mul_pp r3.xyz, r1, c0
dp3_pp r0.x, r6, t2
max_pp r0.x, r0, c2.w
mul_pp r0.x, r0, r7
mul_pp r1.xyz, r1, t3
mul_pp r0.xyz, r0.x, r3
mad_pp r0.xyz, r0, c2.x, r1
mov_pp r0.w, r1
mad_pp r0.xyz, r2, c3.w, r0
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

}
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One Fog { Color (0,0,0,0) }
Program "vp" {
// Vertex combos: 5
//   opengl - ALU: 20 to 29
//   d3d9 - ALU: 23 to 32
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Float 19 [_deval]
Vector 20 [unity_LightmapST]
Vector 21 [_MainTex_ST]
Vector 22 [_BumpMap_ST]
"!!ARBvp1.0
# 28 ALU
PARAM c[23] = { program.local[0],
		state.matrix.mvp,
		program.local[5..22] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[18];
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[17].w, -vertex.position;
MUL R1.xyz, R1, vertex.attrib[14].w;
DP3 result.texcoord[2].y, R0, R1;
DP3 result.texcoord[2].z, vertex.normal, R0;
DP3 result.texcoord[2].x, R0, vertex.attrib[14];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 result.texcoord[3].z, R0, c[15];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MAD R0.xy, vertex.texcoord[1], c[20], c[20].zwzw;
ADD R0.xy, R0, -vertex.texcoord[1];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[22].xyxy, c[22];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[21], c[21].zwzw;
MAD result.texcoord[1].xy, R0, c[19].x, vertex.texcoord[1];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 28 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Float 18 [_deval]
Vector 19 [unity_LightmapST]
Vector 20 [_MainTex_ST]
Vector 21 [_BumpMap_ST]
"vs_2_0
; 31 ALU
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mov r0, c10
mul r2.xyz, r1, v1.w
dp4 r3.z, c17, r0
mov r0, c9
dp4 r3.y, c17, r0
mov r1, c8
dp4 r3.x, c17, r1
mad r0.xyz, r3, c16.w, -v0
dp3 oT2.y, r0, r2
dp3 oT2.z, v2, r0
dp3 oT2.x, r0, v1
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 oT3.z, r0, c14
dp4 oT3.y, r0, c13
dp4 oT3.x, r0, c12
mad r0.xy, v4, c19, c19.zwzw
add r0.xy, r0, -v4
mad oT0.zw, v3.xyxy, c21.xyxy, c21
mad oT0.xy, v3, c20, c20.zwzw
mad oT1.xy, r0, c18.x, v4
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp float _deval;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * tmpvar_1.w);
  tmpvar_5[2] = tmpvar_2;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = mix (_glesMultiTexCoord1.xy, ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw), vec2(_deval));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec2 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0.xy;
  highp vec2 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD0.zw;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_1);
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * _Color);
  c_i0 = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = c_i0.xyz;
  tmpvar_3 = tmpvar_7;
  mediump float tmpvar_8;
  tmpvar_8 = c_i0.w;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3));
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (((texture2D (_BumpMap, tmpvar_2).xyz * 2.0) - 1.0), lightDir)) * texture2D (_LightTexture0, tmpvar_10).w) * 2.0));
  c_i0_i1.w = tmpvar_4;
  c = c_i0_i1;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [_WorldSpaceLightPos0]
Matrix 5 [_World2Object]
Float 10 [_deval]
Vector 11 [unity_LightmapST]
Vector 12 [_MainTex_ST]
Vector 13 [_BumpMap_ST]
"!!ARBvp1.0
# 20 ALU
PARAM c[14] = { program.local[0],
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R1, c[9];
DP4 R2.z, R1, c[7];
DP4 R2.y, R1, c[6];
DP4 R2.x, R1, c[5];
MUL R0.xyz, R0, vertex.attrib[14].w;
DP3 result.texcoord[2].y, R2, R0;
MAD R0.xy, vertex.texcoord[1], c[11], c[11].zwzw;
ADD R0.xy, R0, -vertex.texcoord[1];
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, R2, vertex.attrib[14];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[13].xyxy, c[13];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[12], c[12].zwzw;
MAD result.texcoord[1].xy, R0, c[10].x, vertex.texcoord[1];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 20 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceLightPos0]
Matrix 4 [_World2Object]
Float 9 [_deval]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
Vector 12 [_BumpMap_ST]
"vs_2_0
; 23 ALU
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mov r0, c6
dp4 r3.z, c8, r0
mul r2.xyz, r1, v1.w
mov r0, c5
dp4 r3.y, c8, r0
mov r1, c4
dp4 r3.x, c8, r1
mad r0.xy, v4, c10, c10.zwzw
add r0.xy, r0, -v4
dp3 oT2.y, r3, r2
dp3 oT2.z, v2, r3
dp3 oT2.x, r3, v1
mad oT0.zw, v3.xyxy, c12.xyxy, c12
mad oT0.xy, v3, c11, c11.zwzw
mad oT1.xy, r0, c9.x, v4
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying mediump vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp float _deval;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * tmpvar_1.w);
  tmpvar_5[2] = tmpvar_2;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = mix (_glesMultiTexCoord1.xy, ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw), vec2(_deval));
  xlv_TEXCOORD2 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec2 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0.xy;
  highp vec2 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD0.zw;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_1);
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * _Color);
  c_i0 = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = c_i0.xyz;
  tmpvar_3 = tmpvar_7;
  mediump float tmpvar_8;
  tmpvar_8 = c_i0.w;
  tmpvar_4 = tmpvar_8;
  lightDir = xlv_TEXCOORD2;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_3 * _LightColor0.xyz) * (max (0.0, dot (((texture2D (_BumpMap, tmpvar_2).xyz * 2.0) - 1.0), lightDir)) * 2.0));
  c_i0_i1.w = tmpvar_4;
  c = c_i0_i1;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Float 19 [_deval]
Vector 20 [unity_LightmapST]
Vector 21 [_MainTex_ST]
Vector 22 [_BumpMap_ST]
"!!ARBvp1.0
# 29 ALU
PARAM c[23] = { program.local[0],
		state.matrix.mvp,
		program.local[5..22] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[18];
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[17].w, -vertex.position;
MUL R1.xyz, R1, vertex.attrib[14].w;
DP4 R0.w, vertex.position, c[8];
DP3 result.texcoord[2].y, R0, R1;
DP3 result.texcoord[2].z, vertex.normal, R0;
DP3 result.texcoord[2].x, R0, vertex.attrib[14];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.z, vertex.position, c[7];
DP4 result.texcoord[3].w, R0, c[16];
DP4 result.texcoord[3].z, R0, c[15];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MAD R0.xy, vertex.texcoord[1], c[20], c[20].zwzw;
ADD R0.xy, R0, -vertex.texcoord[1];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[22].xyxy, c[22];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[21], c[21].zwzw;
MAD result.texcoord[1].xy, R0, c[19].x, vertex.texcoord[1];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 29 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Float 18 [_deval]
Vector 19 [unity_LightmapST]
Vector 20 [_MainTex_ST]
Vector 21 [_BumpMap_ST]
"vs_2_0
; 32 ALU
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mov r0, c10
mul r2.xyz, r1, v1.w
dp4 r3.z, c17, r0
mov r0, c9
dp4 r3.y, c17, r0
mov r1, c8
dp4 r3.x, c17, r1
mad r0.xyz, r3, c16.w, -v0
dp4 r0.w, v0, c7
dp3 oT2.y, r0, r2
dp3 oT2.z, v2, r0
dp3 oT2.x, r0, v1
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.z, v0, c6
dp4 oT3.w, r0, c15
dp4 oT3.z, r0, c14
dp4 oT3.y, r0, c13
dp4 oT3.x, r0, c12
mad r0.xy, v4, c19, c19.zwzw
add r0.xy, r0, -v4
mad oT0.zw, v3.xyxy, c21.xyxy, c21
mad oT0.xy, v3, c20, c20.zwzw
mad oT1.xy, r0, c18.x, v4
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp float _deval;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * tmpvar_1.w);
  tmpvar_5[2] = tmpvar_2;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = mix (_glesMultiTexCoord1.xy, ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw), vec2(_deval));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec2 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0.xy;
  highp vec2 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD0.zw;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_1);
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * _Color);
  c_i0 = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = c_i0.xyz;
  tmpvar_3 = tmpvar_7;
  mediump float tmpvar_8;
  tmpvar_8 = c_i0.w;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_9;
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD3.xyz;
  highp vec2 tmpvar_10;
  tmpvar_10 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp float atten;
  atten = ((float((xlv_TEXCOORD3.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5)).w) * texture2D (_LightTextureB0, tmpvar_10).w);
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (((texture2D (_BumpMap, tmpvar_2).xyz * 2.0) - 1.0), lightDir)) * atten) * 2.0));
  c_i0_i1.w = tmpvar_4;
  c = c_i0_i1;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Float 19 [_deval]
Vector 20 [unity_LightmapST]
Vector 21 [_MainTex_ST]
Vector 22 [_BumpMap_ST]
"!!ARBvp1.0
# 28 ALU
PARAM c[23] = { program.local[0],
		state.matrix.mvp,
		program.local[5..22] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[18];
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[17].w, -vertex.position;
MUL R1.xyz, R1, vertex.attrib[14].w;
DP3 result.texcoord[2].y, R0, R1;
DP3 result.texcoord[2].z, vertex.normal, R0;
DP3 result.texcoord[2].x, R0, vertex.attrib[14];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 result.texcoord[3].z, R0, c[15];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MAD R0.xy, vertex.texcoord[1], c[20], c[20].zwzw;
ADD R0.xy, R0, -vertex.texcoord[1];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[22].xyxy, c[22];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[21], c[21].zwzw;
MAD result.texcoord[1].xy, R0, c[19].x, vertex.texcoord[1];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 28 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Float 18 [_deval]
Vector 19 [unity_LightmapST]
Vector 20 [_MainTex_ST]
Vector 21 [_BumpMap_ST]
"vs_2_0
; 31 ALU
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mov r0, c10
mul r2.xyz, r1, v1.w
dp4 r3.z, c17, r0
mov r0, c9
dp4 r3.y, c17, r0
mov r1, c8
dp4 r3.x, c17, r1
mad r0.xyz, r3, c16.w, -v0
dp3 oT2.y, r0, r2
dp3 oT2.z, v2, r0
dp3 oT2.x, r0, v1
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 oT3.z, r0, c14
dp4 oT3.y, r0, c13
dp4 oT3.x, r0, c12
mad r0.xy, v4, c19, c19.zwzw
add r0.xy, r0, -v4
mad oT0.zw, v3.xyxy, c21.xyxy, c21
mad oT0.xy, v3, c20, c20.zwzw
mad oT1.xy, r0, c18.x, v4
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp float _deval;
uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * tmpvar_1.w);
  tmpvar_5[2] = tmpvar_2;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = mix (_glesMultiTexCoord1.xy, ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw), vec2(_deval));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec2 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0.xy;
  highp vec2 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD0.zw;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_1);
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * _Color);
  c_i0 = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = c_i0.xyz;
  tmpvar_3 = tmpvar_7;
  mediump float tmpvar_8;
  tmpvar_8 = c_i0.w;
  tmpvar_4 = tmpvar_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3));
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (((texture2D (_BumpMap, tmpvar_2).xyz * 2.0) - 1.0), lightDir)) * (texture2D (_LightTextureB0, tmpvar_10).w * textureCube (_LightTexture0, xlv_TEXCOORD3).w)) * 2.0));
  c_i0_i1.w = tmpvar_4;
  c = c_i0_i1;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 17 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Float 18 [_deval]
Vector 19 [unity_LightmapST]
Vector 20 [_MainTex_ST]
Vector 21 [_BumpMap_ST]
"!!ARBvp1.0
# 26 ALU
PARAM c[22] = { program.local[0],
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R1, c[17];
MUL R0.xyz, R0, vertex.attrib[14].w;
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
DP3 result.texcoord[2].y, R2, R0;
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MAD R0.xy, vertex.texcoord[1], c[19], c[19].zwzw;
ADD R0.xy, R0, -vertex.texcoord[1];
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, R2, vertex.attrib[14];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
MAD result.texcoord[1].xy, R0, c[18].x, vertex.texcoord[1];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 26 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 16 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Float 17 [_deval]
Vector 18 [unity_LightmapST]
Vector 19 [_MainTex_ST]
Vector 20 [_BumpMap_ST]
"vs_2_0
; 29 ALU
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mov r0, c10
dp4 r3.z, c16, r0
mov r0, c9
dp4 r3.y, c16, r0
mul r2.xyz, r1, v1.w
mov r1, c8
dp4 r3.x, c16, r1
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 oT3.y, r0, c13
dp4 oT3.x, r0, c12
mad r0.xy, v4, c18, c18.zwzw
add r0.xy, r0, -v4
dp3 oT2.y, r3, r2
dp3 oT2.z, v2, r3
dp3 oT2.x, r3, v1
mad oT0.zw, v3.xyxy, c20.xyxy, c20
mad oT0.xy, v3, c19, c19.zwzw
mad oT1.xy, r0, c17.x, v4
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp float _deval;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = tmpvar_1.xyz;
  tmpvar_5[1] = (cross (tmpvar_2, tmpvar_1.xyz) * tmpvar_1.w);
  tmpvar_5[2] = tmpvar_2;
  mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_5[0].x;
  tmpvar_6[0].y = tmpvar_5[1].x;
  tmpvar_6[0].z = tmpvar_5[2].x;
  tmpvar_6[1].x = tmpvar_5[0].y;
  tmpvar_6[1].y = tmpvar_5[1].y;
  tmpvar_6[1].z = tmpvar_5[2].y;
  tmpvar_6[2].x = tmpvar_5[0].z;
  tmpvar_6[2].y = tmpvar_5[1].z;
  tmpvar_6[2].z = tmpvar_5[2].z;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = mix (_glesMultiTexCoord1.xy, ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw), vec2(_deval));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec2 tmpvar_1;
  tmpvar_1 = xlv_TEXCOORD0.xy;
  highp vec2 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD0.zw;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 c_i0;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, tmpvar_1);
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * _Color);
  c_i0 = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = c_i0.xyz;
  tmpvar_3 = tmpvar_7;
  mediump float tmpvar_8;
  tmpvar_8 = c_i0.w;
  tmpvar_4 = tmpvar_8;
  lightDir = xlv_TEXCOORD2;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (((texture2D (_BumpMap, tmpvar_2).xyz * 2.0) - 1.0), lightDir)) * texture2D (_LightTexture0, xlv_TEXCOORD3).w) * 2.0));
  c_i0_i1.w = tmpvar_4;
  c = c_i0_i1;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 15 to 27, TEX: 2 to 4
//   d3d9 - ALU: 17 to 30, TEX: 2 to 4
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 21 ALU, 3 TEX
PARAM c[3] = { program.local[0..1],
		{ 0, 2, 1 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R1.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
MAD R1.xy, R1.wyzw, c[2].y, -c[2].z;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
DP3 R0.w, fragment.texcoord[3], fragment.texcoord[3];
DP3 R1.w, fragment.texcoord[2], fragment.texcoord[2];
ADD R1.z, R1, c[2];
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R2.xyz, R1.w, fragment.texcoord[2];
RCP R1.z, R1.z;
DP3 R1.x, R1, R2;
MUL R2.xyz, R0, c[1];
MAX R0.x, R1, c[2];
MUL R1.xyz, R2, c[0];
MOV result.color.w, c[2].x;
TEX R0.w, R0.w, texture[3], 2D;
MUL R0.x, R0, R0.w;
MUL R0.xyz, R0.x, R1;
MUL result.color.xyz, R0, c[2].y;
END
# 21 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
"ps_2_0
; 23 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c2, 2.00000000, -1.00000000, 1.00000000, 0.00000000
dcl t0
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
dp3 r0.x, t3, t3
mov r1.xy, r0.x
mov r0.y, t0.w
mov r0.x, t0.z
texld r4, r1, s3
texld r0, r0, s1
mov r0.x, r0.w
mad_pp r3.xy, r0, c2.x, c2.y
mul_pp r0.x, r3.y, r3.y
mad_pp r0.x, -r3, r3, -r0
dp3_pp r1.x, t2, t2
add_pp r0.x, r0, c2.z
rsq_pp r0.x, r0.x
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t2
rcp_pp r3.z, r0.x
dp3_pp r0.x, r3, r1
mul r1.xyz, r2, c1
max_pp r0.x, r0, c2.w
mul_pp r1.xyz, r1, c0
mul_pp r0.x, r0, r4
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c2.x
mov_pp r0.w, c2
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 15 ALU, 2 TEX
PARAM c[3] = { program.local[0..1],
		{ 0, 2, 1 } };
TEMP R0;
TEMP R1;
TEX R1.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
MAD R1.xy, R1.wyzw, c[2].y, -c[2].z;
MUL R0.w, R1.y, R1.y;
MAD R0.w, -R1.x, R1.x, -R0;
ADD R0.w, R0, c[2].z;
RSQ R0.w, R0.w;
RCP R1.z, R0.w;
MUL R0.xyz, R0, c[1];
DP3 R0.w, R1, fragment.texcoord[2];
MUL R1.xyz, R0, c[0];
MAX R0.x, R0.w, c[2];
MUL R0.xyz, R0.x, R1;
MUL result.color.xyz, R0, c[2].y;
MOV result.color.w, c[2].x;
END
# 15 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
"ps_2_0
; 17 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c2, 2.00000000, -1.00000000, 1.00000000, 0.00000000
dcl t0
dcl t2.xyz
texld r1, t0, s0
mul r1.xyz, r1, c1
mov r0.y, t0.w
mov r0.x, t0.z
mul_pp r1.xyz, r1, c0
texld r0, r0, s1
mov r0.x, r0.w
mad_pp r2.xy, r0, c2.x, c2.y
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c2.z
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
dp3_pp r0.x, r2, t2
max_pp r0.x, r0, c2.w
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c2.x
mov_pp r0.w, c2
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
SetTexture 4 [_LightTextureB0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 27 ALU, 4 TEX
PARAM c[3] = { program.local[0..1],
		{ 0, 2, 1, 0.5 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R2.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
RCP R0.x, fragment.texcoord[3].w;
MAD R1.xy, fragment.texcoord[3], R0.x, c[2].w;
DP3 R1.z, fragment.texcoord[3], fragment.texcoord[3];
DP3 R2.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R2.x, R2.x;
MOV result.color.w, c[2].x;
TEX R0.w, R1, texture[3], 2D;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
TEX R1.w, R1.z, texture[4], 2D;
MAD R1.xy, R2.wyzw, c[2].y, -c[2].z;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
ADD R1.z, R1, c[2];
RSQ R1.z, R1.z;
MUL R0.xyz, R0, c[1];
MUL R2.xyz, R2.x, fragment.texcoord[2];
RCP R1.z, R1.z;
DP3 R1.x, R1, R2;
SLT R1.y, c[2].x, fragment.texcoord[3].z;
MUL R0.w, R1.y, R0;
MUL R2.xyz, R0, c[0];
MAX R1.x, R1, c[2];
MUL R0.w, R0, R1;
MUL R0.x, R1, R0.w;
MUL R0.xyz, R0.x, R2;
MUL result.color.xyz, R0, c[2].y;
END
# 27 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
SetTexture 4 [_LightTextureB0] 2D
"ps_2_0
; 30 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c2, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c3, 0.50000000, 0, 0, 0
dcl t0
dcl t2.xyz
dcl t3
rcp r2.x, t3.w
mad r3.xy, t3, r2.x, c3.x
mov r0.y, t0.w
mov r0.x, t0.z
mov r1.xy, r0
dp3 r0.x, t3, t3
mov r2.xy, r0.x
texld r4, r2, s4
texld r1, r1, s1
texld r2, t0, s0
texld r0, r3, s3
dp3_pp r1.x, t2, t2
mul r2.xyz, r2, c1
mov r0.y, r1
mov r0.x, r1.w
mad_pp r3.xy, r0, c2.x, c2.y
mul_pp r0.x, r3.y, r3.y
mad_pp r0.x, -r3, r3, -r0
add_pp r0.x, r0, c2.z
rsq_pp r0.x, r0.x
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t2
rcp_pp r3.z, r0.x
dp3_pp r0.x, r3, r1
max_pp r0.x, r0, c2.w
cmp r1.x, -t3.z, c2.w, c2.z
mul_pp r1.x, r1, r0.w
mul_pp r1.x, r1, r4
mul_pp r2.xyz, r2, c0
mul_pp r0.x, r0, r1
mul_pp r0.xyz, r0.x, r2
mul_pp r0.xyz, r0, c2.x
mov_pp r0.w, c2
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 3 [_LightTextureB0] 2D
SetTexture 4 [_LightTexture0] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 23 ALU, 4 TEX
PARAM c[3] = { program.local[0..1],
		{ 0, 2, 1 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R2.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
TEX R1.w, fragment.texcoord[3], texture[4], CUBE;
MAD R1.xy, R2.wyzw, c[2].y, -c[2].z;
DP3 R0.w, fragment.texcoord[3], fragment.texcoord[3];
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
DP3 R2.x, fragment.texcoord[2], fragment.texcoord[2];
ADD R1.z, R1, c[2];
RSQ R2.x, R2.x;
RSQ R1.z, R1.z;
MUL R0.xyz, R0, c[1];
MUL R2.xyz, R2.x, fragment.texcoord[2];
RCP R1.z, R1.z;
DP3 R1.x, R1, R2;
MUL R2.xyz, R0, c[0];
MAX R1.x, R1, c[2];
MOV result.color.w, c[2].x;
TEX R0.w, R0.w, texture[3], 2D;
MUL R0.w, R0, R1;
MUL R0.x, R1, R0.w;
MUL R0.xyz, R0.x, R2;
MUL result.color.xyz, R0, c[2].y;
END
# 23 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 3 [_LightTextureB0] 2D
SetTexture 4 [_LightTexture0] CUBE
"ps_2_0
; 25 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c2, 2.00000000, -1.00000000, 1.00000000, 0.00000000
dcl t0
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
dp3 r0.x, t3, t3
mov r0.xy, r0.x
mul r2.xyz, r2, c1
mov r1.y, t0.w
mov r1.x, t0.z
mul_pp r2.xyz, r2, c0
texld r4, r0, s3
texld r1, r1, s1
texld r0, t3, s4
dp3_pp r1.x, t2, t2
mov r0.y, r1
mov r0.x, r1.w
mad_pp r3.xy, r0, c2.x, c2.y
mul_pp r0.x, r3.y, r3.y
mad_pp r0.x, -r3, r3, -r0
add_pp r0.x, r0, c2.z
rsq_pp r0.x, r0.x
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t2
rcp_pp r3.z, r0.x
dp3_pp r0.x, r3, r1
max_pp r0.x, r0, c2.w
mul r1.x, r4, r0.w
mul_pp r0.x, r0, r1
mul_pp r0.xyz, r0.x, r2
mul_pp r0.xyz, r0, c2.x
mov_pp r0.w, c2
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 17 ALU, 3 TEX
PARAM c[3] = { program.local[0..1],
		{ 0, 2, 1 } };
TEMP R0;
TEMP R1;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
TEX R1.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
TEX R0.w, fragment.texcoord[3], texture[3], 2D;
MAD R1.xy, R1.wyzw, c[2].y, -c[2].z;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
ADD R1.z, R1, c[2];
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
MUL R0.xyz, R0, c[1];
DP3 R1.x, R1, fragment.texcoord[2];
MAX R1.x, R1, c[2];
MUL R0.xyz, R0, c[0];
MUL R0.w, R1.x, R0;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[2].y;
MOV result.color.w, c[2].x;
END
# 17 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
"ps_2_0
; 20 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c2, 2.00000000, -1.00000000, 1.00000000, 0.00000000
dcl t0
dcl t2.xyz
dcl t3.xy
mov r0.y, t0.w
mov r0.x, t0.z
mov r1.xy, r0
texld r2, r1, s1
texld r1, t0, s0
texld r0, t3, s3
mul r1.xyz, r1, c1
mov r0.y, r2
mov r0.x, r2.w
mad_pp r2.xy, r0, c2.x, c2.y
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c2.z
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
dp3_pp r0.x, r2, t2
max_pp r0.x, r0, c2.w
mul_pp r0.x, r0, r0.w
mul_pp r1.xyz, r1, c0
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c2.x
mov_pp r0.w, c2
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

}
	}
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassBase" }
		Fog {Mode Off}
Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 24 to 24
//   d3d9 - ALU: 25 to 25
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [unity_Scale]
Matrix 5 [_Object2World]
Float 10 [_deval]
Vector 11 [unity_LightmapST]
Vector 12 [_BumpMap_ST]
"!!ARBvp1.0
# 24 ALU
PARAM c[13] = { program.local[0],
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
TEMP R1;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R1.xyz, R0, vertex.attrib[14].w;
DP3 R0.y, R1, c[5];
DP3 R0.x, vertex.attrib[14], c[5];
DP3 R0.z, vertex.normal, c[5];
MUL result.texcoord[2].xyz, R0, c[9].w;
DP3 R0.y, R1, c[6];
DP3 R0.x, vertex.attrib[14], c[6];
DP3 R0.z, vertex.normal, c[6];
MUL result.texcoord[3].xyz, R0, c[9].w;
DP3 R0.y, R1, c[7];
DP3 R0.x, vertex.attrib[14], c[7];
DP3 R0.z, vertex.normal, c[7];
MAD R1.xy, vertex.texcoord[1], c[11], c[11].zwzw;
MUL result.texcoord[4].xyz, R0, c[9].w;
ADD R0.xy, R1, -vertex.texcoord[1];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[12], c[12].zwzw;
MAD result.texcoord[1].xy, R0, c[10].x, vertex.texcoord[1];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 24 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Matrix 4 [_Object2World]
Float 9 [_deval]
Vector 10 [unity_LightmapST]
Vector 11 [_BumpMap_ST]
"vs_2_0
; 25 ALU
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r1.xyz, r0, v1.w
dp3 r0.y, r1, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul oT2.xyz, r0, c8.w
dp3 r0.y, r1, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul oT3.xyz, r0, c8.w
dp3 r0.y, r1, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mad r1.xy, v4, c10, c10.zwzw
mul oT4.xyz, r0, c8.w
add r0.xy, r1, -v4
mad oT0.xy, v3, c11, c11.zwzw
mad oT1.xy, r0, c9.x, v4
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp float _deval;
uniform highp mat4 _Object2World;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mat3 tmpvar_3;
  tmpvar_3[0] = tmpvar_1.xyz;
  tmpvar_3[1] = (cross (tmpvar_2, tmpvar_1.xyz) * tmpvar_1.w);
  tmpvar_3[2] = tmpvar_2;
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_3[0].x;
  tmpvar_4[0].y = tmpvar_3[1].x;
  tmpvar_4[0].z = tmpvar_3[2].x;
  tmpvar_4[1].x = tmpvar_3[0].y;
  tmpvar_4[1].y = tmpvar_3[1].y;
  tmpvar_4[1].z = tmpvar_3[2].y;
  tmpvar_4[2].x = tmpvar_3[0].z;
  tmpvar_4[2].y = tmpvar_3[1].z;
  tmpvar_4[2].z = tmpvar_3[2].z;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  vec3 v_i0_i1;
  v_i0_i1.x = tmpvar_5[0].x;
  v_i0_i1.y = tmpvar_5[1].x;
  v_i0_i1.z = tmpvar_5[2].x;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2;
  v_i0_i1_i2.x = tmpvar_6[0].y;
  v_i0_i1_i2.y = tmpvar_6[1].y;
  v_i0_i1_i2.z = tmpvar_6[2].y;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  vec3 v_i0_i1_i2_i3;
  v_i0_i1_i2_i3.x = tmpvar_7[0].z;
  v_i0_i1_i2_i3.y = tmpvar_7[1].z;
  v_i0_i1_i2_i3.z = tmpvar_7[2].z;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  xlv_TEXCOORD1 = mix (_glesMultiTexCoord1.xy, ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw), vec2(_deval));
  xlv_TEXCOORD2 = ((tmpvar_4 * v_i0_i1) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_4 * v_i0_i1_i2) * unity_Scale.w);
  xlv_TEXCOORD4 = ((tmpvar_4 * v_i0_i1_i2_i3) * unity_Scale.w);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 res;
  lowp vec3 worldN;
  lowp vec3 tmpvar_1;
  tmpvar_1 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  highp float tmpvar_2;
  tmpvar_2 = dot (xlv_TEXCOORD2, tmpvar_1);
  worldN.x = tmpvar_2;
  highp float tmpvar_3;
  tmpvar_3 = dot (xlv_TEXCOORD3, tmpvar_1);
  worldN.y = tmpvar_3;
  highp float tmpvar_4;
  tmpvar_4 = dot (xlv_TEXCOORD4, tmpvar_1);
  worldN.z = tmpvar_4;
  res.xyz = ((worldN * 0.5) + 0.5);
  res.w = 0.0;
  gl_FragData[0] = res;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 12 to 12, TEX: 1 to 1
//   d3d9 - ALU: 13 to 13, TEX: 1 to 1
SubProgram "opengl " {
Keywords { }
SetTexture 0 [_BumpMap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 12 ALU, 1 TEX
PARAM c[1] = { { 0, 2, 1, 0.5 } };
TEMP R0;
TEMP R1;
TEX R0.yw, fragment.texcoord[0], texture[0], 2D;
MAD R0.xy, R0.wyzw, c[0].y, -c[0].z;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.z, R0, c[0];
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R1.z, fragment.texcoord[4], R0;
DP3 R1.x, R0, fragment.texcoord[2];
DP3 R1.y, R0, fragment.texcoord[3];
MAD result.color.xyz, R1, c[0].w, c[0].w;
MOV result.color.w, c[0].x;
END
# 12 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
SetTexture 0 [_BumpMap] 2D
"ps_2_0
; 13 ALU, 1 TEX
dcl_2d s0
dcl_2d s1
def c0, 2.00000000, -1.00000000, 1.00000000, 0.50000000
def c1, 0.00000000, 0, 0, 0
dcl t0.xy
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
texld r0, t0, s0
mov r0.x, r0.w
mad_pp r1.xy, r0, c0.x, c0.y
mul_pp r0.x, r1.y, r1.y
mad_pp r0.x, -r1, r1, -r0
add_pp r0.x, r0, c0.z
rsq_pp r0.x, r0.x
rcp_pp r1.z, r0.x
dp3 r0.z, t4, r1
dp3 r0.x, r1, t2
dp3 r0.y, r1, t3
mad_pp r0.xyz, r0, c0.w, c0.w
mov_pp r0.w, c1.x
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}
	}
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassFinal" }
		ZWrite Off
Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 14 to 14
//   d3d9 - ALU: 14 to 14
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 5 [_ProjectionParams]
Float 6 [_deval]
Vector 7 [unity_LightmapST]
Vector 8 [_MainTex_ST]
Vector 9 [_BumpMap_ST]
"!!ARBvp1.0
# 14 ALU
PARAM c[10] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..9] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[5].x;
MOV result.position, R0;
MAD R0.xy, vertex.texcoord[1], c[7], c[7].zwzw;
ADD R0.xy, R0, -vertex.texcoord[1];
ADD result.texcoord[2].xy, R1, R1.z;
MOV result.texcoord[2].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[9].xyxy, c[9];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[8], c[8].zwzw;
MAD result.texcoord[1].xy, R0, c[6].x, vertex.texcoord[1];
END
# 14 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_ProjectionParams]
Vector 5 [_ScreenParams]
Float 6 [_deval]
Vector 7 [unity_LightmapST]
Vector 8 [_MainTex_ST]
Vector 9 [_BumpMap_ST]
"vs_2_0
; 14 ALU
def c10, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_texcoord1 v2
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c10.x
mul r1.y, r1, c4.x
mov oPos, r0
mad r0.xy, v2, c7, c7.zwzw
add r0.xy, r0, -v2
mad oT2.xy, r1.z, c5.zwzw, r1
mov oT2.zw, r0
mad oT0.zw, v1.xyxy, c9.xyxy, c9
mad oT0.xy, v1, c8, c8.zwzw
mad oT1.xy, r0, c6.x, v2
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp float _deval;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 o_i0_i1;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0_i1 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0_i1.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0_i1.zw = tmpvar_2.zw;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = mix (_glesMultiTexCoord1.xy, ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw), vec2(_deval));
  xlv_TEXCOORD2 = o_i0_i1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 unity_Ambient;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform highp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 col;
  mediump vec4 light;
  highp vec2 tmpvar_2;
  tmpvar_2 = xlv_TEXCOORD0.xy;
  highp vec2 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD0.zw;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp float tmpvar_6;
  mediump vec4 c;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, tmpvar_2);
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * _Color);
  c = tmpvar_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = c.xyz;
  tmpvar_4 = tmpvar_9;
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((texture2D (_BumpMap, tmpvar_3).xyz * 2.0) - 1.0);
  mediump vec3 tmpvar_11;
  mediump vec3 LMap;
  mediump vec3 CRNM;
  vec3 bumpBasis[3];
  bumpBasis[0] = vec3(0.816497, 0.0, 0.57735);
  bumpBasis[1] = vec3(-0.408248, 0.707107, 0.57735);
  bumpBasis[2] = vec3(-0.408248, -0.707107, 0.57735);
  lowp vec3 tmpvar_12;
  tmpvar_12 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz);
  CRNM = tmpvar_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD1).xyz);
  LMap = tmpvar_13;
  tmpvar_11 = ((vec3((((max (0.0, dot (bumpBasis[0], tmpvar_10)) * CRNM.x) + (max (0.0, dot (bumpBasis[1], tmpvar_10)) * CRNM.y)) + (max (0.0, dot (bumpBasis[2], tmpvar_10)) * CRNM.z))) * LMap) * tmpvar_4);
  tmpvar_5 = tmpvar_11;
  mediump float tmpvar_14;
  tmpvar_14 = c.w;
  tmpvar_6 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light = tmpvar_15;
  mediump vec4 tmpvar_16;
  tmpvar_16 = -(log2 (max (light, vec4(0.001, 0.001, 0.001, 0.001))));
  light = tmpvar_16;
  light.xyz = (tmpvar_16.xyz + unity_Ambient.xyz);
  lowp vec4 c_i0;
  mediump vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_4 * light.xyz);
  c_i0.xyz = tmpvar_17;
  c_i0.w = tmpvar_6;
  col = c_i0;
  col.xyz = (col.xyz + tmpvar_5);
  tmpvar_1 = col;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 33 to 33, TEX: 5 to 5
//   d3d9 - ALU: 32 to 32, TEX: 5 to 5
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" }
Vector 0 [_Color]
Vector 1 [unity_Ambient]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
SetTexture 4 [_LightBuffer] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 33 ALU, 5 TEX
PARAM c[5] = { program.local[0..1],
		{ 2, 1, 0, 8 },
		{ -0.40820312, -0.70703125, 0.57714844, 0.70703125 },
		{ 0.81640625, 0, 0.57714844 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R2, fragment.texcoord[1], texture[2], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1, fragment.texcoord[1], texture[3], 2D;
TEX R4.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
TXP R3.xyz, fragment.texcoord[2], texture[4], 2D;
MAD R4.xy, R4.wyzw, c[2].x, -c[2].y;
MUL R0, R0, c[0];
MUL R2.xyz, R2.w, R2;
MUL R3.w, R4.y, R4.y;
MAD R3.w, -R4.x, R4.x, -R3;
ADD R3.w, R3, c[2].y;
RSQ R3.w, R3.w;
RCP R4.z, R3.w;
DP3 R3.w, R4, c[3].xwzw;
MUL R2.xyz, R2, c[2].w;
MAX R2.w, R3, c[2].z;
MUL R3.w, R2.y, R2;
DP3 R2.w, R4, c[4];
MAX R2.w, R2, c[2].z;
DP3 R2.y, R4, c[3];
MAD R2.w, R2.x, R2, R3;
MAX R2.x, R2.y, c[2].z;
MAD R2.x, R2, R2.z, R2.w;
MUL R1.xyz, R1.w, R1;
MUL R1.xyz, R1, R2.x;
MUL R1.xyz, R0, R1;
MUL R1.xyz, R1, c[2].w;
LG2 R2.x, R3.x;
LG2 R2.z, R3.z;
LG2 R2.y, R3.y;
ADD R2.xyz, -R2, c[1];
MAD result.color.xyz, R0, R2, R1;
MOV result.color.w, R0;
END
# 33 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" }
Vector 0 [_Color]
Vector 1 [unity_Ambient]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
SetTexture 4 [_LightBuffer] 2D
"ps_2_0
; 32 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c2, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c3, -0.40820312, -0.70703125, 0.57714844, 8.00000000
def c4, 0.81640625, 0.00000000, 0.57714844, 0
def c5, -0.40820312, 0.70703125, 0.57714844, 0
dcl t0
dcl t1.xy
dcl t2
texldp r6, t2, s4
texld r4, t0, s0
texld r3, t1, s3
texld r5, t1, s2
mul_pp r5.xyz, r5.w, r5
mul_pp r5.xyz, r5, c3.w
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s1
mov r0.x, r0.w
mad_pp r2.xy, r0, c2.x, c2.y
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c2.z
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
dp3_pp r0.x, r2, c3
dp3_pp r1.x, r2, c4
dp3_pp r2.x, r2, c5
max_pp r2.x, r2, c2.w
mul_pp r2.x, r5.y, r2
max_pp r1.x, r1, c2.w
mad_pp r1.x, r5, r1, r2
max_pp r0.x, r0, c2.w
mad_pp r0.x, r0, r5.z, r1
mul_pp r1.xyz, r3.w, r3
mul_pp r0.xyz, r1, r0.x
mul r1, r4, c0
mul_pp r0.xyz, r1, r0
mul_pp r0.xyz, r0, c3.w
log_pp r2.x, r6.x
log_pp r2.z, r6.z
log_pp r2.y, r6.y
add_pp r2.xyz, -r2, c1
mov_pp r0.w, r1
mad_pp r0.xyz, r1, r2, r0
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" }
"!!GLES"
}

}
	}

#LINE 70

	} 
	FallBack "Diffuse"
}
