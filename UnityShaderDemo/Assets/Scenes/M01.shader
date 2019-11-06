Shader "Joey/01 MyShader"{//这里指定shader名字
    Properties
    {
        //属性
        _Color("Color",Color)=(0.5,0.5,0.5,1)
        _Vector("Vector",Vector)=(1,2,3,4)
        _Int("Int",Int)=10
        _Float("Float",Float)=2.5
        _Range("Range",Range(1,11))=2
        _2D("2DTexture",2D)="whilt"{}
        _Cude("Cube",Cube)="red"{}
        _3D("3DTexture",3D) = "black"{}
    }
    //SubShader可以有很多个，实现不同效果；显卡运行效果的时候，从第一个SubShader开始，如果第一个SubShader里面的效果都可以实现，那么就使用第一个SubShader；
    //如果显卡发现这个SubShader里面某些效果实现不了，它会自动去运行下一个SubShader
    SubShader
    {
        //至少一个Pass
        Pass
        {
            //在这里编写shader代码 HLSLPROGRAM
            CGPROGRAM
            //使用CG语言编写shader代码
            fixed4 _Color;
            float4 _Vector;
            float _Int;
            float _Float;
            float _Range;
            sampler2D _2D;
            samplerCube _Cube;
            sampler3D _3D;
            
            //float 32位存储
            //half 16位，-6万~6万
            //fixed 11位，-2到+2
            ENDCG
        }
    }
    Fallback "Unlit/Color"
}