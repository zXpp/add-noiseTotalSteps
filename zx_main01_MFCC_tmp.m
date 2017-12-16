% this function is to train the models and testing results;
% training model
% model 1 feature;
clear all;
fclose all;

%addpath C:\SRE04\MH_GMM\MFCC;
%cd C:\SRE04\MH_GMM\MFCC;

% training UBM
mydir='G:\mobile\audio_data\mfcc_13_bn\';
 filelist=dir([mydir,'*.bn']);
 filenum=length(filelist);

%load C:\SRE04\MH_GMM\MFCC\MFCC % load feature file

%mydir='/home/zzpp220/zx/nn.mob/fx/mfcc_13_bn/';
% filelist=dir([mydir,'*.bn']);
% filenum=length(filelist);
%MFCC=cell(filenum,1);
% for q=1:filenum,
%     filename=filelist(q).name;
%     total=strcat(mydir,filename);
%     [d,fp,dt,tc,t]=READHTK(total);
%     MFCC{q}=d;
% end
MFCC=load('MFCC.mat');
MFCC=MFCC.MFCC;
TMP=MFCC(1:10);
%%
% MFCC data must be in N by M dimension N is number of length frame 
% M is vector dimension.   e.g  100000 by 30
k = 0; % total number of segments (models)
%%
%zx_1=size(MFCC, 1);zx_2=size(MFCC, 2);
for i=1:size(TMP, 1)
    for j = 1 : size(TMP, 2)
        if ~isempty(TMP{i, j})
            k = k + 1;
			if size(TMP{i, j},2)>42;    
				Ceptmp{k} = TMP{i, j}';
			else
				Ceptmp{k} = MFCC{i, j}; 				
			end 
			fprintf('TMP size is: [%d, %d] \n', size(TMP))	
		end
    end
end        
% Cep=load('Cep.mat');
% Cep=Cep.Cep;
% Ceptmp=Cep(1:10);
ubmname='ubm_bn_tmp';
train_UBM_tmp(Ceptmp,256,ubmname);  % feature in cell structure  adn 32 is nuimber of GMM 'UBM01'  model name;
clear MFCC;
% save all
% 
% load all
% adapt training model
for i = 1 : length(Ceptmp);
   filename=filelist(i).name;
    findchar=strfind(filename,'.bn');
     gmmname=filename(1:findchar-1);
    adap_UBM(Ceptmp(i), 256, gmmname, ubmname);  % feature in cell structure  adn 32 is nuimber of GMM 'model i'  model name;
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
