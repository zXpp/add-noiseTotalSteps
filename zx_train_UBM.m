%get feature 
%%MM1 means the mixture number.
function zx_train_UBM(Cep,MM1,modelname)
addpath F:\mobile\MFCC;
NN1=0;NNN1=0;
%modelnametxt='';
%fid=fopen(modelnametxt,'w');
%fclose(fid);
 for i=1:length(Cep)%

    Cep1=Cep{i};
    NNN1=NNN1+1;
    NN1=size(Cep1,1)+NN1;
    modelnametxt=strcat(modelname,'.txt');%ubm_bn-13-500.txt
    saveb1(modelnametxt,Cep1,[NN1 size(Cep1,2)],NNN1);     % NN1 is summed frame  NNN1 is series number of file, NNN=1 is to create a new file
  end

% Training model
t1=['!emaxb.exe -i ' modelnametxt ' -o ' modelname '.gmm -c ' num2str(MM1) '  -I 5 > 128-bn-13-500-13.txt'];disp(t1);eval(t1);
%t1=['!emaxb.exe -i ubm_bn-13-500.txt -o ' modelname '.gmm -c ' num2str(MM1) '  -I 5 > 256-bn-500-13.txt'];disp(t1);eval(t1);%%M_2048.txt
end

