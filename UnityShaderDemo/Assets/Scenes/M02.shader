// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Joey/02 MyShader"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
            //顶点函数 这里只是声明了，顶点函数的函数名
            //基本作用是，完成顶点坐标从模型空间到剪裁空间的转换（从游戏环境转换到视野相机屏幕上）
            #pragma vertex vert
            //片元函数 这里只是声明了，片元函数的函数名
            //基本作用，返回模型对应的屏幕上的每一个像素的颜色值
            #pragma fragment frag
            float4 vert(float4 v:POSITION):SV_POSITION
            {
                //通过语义告诉系统，我这个参数是干嘛的，比如POSITION是告诉系统我需要顶点坐标
                //SV_POSITION这个语义用来解释说明返回值，意思是返回值是剪裁空间下的顶点坐标
                float4 pos = UnityObjectToClipPos(v);
                return pos;
            }
            fixed4 frag():SV_Target
            {
                return fixed4(0.5,1,1,1);
            }
            ENDCG
        }
    }
    FallBack "Joey/01 MyShader"
}
