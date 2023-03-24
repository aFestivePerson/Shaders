// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "festive/WeirdPanoThing"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_2ndTex("2ndTex", 2D) = "white" {}
		_MainTex("_MainTex", 2D) = "white" {}
		_Color0("Color 0", Color) = (0,0,0,0)
		_2ndEmission("2ndEmission", Float) = 1
		_1stEmission("1stEmission", Float) = 1
		_offset("offset+", Float) = 0
		_ScaleOffset("ScaleOffset", Float) = 0
		_ScrollSpeed("Scroll Speed", Vector) = (0,0,0,0)
		_UVmovement("UV movement", Vector) = (0,0,0,0)
		_tiling("tiling", Vector) = (1,1,0,0)
		_Float0("Float 0", Float) = 0
		_Color1("Color 1", Color) = (0,0,0,0)
		_Color2("Color 2", Color) = (1,1,1,0)
		[Toggle]_ToggleSwitch0("Toggle Switch0", Float) = 1
		[Toggle]_GrayScaleToggle("GrayScaleToggle", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		
		
		
		struct Input
		{
			half filler;
		};
		uniform float _Float0;
		uniform float4 _Color1;
		
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float outlineVar = _Float0;
			v.vertex.xyz += ( v.normal * outlineVar );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			o.Emission = _Color1.rgb;
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float _GrayScaleToggle;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _Color2;
		uniform float _1stEmission;
		uniform float4 _Color0;
		uniform float _ToggleSwitch0;
		uniform sampler2D _2ndTex;
		uniform float2 _tiling;
		uniform float2 _UVmovement;
		uniform float2 _ScrollSpeed;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _ScaleOffset;
		uniform float _offset;
		uniform float _2ndEmission;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += 0;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 temp_output_27_0 = ( ( tex2D( _MainTex, uv_MainTex ) * _Color2 ) * _1stEmission );
			float grayscale69 = Luminance(temp_output_27_0.rgb);
			float4 temp_cast_1 = (grayscale69).xxxx;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			o.Emission = ( lerp(temp_output_27_0,temp_cast_1,_GrayScaleToggle) + ( ( ( _Color0 * lerp(tex2D( _2ndTex, ( float4( _tiling, 0.0 , 0.0 ) * ( float4( _UVmovement, 0.0 , 0.0 ) + ( ase_grabScreenPosNorm + float4( ( _Time.y * _ScrollSpeed ), 0.0 , 0.0 ) ) ) ).xy ).a,tex2D( _TextureSample0, uv_TextureSample0 ).a,_ToggleSwitch0) ) * (_SinTime.w*_ScaleOffset + ( _ScaleOffset + _offset )) ) * _2ndEmission ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15902
47;29;1813;1004;1225.587;795.2065;1.154816;True;False
Node;AmplifyShaderEditor.TimeNode;34;-1357.549,215.6962;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;38;-1209.549,403.6962;Float;False;Property;_ScrollSpeed;Scroll Speed;9;0;Create;True;0;0;False;0;0,0;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-952.5492,274.6962;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GrabScreenPosition;59;-1328.988,-64.20563;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-957.9487,121.7964;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;52;-1093.933,-125.3197;Float;False;Property;_UVmovement;UV movement;10;0;Create;True;0;0;False;0;0,0;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-787.3326,19.08031;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;54;-811.033,-138.1198;Float;False;Property;_tiling;tiling;11;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-580.7329,65.78028;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;66;-417.4008,368.5158;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;60dd67b85b7e55247bca8f444eee67e8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;61;-135.988,-413.2056;Float;False;Property;_Color2;Color 2;14;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-358.5653,-587.0969;Float;True;Property;_MainTex;_MainTex;2;0;Create;True;0;0;True;0;None;80128751fd641294aae6ebcb53f9114a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;32;-105.5492,257.6962;Float;False;Property;_ScaleOffset;ScaleOffset;8;0;Create;True;0;0;False;0;0;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-48.37281,331.2344;Float;False;Property;_offset;offset+;7;0;Create;True;0;0;False;0;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-540.5999,-104.7;Float;True;Property;_2ndTex;2ndTex;1;0;Create;True;0;0;False;0;None;60dd67b85b7e55247bca8f444eee67e8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinTimeNode;31;-155.5492,136.6962;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;26;266,-314;Float;False;Property;_1stEmission;1stEmission;6;0;Create;True;0;0;False;0;1;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;42.49714,-350.5278;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;64;-287.4008,35.51581;Float;False;Property;_ToggleSwitch0;Toggle Switch0;15;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;108.6272,338.2344;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;9;-642,-334;Float;False;Property;_Color0;Color 0;4;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;401,-210;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;30;111.4508,209.6962;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-92.54919,33.69623;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;69;470.8368,-330.9706;Float;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;101,107;Float;False;Property;_2ndEmission;2ndEmission;5;0;Create;True;0;0;False;0;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;52,-20;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;70;520.4943,-318.2677;Float;False;Property;_GrayScaleToggle;GrayScaleToggle;16;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;58;242.498,284.3259;Float;False;Property;_Color1;Color 1;13;0;Create;True;0;0;False;0;0,0,0,0;0.07586239,0,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;56;418.5925,379.7665;Float;False;Property;_Float0;Float 0;12;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;191.4508,-8.303772;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;296,-104;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;20;-201,-81;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;306,171;Float;False;Property;_2ndTexture;2ndTexture;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;401.4508,66.6962;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;41;-1266.049,10.09623;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OutlineNode;55;514.3589,230.6289;Float;False;0;True;None;0;0;Front;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-561.401,382.5158;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-728.401,439.5158;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;567,-173;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;New Amplify Shader 1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;2147481647;False;Opaque;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;37;0;34;2
WireConnection;37;1;38;0
WireConnection;36;0;59;0
WireConnection;36;1;37;0
WireConnection;51;0;52;0
WireConnection;51;1;36;0
WireConnection;53;0;54;0
WireConnection;53;1;51;0
WireConnection;3;1;53;0
WireConnection;62;0;2;0
WireConnection;62;1;61;0
WireConnection;64;0;3;4
WireConnection;64;1;66;4
WireConnection;50;0;32;0
WireConnection;50;1;49;0
WireConnection;27;0;62;0
WireConnection;27;1;26;0
WireConnection;30;0;31;4
WireConnection;30;1;32;0
WireConnection;30;2;50;0
WireConnection;39;0;9;0
WireConnection;39;1;64;0
WireConnection;69;0;27;0
WireConnection;24;0;39;0
WireConnection;24;1;30;0
WireConnection;70;0;27;0
WireConnection;70;1;69;0
WireConnection;33;0;24;0
WireConnection;33;1;25;0
WireConnection;23;0;70;0
WireConnection;23;1;33;0
WireConnection;55;0;58;0
WireConnection;55;1;56;0
WireConnection;67;0;54;0
WireConnection;67;1;68;0
WireConnection;68;0;52;0
WireConnection;0;2;23;0
WireConnection;0;11;55;0
ASEEND*/
//CHKSM=FA80AD71A6A1141867B531B09D438E098BA946C6