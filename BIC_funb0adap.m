% BIC function  to compute the score of two vectors;

function X1=BIC_fun(Cepi,UBM);
%save('temp1','-ascii','Cepi');
saveb('temp1',Cepi,'b');

%t1=['!emaxb.exe -i temp1 -o X.gmm -s ' UBM ' -I 5'];eval(t1);
t1=['!adaptgmmb.exe -i temp1 -m UBM4.gmm -r 15 -u 1,1,1 -o X.gmm']; eval(t1); 
ID='X.gmm';
[UBM_V,UBM_M,UBM_W,UBM_N,UBM_D] = load_mixture_model_diagb(ID);
UBM1 = struct('MeanVecs',UBM_M,'VarVecs',UBM_V,'MixWeights',UBM_W);
X1 = L_score01(Cepi,UBM1);

