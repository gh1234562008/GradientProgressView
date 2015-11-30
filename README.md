title: iOS实现曲线渐变

date: 2015-11-30 18:04:52

tags:
- iOS
- 动画
---
最近产品提了一个需求，要求进度条的进度可以大于1。效果如下
![](http://7xiyql.com1.z0.glb.clouddn.com/progress.gif)
效果图上卡，实际上并不卡。  
在开始做之前，看了github上所有的progress相关的代码，发现并没有人实现过这样的效果。苹果apple watch应用实现了，但是不知道苹果是怎么实现的。  
这个效果的难度就在于 曲线渐变 和 进度能大于1。
cocoa touch提供的api都是直线渐变。而进度可以大于1要求曲线的首和尾颜色不能想近，应该相差最大。  
[iOS实现一个颜色渐变的弧形进度条](http://blog.csdn.net/zhoutao198712/article/details/20864143)
这篇文章实现了一个曲线渐变，但是这个无法实现进度条大于一。  
最终要想实现曲线渐变只能自己实现了。  


####颜色的生成
一共需要两个颜色，起始颜色和结束颜色。中间颜色的R、G、B值由progress线性生成。  

```  
        CGFloat ratio = (float)i / (float)sectors ;
        CGFloat R = beginR + (endR - beginR) * ratio ;
        CGFloat G = beginG + (endG - beginG) * ratio ;
        CGFloat B = beginB + (endB - beginB) * ratio ;
        
```    

####渐变的生成
由于apple提供的api都是直线的，我就采取了微分的思想，将一个圆分为无数份，然后每一份绘制一点颜色。最终就形成了曲线渐变。
####最终的实现
直接看代码吧。[demo在此](https://github.com/sxiaojian88/GradientProgressView.git)