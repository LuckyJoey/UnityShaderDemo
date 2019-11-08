// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Joey/10 MyShader-Specular"
{
    Properties
    {
        _Diffuse("Diffuse",Color) = (1,1,1,1)
        _Specular("Specular", Color) = (1,1,1,1)
        _Gloss("Closs",Range(8,200))=20
    }
    SubShader
    {
        Pass
        {
            Tags{"LightMode"="ForwardBase"}
            CGPROGRAM
            #include "Lighting.cginc"
            #pragma vertex vert
            #pragma fragment frag
            fixed4 _Diffuse;
            fixed4 _Specular;
            half _Gloss;
            struct a2v
            {
                float4 vertex:POSITION;
                float3 normal:NORMAL;
            };
            struct v2f
            {
                float4 svPos:SV_POSITION;
                float3 worldNormal:TEXCOORD0;
                float4 worldVertext:TEXCOORD1;
            };
            v2f vert(a2v v)
            {
                v2f f;
                f.svPos = UnityObjectToClipPos(v.vertex);
                f.worldNormal = UnityObjectToWorldNormal(v.normal);
                f.worldVertext = mul(unity_WorldToObject,v.vertex);
                return f;
            }
            fixed4 frag(v2f f):SV_Target
            {
                //法线方向
                fixed3 normalDir = normalize(f.worldNormal);
                //光的方向
                fixed3 lightDir = normalize(WorldSpaceLightDir(f.worldVertext));
                //漫反射颜色
                fixed4 diffuse = _LightColor0 * _Diffuse * (dot(normalDir,lightDir)*0.5+0.5);/*半兰伯特光照模型，法线方向*光方向*0.5+0.5*/
                //视野方向
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(f.worldNormal));
                fixed3 halfDir =normalize(viewDir+lightDir);
                //高光反射颜色
                fixed4 specular = _LightColor0 * _Specular * pow(max(dot(normalDir,halfDir),0),_Gloss);
                fixed4 tempColor = diffuse+specular + UNITY_LIGHTMODEL_AMBIENT;
                return tempColor;
            }
            ENDCG
        }
    }
    FallBack "Specular"
}