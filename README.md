# add-noiseTotalSteps

在Windows底下上传的，果然比Linux下费事啊，虽然有图形界面，还是不如命令行方便、简单，牢骚发到这里。

本项目是为音频设备源识别，为音频WAV文件添加不同snr的噪声，然后提取mfcc特征，使用ubm-gmm训练ubm,为每个WAV文件提取gmm,

then send to kmeans,get the clustering results.Finally,envaluate the clustering-results with ca,nmi,K-Value 。。

the main entrance is add-steps.py.but the script seems like finished after call matlab programm.would not execute the ComKvalues.
Whatever,it really saves a lot of time and automaticlly runs without human intervention.
