% this function is to train the models and testing results;
% training model
% model 1 feature;
clear all;
fclose all;

addpath C:\SRE04\MH_GMM\MFCC;
cd C:\SRE04\MH_GMM\MFCC;

% training UBM
load C:\SRE04\MH_GMM\MFCC\MFCC % load feature file
k = 0; % total number of segments (models)

%%
% MFCC data must be in N by M dimension N is number of length frame 
% M is vector dimension.   e.g  100000 by 30

%%
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
train_UBM(Cep,256,'UBM01');  % feature in cell structure  adn 32 is nuimber of GMM 'model1'  model name;
clear MFCC;
% save all
% 
% load all
% adapt training model
for i = 1 : length(Cep);
    adap_UBM(Cep(i), 256, ['model', num2str(i)]);  % feature in cell structure  adn 32 is nuimber of GMM 'model i'  model name;
end

% do the test against model for the feature;
[Ubm.VarVecs,Ubm.MeanVecs,Ubm.MixWeights,N0,D0]=load_mixture_model_diagb('UBM01.gmm');
for i = 1 : length(Cep)
    [gmm(i).VarVecs,gmm(i).MeanVecs,gmm(i).MixWeights,N(i),D(i)]=load_mixture_model_diagb(['model', num2str(i), '.gmm']);
end

% do the test;
TargetScoreMFCC = [];
UBMscore = [];
NormScoreMFCC = [];
for i = 1 : length(gmm);  % NormScoreMFCC(i) is testing scores.
    for j = 1 : length(Cep)
        [UBMscore,TopIndices0] = GMM_UBM_BackgroundScore2(Cep{j},Ubm,10);
        TargetScoreMFCC(i, j) = GMM_UBM_TargetScore(Cep{j},TopIndices0,gmm(i));
        NormScoreMFCC(i, j) = TargetScoreMFCC(i, j) - UBMscore;
        fprintf('GMM no. is: %d/%d, segment no. is: %d/%d\n', i, length(gmm),j, length(Cep))
    end
end
save TargetScoreMFCC TargetScoreMFCC
save NormScoreMFCC NormScoreMFCC
disp(NormScoreMFCC); 

