# -*- coding: utf-8 -*-

"""
 @author:zzpp220
 @file:hcopy_scp.py
 Create on 12:04:21 Dec 10,2017
 """

import os,sys
import glob
'''
if len(sys.argv) != 5:
    print( "------------------------------------------------")
    print ("\nUSAGE: python  script.py WavPath FeaturePath SuffixName basename_Scpfile")
    print ("\nSuffixName is the suffix of feature files, e.g. fbk, bn, plp, mfc")
    print ("\n---------- Error!! --------------------------------------")
    sys.exit()
'''
# path_wav = sys.argv[1]
# path_feat = sys.argv[2]
# SuffixName = sys.argv[3]
# text = sys.argv[4]

def hcopy_Scp(path_wav,path_feat,SuffixName,text):
    assert os.path.exists(path_wav),"No such path: {}".format(path_wav)
    scp_file = os.path.join(os.path.dirname(path_feat), text + r'.scp')
    try:
        assert os.path.exists(path_feat),"No such path: {}".format(path_feat)
    except:
        print("MakingDir path_feat……")
        os.mkdir(path_feat)
    #print("dirname: ",path_wav)
    finally:
        scp = open(scp_file, 'w')
        filenames=glob.glob(path_wav+r'\*.wav')
    for filename in filenames:
        if os.path.splitext(filename)[1] == '.wav':
            filepath = filename#os.path.join(dirpath, filename)
            scp.write(filepath)
            print("file: {}".format(filepath))
            basename = os.path.basename(filename).split(r'.')[0]
            scp.write(' '+os.path.join(path_feat,basename))
            #scp.write(os.path.sep+ basename)
            scp.write(r'.'+ SuffixName +'\n')
    if os.path.isfile(scp_file):
        print("{} generated sucessfully".format(scp_file))
        scp.close()
        return scp_file
    else:
        print("---------------ERROR:{}-----------!!".format(scp_file))
        sys.exit()

if __name__ =="__main__":
    '''
    if len(sys.argv) != 5:
        print("------------------------------------------------")
        print("\nUSAGE: python  script.py WavPath FeaturePath SuffixName basename_Scpfile")
        print("\nSuffixName is the suffix of feature files, e.g. fbk, bn, plp, mfc")
        print("\n---------- Error!! --------------------------------------")
        sys.exit()
        '''
    path_wav = r"G:\mobile\WAV2520\addNoiseWav\WAV_whitetest_0dB"#sys.argv[1]"
    path_feat = r"G:\mobile\WAV2520\addNoiseWav"#sys.argv[2]
    SuffixName = "mfcc"#sys.argv[3]
    text = "test"#sys.argv[4]
    hscpfile=hcopy_Scp(path_wav,path_feat,SuffixName,text)