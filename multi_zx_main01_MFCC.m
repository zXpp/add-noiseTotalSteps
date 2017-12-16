% this function is to train the models and testing results;
% training model
% model 1 feature;
clear all;
fclose all;

%addpath C:\SRE04\MH_GMM\MFCC;
%cd C:\SRE04\MH_GMM\MFCC;

% training UBM
%load C:\SRE04\MH_GMM\MFCC\MFCC % load feature file
%{}%'120-159','160-199','200-,'240-279','280-319','320-359','360-399','400-439','440-479','480-519','520-559','560-599','600-639','640-679','80-119'
srcpath='G:\mobile\WAV2520\addNoiseWav\';
a={'MFCC_whitetest_0dB'};%'MFCC_whitetest_10dB';'MFCC_whitetest_20dB';'MFCC_whitetest_30dB'};
gmmcell=cell(length(a),1);
flag='single';%
%flag='total';
for y=1:size(a,1)
x=a{y,:};
tmplabel=strcat(x,''); %  _MFCC13 
mydir=fullfile(srcpath,tmplabel,'\');%wavdir 最后一个目录一定要加反斜杠，不然22行的*.mfcc会出错,存放mfcc的目录
findchar=strfind(tmplabel,'MFCC_');
uniquelab=tmplabel(findchar+4:length(tmplabel));
addsuffix=strcat('gmm13_',uniquelab);
gmmcell{y}=addsuffix;
destdir=fullfile(srcpath,addsuffix,'\');
if isdir(destdir)
    disp([destdir,'exists!']);
else
    mkdir(destdir);
end
%{  %}  

%mydir='I:\L_MFCC_13\MFCC_13\';
 filelist=dir([mydir,'*.mfcc']);%,'*.mfcc'
 filenum=length(filelist);


%%

 MFCC=cell(filenum,1);
 MFCC_file=cell(filenum,1);%record the bn-fea order of the MFCC cell.
for q=1:filenum,
    filename=filelist(q).name;
    total=strcat(mydir,filename);
    MFCC_file{q}=filename;
    %d=load(total);read txt mfcc-file
    [d,fp,dt]=htkread(total); %[d,fp,dt,tc,t]=READHTK(total);
    MFCC{q}=d;
end

%%
fprintf('\n\nMFCCload success ...\n\n');
%   MFCC=load('MFCC1024_26.mat');
%   MFCC=MFCC.MFCC;
%%
% MFCC data must be in N by M dimension N is number of length frame 
% M is vector dimension.   e.g  100000 by 30

%%
%%jiang mfcc cong shude biancheng heng de
%{%}
 k = 0; % total number of segments (models)
 for i=1:size(MFCC, 1)
     for j = 1 : size(MFCC, 2)
         if ~isempty(MFCC{i, j});
             k = k + 1;
 			if size(MFCC{i, j},2)>42;    
 				Cep{k} = MFCC{i, j}';
 			else
 				Cep{k} = MFCC{i, j}; 				
 			end 
 			fprintf('MFCC size is: [%d, %d] \n', size(MFCC));	
 		end
     end
 end 

%%
%{
 Cep=load('Cep-tot.mat');
 Cep=Cep.Cep; 
 %}   
%%
gaussian=256;
ubmname=strcat('zxaddnoise_mfcc13_ubm256_',tmplabel);

%{%}
zx_train_UBM(Cep,gaussian,ubmname);  % feature in cell structure  adn 32 is nuimber of GMM 'UBM01'  model name;
clear MFCC;


% save all 
% % load all

% adapt training model
%%
%MFCC_filelist=load('MFCC_file-tot.mat');MFCC_filelist=MFCC_filelist.MFCC_file;


MFCC_filelist=MFCC_file;%MFCC_filelist.MFCC_file
%%
    for i = 1 : length(Cep);
       % gmmname=['model', num2str(i)];%model1
        filename=MFCC_filelist{i};
        findchar=strfind(filename,'.mfcc');
        if ~isempty(filename)
            gmmname=filename(1:findchar-1);%different with python,都是闭区间
            %tic;
            zx_adap_UBM(Cep(i), gaussian,gmmname, ubmname);  % feature in cell structure  adn 32 is nuimber of GMM 'model i'  model name;
            %disp(['This time extract an bn-gmm-fea of a sample use : ',num2str(toc),'s']);
        end
        if exist(strcat(gmmname,'.gmm'),'file')
             movefile(strcat(gmmname,'.gmm'),destdir);
        else
            disp([strcat(gmmname,'.gmm'),' does not exist']);
        end
        
       
    end
clear Cep;
disp(['now send to mean-120 kmeans','......']);
fun_zx_mean120msv_kmeans(srcpath,a,flag,uniquelab,'','');
end


% % do the test against model for the feature;
% [Ubm.VarVecs,Ubm.MeanVecs,Ubm.MixWeights,N0,D0]=load_mixture_model_diagb('UBM01.gmm');
% for i = 1 : length(Cep)
%     [gmm(i).VarVecs,gmm(i).MeanVecs,gmm(i).MixWeights,N(i),D(i)]=load_mixture_model_diagb(['model', num2str(i), '.gmm']);
% end
% 
% % do the test;
% TargetScoreMFCC = [];
% UBMscore = [];
% NormScoreMFCC = [];
% for i = 1 : length(gmm);  % NormScoreMFCC(i) is testing scores.
%     for j = 1 : length(Cep)
%         [UBMscore,TopIndices0] = GMM_UBM_BackgroundScore2(Cep{j},Ubm,10);
%         TargetScoreMFCC(i, j) = GMM_UBM_TargetScore(Cep{j},TopIndices0,gmm(i));
%         NormScoreMFCC(i, j) = TargetScoreMFCC(i, j) - UBMscore;
%         fprintf('GMM no. is: %d/%d, segment no. is: %d/%d\n', i, length(gmm),j, length(Cep))
%     end
% end
% save TargetScoreMFCC TargetScoreMFCC
% save NormScoreMFCC NormScoreMFCC
% disp(NormScoreMFCC); 
% 
