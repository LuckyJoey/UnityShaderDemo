// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Joey/12 MyShader-Texture2D"
{
    Properties
    {
        _Texture2D("Texture2D",2D)="while"{}
        _Color("Color",Color) = (1,1,1,1)
        //_Diffuse("Diffuse",Color) = (1,1,1,1)
        _Specular("Specular", Color) = (1,1,1,1)
        _Gloss("Gloss",Range(8,200))=20
        _NormalMap("NormalMap",2D)="bump"{}//顶点自带的法线
        //法线贴图:五颜六色，模型空间；蓝色，切线空间
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
            //fixed4 _Diffuse;
            sampler2D _NormalMap;
            float2 _NormalMap_ST;//tilling offset 放大，偏移
            sampler2D _Texture2D;
            float4 _Texture2D_ST;//tilling offset 放大，偏移
            fixed4 _Color;
            fixed4 _Specular;
            half _Gloss;
            struct a2v
            {
                float4 vertex:POSITION;
                //切线空间的确定是通过(存储到模型里面的)法线和(存储到模型里面的)切线确定的
                float3 normal:NORMAL;
                float4 tengent:TENGENT;//tangent.w是用来确定切线空间中坐标轴的方向的
                float4 texcoord0:TEXCOORD0;
            };
            struct v2f
            {
                float4 svPos:SV_POSITION;
                float3 worldNormal:TEXCOORD0;
                float4 worldVertext:TEXCOORD1;
                float4 uv:TEXCOORD2;//xy用来存储Texture的纹理坐标，zw用来存储NormalMap的纹理坐标
                float3 lightDir : TEXCOORD3;//切线空间下，平行光的方向
            };
            v2f vert(a2v v)
            {
                v2f f;
                f.svPos = UnityObjectToClipPos(v.vertex);
                f.worldNormal = UnityObjectToWorldNormal(v.normal);
                f.worldVertext = mul(unity_WorldToObject,v.vertex);
                f.uv.xy = v.texcoord0.xy*_Texture2D_ST.xy + _Texture2D_ST.zw;
                f.uv.zw = v.texcoord0.xy * _NormalMap_ST.xy +_NormalMap_ST.zw;
                
                TANGENT_SPACE_ROTATION;//调用这个后之后，会得到一个矩阵，rotation 这个矩阵用来把模型空间下的方向转换成切线空间
                //ObjSpaceLightDir(v.vertex)//得到模型空间下的平行光方向
                f.lightDir = mul(rotation,ObjSpaceLightDir(v.vertex));
                return f;
            }
            //把所有跟法线方向有关的运算都放在 切线空间下
            //从法线贴图里面取得的法线方向是在切线空间下的
            fixed4 frag(v2f f):SV_Target
            {
                //法线颜色
                fixed4 normalColor = tex2D(_NormalMap, f.uv.zw);
                //fixed3 tangentNormal = normalColor.xyz * 2 - 1;//切线空间下的法线
                fixed4 tangentNormal = UnpackNormal(normalColor);
                //光的方向
                fixed3 lightDir = normalize(f.lightDir);
                //纹理颜色
                fixed4 texColor = tex2D(_Texture2D,f.uv.xy) * _Color;
                //漫反射颜色
                fixed4 diffuse = _LightColor0 * texColor * (dot(tangentNormal,lightDir)*0.5+0.5);/*半兰伯特光照模型，法线方向*光方向*0.5+0.5*/
                //视野方向
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(f.worldNormal));
                fixed3 halfDir =normalize(viewDir+lightDir);
                //高光反射颜色
                fixed4 specular = _LightColor0 * _Specular * pow(max(dot(normalDir,halfDir),0),_Gloss);
                fixed4 tempColor = diffuse+specular + UNITY_LIGHTMODEL_AMBIENT*texColor;
                return tempColor;
            }
            ENDCG
        }
    }
    FallBack "Specular"
}