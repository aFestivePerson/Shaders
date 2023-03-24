Shader "festive/Lava" {
	Properties{
		_TextureMain("TextureMain", 2D) = "white" {}
	_NormalMap("NormalMap", 2D) = "bump" {}
	_DissolveTexture("DissolveTexture", 2D) = "white" {}
	_OverlayEffectiveness("Overlay Effectiveness", Range(0, 1)) = 0.5
		_XSpeed("XSpeed", Range(0, 100)) = 0.5
		_YSpeed("YSpeed", Range(0, 100)) = 0
		_Noise("Noise", Range(0, 10)) = 1
		[HideInInspector]_Cutoff("Alpha cutoff", Range(0,1)) = 0.5
	}
		SubShader{
		Tags{
		"Queue" = "Overlay+500000110"
		"RenderType" = "Transparent"
		"ZTest" = "Always"
		"IgnoreProjector" = "True"
	}

		Cull Off
		ZWrite On
		Pass{
		Name "FORWARD"
		Tags{
		"LightMode" = "ForwardBase"
	}


		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#define UNITY_PASS_FORWARDBASE
#include "UnityCG.cginc"
#pragma multi_compile_fwdbase_fullshadows
#pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x xboxone ps4 psp2 n3ds wiiu 
#pragma target 3.0
		uniform sampler2D _TextureMain; uniform float4 _TextureMain_ST;
	uniform sampler2D _NormalMap; uniform float4 _NormalMap_ST;
	uniform float _OverlayEffectiveness;
	uniform float _XSpeed;
	uniform float _YSpeed;
	uniform float _Noise;
	uniform sampler2D _DissolveTexture; uniform float4 _DissolveTexture_ST;
	struct VertexInput {
		float4 vertex : POSITION;
		float2 texcoord0 : TEXCOORD0;
		float4 vertexColor : COLOR;
	};
	struct VertexOutput {
		float4 pos : SV_POSITION;
		float2 uv0 : TEXCOORD0;
		float4 vertexColor : COLOR;
	};
	VertexOutput vert(VertexInput v) {
		VertexOutput o = (VertexOutput)0;
		o.uv0 = v.texcoord0;
		o.vertexColor = v.vertexColor;
		o.pos = UnityObjectToClipPos(v.vertex);
		return o;
	}
	float4 frag(VertexOutput i, float facing : VFACE) : COLOR{
		float isFrontFace = (facing >= 0 ? 1 : 0);
	float faceSign = (facing >= 0 ? 1 : -1);
	float4 _DissolveTexture_var = tex2D(_DissolveTexture,TRANSFORM_TEX(i.uv0, _DissolveTexture));
	float4 _OpaTime = _Time;
	clip((_DissolveTexture_var.r + (sin((_OpaTime.g / _Noise))*0.4375 + 0.0625)) - 0.5);
	////// Lighting:
	////// Emissive:
	float4 _XTime = _Time;
	float3 _NormalMap_var = UnpackNormal(tex2D(_NormalMap,TRANSFORM_TEX(i.uv0, _NormalMap)));
	float2 _VertexMask2 = lerp(_NormalMap_var.rgb,i.vertexColor.rgb,_OverlayEffectiveness).rg;
	float2 node_5248 = ((_VertexMask2 + (_XTime.g*_XSpeed)*float2(0,1)) + (_VertexMask2 + (_XTime.g*_YSpeed)*float2(1,0)));
	float4 _TextureMain_var = tex2D(_TextureMain,TRANSFORM_TEX(node_5248, _TextureMain));
	float3 emissive = _TextureMain_var.rgb;
	float3 finalColor = emissive;
	return fixed4(finalColor,1);
	}
		ENDCG
	}
		Pass{
		Name "ShadowCaster"
		Tags{
		"LightMode" = "ShadowCaster"
	}
		Offset 1, 0.9
		Cull Off

		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#define UNITY_PASS_SHADOWCASTER
#include "UnityCG.cginc"
#include "Lighting.cginc"
#pragma fragmentoption ARB_precision_hint_fastest
#pragma multi_compile_shadowcaster
#pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x xboxone ps4 psp2 n3ds wiiu 
#pragma target 3.0
		uniform float _Noise;
	uniform sampler2D _DissolveTexture; uniform float4 _DissolveTexture_ST;
	struct VertexInput {
		float4 vertex : POSITION;
		float2 texcoord0 : TEXCOORD0;
	};
	struct VertexOutput {
		V2F_SHADOW_CASTER;
		float2 uv0 : TEXCOORD1;
	};
	VertexOutput vert(VertexInput v) {
		VertexOutput o = (VertexOutput)0;
		o.uv0 = v.texcoord0;
		o.pos = UnityObjectToClipPos(v.vertex);
		TRANSFER_SHADOW_CASTER(o)
			return o;
	}
	float4 frag(VertexOutput i, float facing : VFACE) : COLOR{
		float isFrontFace = (facing >= 0 ? 1 : 0);
	float faceSign = (facing >= 0 ? 1 : -1);
	float4 _DissolveTexture_var = tex2D(_DissolveTexture,TRANSFORM_TEX(i.uv0, _DissolveTexture));
	float4 _OpaTime = _Time;
	clip((_DissolveTexture_var.r + (sin((_OpaTime.g / _Noise))*0.4375 + 0.0625)) - 0.5);
	SHADOW_CASTER_FRAGMENT(i)
	}
		ENDCG
	}
	}
		FallBack "Diffuse"
}
