//
//  stitching.cpp
//  FetchPanoramaPhoto
//
//  Created by 苹果 on 2016/11/15.
//  Copyright © 2016年 苹果. All rights reserved.
//

#include "stitching.hpp"
#include <stdio.h>
#include <iostream>
#include <fstream>
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/stitching/stitcher.hpp"

using namespace std;
using namespace cv;

//bool try_use_gpu = false;
vector<Mat> imgs;

//void printUsage();
void parseCmdArgs(int argc, char** argv);

cv::Mat stitch (vector<Mat>& images)
{
    imgs = images;
    Mat pano;
    Stitcher stitcher = Stitcher::createDefault(true);
    stitcher.setRegistrationResol(0.1);//检测特征点,默认0.6,最大值1最慢
    
    Stitcher::Status status = stitcher.stitch(imgs, pano);
    
    if (status != Stitcher::OK)
    {
        cout << "Can't stitch images, error code = " << int(status) << endl;
        //return 0;
    }
    return pano;
}

//导入所有原始拼接图像函数
void parseCmdArgs(int argc, char** argv)
{
    for(int i=1;i<argc;i++)
    {
        Mat img = imread(argv[i]);
        if (img.empty())
        {
            cout << "Can't read image '" << argv[i] << "'\n";
        }
        imgs.push_back(img);
    }
}
