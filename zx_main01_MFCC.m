% this function is to train the models and testing results;
% training model
% model 1 feature;
clear all;
fclose all;

%addpath C:\SRE04\MH_GMM\MFCC;
%cd C:\SRE04\MH_GMM\MFCC;

% training UBM


%load C:\SRE04\MH_GMM\MFCC\MFCC % load feature file
%{}%
mydir='I:\MFCC13_80-119\MFCC13_80-119\';
 filelist=dir([mydir,'*.mfcc']);
 filenum=length(filelist);

 MFCC=cell(filenum,1);
 MFCC_file=cell(filenum,1);%record the bn-fea order of the MFCC cell.
for q=1:filenum,
    filename=filelist(q).name;
    total=strcat(mydir,filename);
    MFCC_file{q}=filename;
    [d,fp,dt]=htkread(total); %[d,fp,dt,tc,t]=READHTK(total);
    MFCC{q}=d;
end
fprintf('\n\nMFCCload success ...\n\n');
%   MFCC=load('MFCC1024_26.mat');
%   MFCC=MFCC.MFCC;
%%
% MFCC data must be in N by M dimension N is number of length frame 
% M is vector dimension.   e.g  100000 by 30
 k = 0; % total number of segments (models)
%%
%zx_1=size(MFCC, 1);zx_2=size(MFCC, 2);
%%jiang mfcc cong shude biancheng heng de
 for i=1:size(MFCC, 1)
     for j = 1 : size(MFCC, 2)
         if ~isempty(MFCC{i, j})
             k = k + 1;
 			if size(MFCC{i, j},2)>42;    
 				Cep{k} = MFCC{i, j}';
 			else
 				Cep{k} = MFCC{i, j}; 				
 			end 
 			fprintf('MFCC size is: [%d, %d] \n', size(MFCC))	
 		end
     end
 end   
     

gaussian=256;
% Cep=load('F:\mobile\MFCC\Cep-256_bn-208_500_500_13_21.mat ');
% Cep=Cep.Cep;
ubmname='zx_mob-eng80-119_ubm256_mfcc13';
zx_train_UBM(Cep,gaussian,ubmname);  % feature in cell structure  adn 32 is nuimber of GMM 'UBM01'  model name;
clear MFCC;

% save all
% 
% % load all
% adapt training model
%MFCC_filelist=load('MFCC_file_load-order.mat');
MFCC_filelist=MFCC_file;%MFCC_filelist.MFCC_file;
for i = 1 : length(Cep);
   % gmmname=['model', num2str(i)];%model1
    filename=MFCC_filelist{i};
    findchar=strfind(filename,'.mfcc');
    if ~isempty(filename)
        gmmname=filename(1:findchar-1);%different with python,���Ǳ�����
        tic;
        zx_adap_UBM(Cep(i), gaussian,gmmname, ubmname);  % feature in cell structure  adn 32 is nuimber of GMM 'model i'  model name;
        disp(['This time extract an bn-gmm-fea of a sample use : ',num2str(toc),'s']);
    end
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
