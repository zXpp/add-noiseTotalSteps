%get feature 

function adap_UBM(Cep,MM1,modelname,ubmname);

NN1=0;NNN1=0;

for i=1:length(Cep)%

    Cep1=Cep{i};
    NNN1=NNN1+1;
   NN1=size(Cep1,1)+NN1;
  % modelnametxt=strcat(modelname,'.txt');
    saveb1('bn13_temp.txt',Cep1,[NN1 size(Cep1,2)],NNN1);     % NN1 is summed frame  NNN1 is series number of file, NNN=1 is to create a new file
  
end

%disp('adapting model?');
t1=['!adaptgmmb.exe -i bn13_temp.txt -m ' ubmname '.gmm -r 15 -u 1,1,1 -o ' modelname '.gmm']; 
eval(t1); 
%t1=['!adaptgmmb.exe -i bn_temp.txt -m ubm_bn_tmp.gmm -r 15 -u 1,1,1 -o ' modelname  '.gmm']; eval(t1); 

%t1=['!emaxb.exe -i UBM01.txt -o ' modelname '.gmm -c ' num2str(MM1) '  -I 5 > M_2048.txt'];disp(t1);eval(t1);


