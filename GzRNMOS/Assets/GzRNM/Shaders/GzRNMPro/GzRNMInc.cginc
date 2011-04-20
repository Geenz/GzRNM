#define RNMBASIS \
		const half3 bumpBasis[3] = {\
			half3(0.816496580927726, 0.0, 0.5773502691896258),\
			half3(-0.408248290463863, 0.7071067811865475, 0.5773502691896258),\
			half3(-0.408248290463863, -0.7071067811865475, 0.5773502691896258)\
		};

#define RNMDECODE \
		half3 RNMX = DecodeLightmap(tex2D(unity_Lightmap, IN.lmapUV)); \
		half3 RNMY = DecodeLightmap(tex2D(unity_LightmapInd, IN.lmapUV)); \
		half3 RNMZ = DecodeLightmap(tex2D(unity_LightmapC, IN.lmapUV));

#define RNMCOMPUTE \
		light = max(0, dot(bumpBasis[0], o.Normal)) * RNMX + \
				max(0, dot(bumpBasis[1], o.Normal)) * RNMY + \
				max(0, dot(bumpBasis[2], o.Normal)) * RNMZ;

#define RNMSPECBASIS \
		const half3 specBasis[3] = { \
			normalize(spec + bumpBasis[0]), \
			normalize(spec + bumpBasis[1]), \
			normalize(spec + bumpBasis[2]) \
		}; \
		float nh[3] = { \
			max(0, dot(o.Normal, specBasis[0])), \
			max(0, dot(o.Normal, specBasis[1])), \
			max(0, dot(o.Normal, specBasis[2])) \
		};
#define RNMSPECCOMPUTE \
		spec =	pow(nh[0], o.Specular*128.0) * RNMX + \
				pow(nh[1], o.Specular*128.0) * RNMY + \
				pow(nh[2], o.Specular*128.0) * RNMZ; \
		spec *= o.Gloss;

#define SSBUMPRNMSPECCOMPUTE \
		spec =	pow(nh[0], o.Specular*128.0) * RNMX * o.SSBump.x + \
				pow(nh[1], o.Specular*128.0) * RNMY * o.SSBump.z + \
				pow(nh[2], o.Specular*128.0) * RNMZ * o.SSBump.y;
#define SSBUMPCRNMSPECCOMPUTE \
		spec =	pow(nh[0], o.Specular*128.0) * CRNM.x * o.SSBump.x + \
				pow(nh[1], o.Specular*128.0) * CRNM.y * o.SSBump.z + \
				pow(nh[2], o.Specular*128.0) * CRNM.z * o.SSBump.y;	\
		spec *= o.Gloss * LMap;

#define RNMSSBUMPCOMPUTE \
		light = o.SSBump.x * RNMX + \
				o.SSBump.y * RNMY + \
				o.SSBump.z * RNMZ;

#define CRNMDECODE \
		half3 CRNM = DecodeLightmap(tex2D(unity_Lightmap, IN.lmapUV)); \
		half3 LMap = DecodeLightmap(tex2D(unity_LightmapInd, IN.lmapUV)); \

#define CRNMCOMPUTE \
		light = max(0, dot(bumpBasis[0], o.Normal)) * CRNM.x + \
				max(0, dot(bumpBasis[1], o.Normal)) * CRNM.y + \
				max(0, dot(bumpBasis[2], o.Normal)) * CRNM.z; \
		light *= LMap;

#define CRNMSPECCOMPUTE \
		spec =	pow(nh[0], o.Specular*128.0) * CRNM.x + \
				pow(nh[1], o.Specular*128.0) * CRNM.y + \
				pow(nh[2], o.Specular*128.0) * CRNM.z; \
		spec *= o.Gloss * LMap;

#define SSBUMPCOMPUTE \
		half diff = dot(bumpBasis[0], lightDir) * s.SSBump.x + \
					dot(bumpBasis[1], lightDir) * s.SSBump.y + \
					dot(bumpBasis[2], lightDir) * s.SSBump.z;

#define CRNMSSBUMPCOMPUTE \
		light = dot(o.SSBump, CRNM) * LMap;

#define SSBUMPSURFOUT \
		struct GzSurfaceOutput { \
			half3 Albedo; \
			half3 Normal; \
			half3 SSBump; \
			half3 Emission; \
			half Specular; \
			half3 Gloss; \
			half Alpha; \
		};

#define SSBUMPASSIGN \
		o.Normal = half3(0); \
		o.SSBump = tex2D(_SSBump, IN.uv_SSBump) * _SSBumpMulti;

#define SSBUMPNORMASSIGN \
		o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap)); \
		o.SSBump = tex2D(_SSBump, IN.uv_SSBump) * _SSBumpMulti;

#define SPECLERP \
		o.Gloss	= lerp(c.aaa, tex2D(_SpecMap, IN.uv_SpecMap), _UseSMap) * _SpecMulti;

#define LUVACCESS \
		o.lmapUV = lerp(v.texcoord1.xy, v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw, _deval);