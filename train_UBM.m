%get feature 
%%MM1 means the mixture number.
function train_UBM(Cep,MM1,modelname);

NN1=0;NNN1=0;

for i=1:length(Cep);%

    Cep1=Cep{i};
    NNN1=NNN1+1;
    NN1=size(Cep1,1)+NN1;
    saveb1('ubm_bn-13-500.txt',Cep1,[NN1 size(Cep1,2)],NNN1);     % NN1 is summed frame  NNN1 is series number of file, NNN=1 is to create a new file
  
end

% Training model

t1=['!emaxb.exe -i ubm_bn-13-500.txt -o ' modelname '.gmm -c ' num2str(MM1) '  -I 5 > 256-bn-500-13.txt'];disp(t1);eval(t1);%%M_2048.txt


