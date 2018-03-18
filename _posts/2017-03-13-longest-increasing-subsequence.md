---
layout: post
title: 动态规划-最长增长子序列

categories:
- 数据结构算法

tags: [数据结构算法，动态规划]

author:
  login: lanbing
  email: c834606877@163.com
---




最长递增子序列（LIS）的问题是要找到一个给定序列的最长子序列的长度，使得子序列中的所有元素被排序的顺序增加。

例如，{2,1,0,5,4,8,9} LIS为{2,4,8,9},{2,4,8,9},{1,5,8,9}....最长长度为4。


这里存在一个局部前后无关性的规律：

设 arr[0..m..m+1] 其中arr[0..m] 的最长子序列是包含于arr[0..m+1]的，且长度包含

所以，求arr[0..m]的最长子序列，只需要找出{ arr[0..m-i],其中m=>i>=1}的LIS，

此时，设{ arr[0..m-i],其中m=>i>=1}的最长子序列:i = k;

如果arr[k] < arr[m]的话，则arr[m]的LIS长度为arr[0..k]的LIS长度+1；

LIS = LIS + arr[m];


```
int arr[10] = {2,1,0,5,4,8,9};
int n = sizeof(arr) / sizeof(arr[0]);

//返回包含第n个元素作为最后一个元素的子序列的最长长度，
//a用于记录最长长度，
int lis(int n, int &a)
{
    if(n == 1) return 1;
    int cmax = 0;
    for(int i = 1; i < n; i++)
    {
        //第n个元素有可能不是LIS的最后一个元素,所以这里的递归不能放进if里面。
        int r = lis(i,a);
        if(arr[i-1]<arr[n-1])
        {
            if(r > cmax) cmax = r;
        }
    }
    a = max(a,cmax+1);
    return cmax + 1;
}
```

可以看到，每次lis(n)的执行都会调用n-1次lis，时间复杂度为O(n^2)，
下面进行优化：
方法与之前的背包问题和整分拆分问题非常相似。

```
int arr[10] = {2,1,0,5,4,8,9};
int nSize = sizeof(arr) / sizeof(arr[0]);
int lis2(int nSize)
{
    int *c;
    c = (int *) malloc(sizeof(int)*nSize);
    c[0] = 1;

    int gmax=0;
    for(int n = 1; n < nSize; n++ )
    {
        int cmax = 0;
        for ( int i = 0; i < n; i++ )
        {
            if ( arr[i]<arr[n] && c[i]>cmax ) 
                cmax = c[i];
        }
        c[n] = cmax + 1;

        if ( c[n] > gmax ) gmax = c[n];
    }

    free( c );
    return gmax;
}
```
