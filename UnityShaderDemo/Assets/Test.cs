using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test : MonoBehaviour
{
    public int input;
    [ContextMenu("TextCompute")]
    public void Compute()
    {
        Debug.Log("Fib:"+2*Fib(input));
        Debug.Log("SecondRabbit:"+2*SecondRabbit());
    }
    /// <summary>
    /// 方法1
    /// </summary>
    /// <param name="n"></param>
    /// <returns></returns>
    int Fib(int n)
    {
        if (n < 3)
        {
            return 1;
        }
        else
        {
            return Fib(n - 1) + Fib(n - 2);
        }
    }

    int SecondRabbit()
    {
        int i=0,j=1;
        int back=i;
        while (i<input+2)
        {
//            if (i > 0)
//                Debug.Log("SecondRabbit_i"+i);
            back = i;    
            i = j;
            j = back + j;
        }
        //Debug.Log("SecondRabbit_Ed"+back);
        return back;
    }
}
