# ColumnDetectionCode
Deep Learning Toolbox is necessary. 
'lsmread.m'  is necessary to import Zeiss lsm format image files.
https://github.com/joe-of-all-trades/lsmread 
'lsmread.m' should be found in the same folder as 'eval_columnPCP_GUI.m', or you should specify the path. 

'LSMdata_paper' folder contains lsm format image files.
'nnPCP' folder contains neural networks used for column detection. 

Run 'eval_columnPCP_GUI.m' to detect columns. 
From 'Select a neural network', you can slect a neural network in 'LSMdata_paper' folder. 
'net200601_4class_953best.mat' is used in our paper. 

From 'Select a LSM file', you can slect a lsm format image file. 
'wt_Image 3.lsm' is a control image (white-). 

'Z section' indicates your location along the Z axis. You can move to the other Z section using the slider. 
The confocal image along the specified Z section is shown in the right panel. 
You can specify the ROI along the XY axes using the sliders adjacent to the image panel (the ROI is shown in red color). 

'Enhance Contrast' specifies the persentage of the saturated pixels. Larger is brighter. Default is 0.3.
'Detection Threshold' specifies the threshold value used to detect columns. Smaller is more sensitive to detect columns. Default is 0.3.
'Overlap Threshold' specifies the possible overlap rate between neighboring columns. Larger is more sensitive to detect columns. Default is 0.4.

'Channel' specifies the RGB channel. The channel 1 shows the Fmi staining in 'wt_Image 3.lsm'. 
'Magnification' specifies the magnification of the ROI. Default is 1.
The magnified ROI image is shown in the image panel at the bottom in an actual size. 
You may change magnification to adjust the magnified ROI image with the reference column images shown in the left panels. 
'Lamda' specifies the coefficient lamda  in the modified softmax function. Default is 0.5.

'rot90' rotates the entire image in a counter-clockwise manner. 

'Run' starts column detection. 
Press 'save' after column detection to save the quantified results in Excel format.  
