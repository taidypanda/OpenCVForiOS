# OpenCVForiOS
a demo of openCV usage for iOS
# 请注意:直接编译是通不过的
因为取消了openCV和libjpeg.a这两个库(否则超过了200M),只需要下载这两个库,然后加入所需的依赖库就好了:
*ImageIO.framework*
*libz.tbd*,
*CoreVideo.framework*, 
*AssetsLibrary.framework*,
 *CoreMedia.framework*.
 也可以看[这里](http://blog.csdn.net/xgb742951920/article/details/53219840),这篇文章简单介绍了openCV合成图片在手机上的性能问题.
