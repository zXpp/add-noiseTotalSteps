import os.path as osp, sys, os
import subprocess
import glob
from hcopy_scp import hcopy_Scp
from Comkmeans import k_value

# matlab子进程配置，不用更改
matlab = [r"matlab.exe"]
options = ['-nosplash', '-nojvm', '-r']
mscriptdir = r"F:\mobile\MFCC"
sys.path.append(mscriptdir)
'''
目录示例：
G:\MOBILE\WAV2520
├─addNoiseWav                    wavoutdir:osp.join(osp.dirname(sigpath),handleddirname)
│  ├─gmm13_whitetest_0dB         
│  ├─MFCC_whitetest_0dB          (|
│  ├─MFCC_whitetest_10dB         |
│  ├─MFCC_whitetest_20dB         |----------------featbase="{0}_{1}{2}dB".format(mfccdirpre,label,snr[……])
│  ├─MFCC_whitetest_30dB         |)
│  ├─WAV_whitetest_0dB           (|  
│  ├─WAV_whitetest_10dB          | ---------------suboutdir
│  ├─WAV_whitetest_20dB          |
│  └─WAV_whitetest_30dB          |)
├─apple                                            sigpath
└─WAV2520

'''
# 准备工作
label = "factory_"
sigpath = r"F:\zx_mobile-test\samptest-factory\sampletest-fatcoryT"  # 每一个运行文件夹的区分于其他的特殊label#
handleddirname = 'sampletest-factoryT' #如果是直接提gmm,则此处的值要和sigpath的basename相同
# 在输入wAV文件的根目录同级建立文件夹命名为handleddirname，存放处理后的wav、mfcc、gmm子文件夹
wavoutdir = osp.join(osp.dirname(sigpath), handleddirname)  # sys.argv[4]#rootdir

# 加噪声配置
noisewav = r"G:\C材料+220\from J+小y+Q\小y\vq\vq\wavfiles\Vodafone_joy_845_train2.wav"  # 如果是加噪声的话
snr = [ -30, -20, -10, -5]  # sys.argv[3]#array,此处定义了。如果本脚本仅从提gmm开始运行，注意后面matlab还是会重新查找特征子目录
# 加躁语音【0,10,20,30】全部放在addNoiseWAV下的作为子目录存在
suboutdir = list(map(lambda x: osp.join(wavoutdir, "WAV_{0}{1}dB".format(label, str(x))), snr))#仅提取gmm时，此目录无需配置

# 提取mfcc时所需参数
mfccdirpre = "MFCC13_WAV_"
config_file = r'G:\mobile\WAV2520\config_htk.txt'

# 训练ubm-gmm时以及k-means所用配置
brandlabelfile = r'F:\mobile\MFCC\lists\brandname.list'
truelabelfile = r'F:\mobile\MFCC\lists\true_labels.lst'
countsDev = len(open(brandlabelfile, 'r').readlines())  # 聚类个数，设备的型号
flag = 'total'


def mat_addnoise():
    command_addnoise = [
        "addpath('{0}');multi_zx_utf8addnoisemono('{1}','{2}','{3}',{4},'{5}');exit;".format(mscriptdir, sigpath,
                                                                                             noisewav, label, snr,
                                                                                             wavoutdir)]
    mat_addnoise = subprocess.Popen(matlab + options + command_addnoise)
    mat_addnoise.wait()
    print("Add Noise To WAV_file Sucessfully!")


# //////////////////////////////////////////////////////////////////////////////
'''
#加载信号、噪声，使之有共同长度
sigwavs=glob.glob(sigpath+r'\*.wav')
for sigwav in sigwavs:
    sig,sr = librosa.load(sigwav,sr=None,mono=None)

    legth=min(len(sig),len(noise))
    sig,noise=sig[:legth],noise[:legth]
    #import IPython.display
    #cc=IPython.display.Audio(sig,rate=sr,autoplay=True)
    #librosa.samples_to_frames(sig,)

    #计算计算信号、噪声的功率

    sigPower,noisePower = np.sum(sig**2)/legth,np.sum(noise**2)/legth
    m=10**(snr/10.0)#信号与噪声的功率比
    a=(sigPower/(noisePower*m))**0.5 #计算满足给定信噪比的噪声信号的放大系数
    renoise=a*noise#得到符合指定信噪比要求的噪声信号

    #得到加躁后的语音序列
    nSig=sig[:]+renoise #以单声道的方式（加性白噪声），不管输入是单声道还是双声道的方式
    librosa.output.write_wav(suboutdir,nSig,sr)
'''


# //////////////////////////////////////////////////////////////////////////////////////
#

def hcopyScpFea():
    """调用hOPY_scp 为每个处理过的wav子文件夹生成hcopy_mfcc.scp
    同时调用HCopy 提取特征，放入对应的featdir"""
    for x in suboutdir:
        featbase = "{0}_{1}{2}dB".format(mfccdirpre, label, snr[suboutdir.index(x)])
        featdir = osp.join(wavoutdir, featbase)
        hscpfile = hcopy_Scp(x, featdir, "mfcc", label + "hcopyScp")

        # 使用HCopy 提取参数
        #
        exmfcc = subprocess.Popen([r"HCopy.exe", '-A', '-C', config_file, '-S', hscpfile])
        exmfcc.wait()
        assert len(os.listdir(x)) == len(
            glob.glob(osp.join(featdir, r'*.mfcc'))), "counts of addnoises not equals to counts of mfcc_file"
        print("extract feature sucessfully!")


assert os.path.isfile(brandlabelfile), "No such file: {}".format(brandlabelfile)


assert os.path.isfile(truelabelfile), "No such file: {}".format(truelabelfile)


def ubmGMM():
    """调用matlab 做ubm-gmm 训练，提取gmm 送入main_120,做计算，得到kmeans聚类结果，以及nmi,ca的评价值
    wavoutdir 存放addnoisewav/ 和mfcc_addnoisewav/的目录
    注意truelabel的路径设定"""

    command_extgmm = [
        "addpath('{0}');fun_zx_multi_main01_MFCC('{1}','{2}','{3}','','');exit;".format(mscriptdir, wavoutdir, flag,
                                                                                        mfccdirpre, truelabelfile,
                                                                                        brandlabelfile)]
    print(command_extgmm)
    try:
        os.chdir(mscriptdir)
        extgmm=subprocess.Popen(matlab + options + command_extgmm)
        extgmm.wait()
        print("gmm extracted sucessfully!")
    except Exception as e:
        print("an error occurred at ubmgmm while call matlab:\n {}".format(e))
        print("Unexpected error:", sys.exc_info()[0])
        raise
    else:
        print("send_to_kvalues......")




def compKvalue():
    """调用kmeans-112chart,ji算K值"""
    os.chdir(wavoutdir)
    k_value(countsDev, os.getcwd())


if __name__ == "__main__":
    # mat_addnoise()
    # hcopyScpFea()
    ubmGMM()
    compKvalue()
