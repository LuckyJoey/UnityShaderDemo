// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Joey/03 MyShader Struct"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
            //application to vertex
            struct a2v
            {
                float4 vertex : POSITION;//告诉unity把模型的空间下的顶点坐标填充给vertex
                float3 normal:NORMAL;//告诉unity把模型空间下的法线填充给normal
                float4 texcoord0:TEXCOORD0;//告诉unity把第一套纹理填充给texcoord0
            };
            //vertex to frag
            struct v2f
            {
                float4 position:SV_POSITION;
                float3 color0:COLOR0;//这个语义可以由用户自己定义，一般都存储颜色
            };
            #pragma vertex vert
            #pragma fragment frag
            v2f vert(a2v v)
            {
                v2f vf;
                vf.position = UnityObjectToClipPos(v.vertex);
                vf.color0 = v.normal;
                return vf;
            }
            fixed4 frag(v2f vf):SV_Target
            {
                return fixed4(vf.color0,1);
            }
            ENDCG
        }
        //从应用程序传递到顶点函数的语义有哪些a2v
        //POSITION 顶点坐标（模型空间下）
        //NORMAL 法线 （模型空间下）
        //TANGENT 切线 （模型空间）
        //TEXCOORD0~n 纹理坐标
        //COLOR 顶点颜色
        
        //从顶点函数传给片元函数时可以用到的语义
        //SV_POSITION 剪裁空间中的顶点坐标（一般是系统直接使用）
        //COLOR0 可以传递一组值 4个
        //COLOR1 可以传递一组值 4个
        //TEXCOORD0~7 传递纹理坐标
        
        //片元函数传递给系统
        //SV_Target 颜色值，显示到屏幕上的颜色
    }
    FallBack "Joey/01 MyShader"
}