% function is to save the Cep or model data in binary format;
% data must be in N by M dimension N is number of length frame 
% M is vector dimension.   e.g  100000 by 30
% also can be used to save model in binary format;
%fseek(fid,'bof');fseek(fid,'eof');
%'bof' or -1   Beginning of file
%'eof' or  1   End of file
%fod = fopen(spkSVM_Format,'r+b'); 
% N=[100000 38] format;

function saveb1(file,data,N,Y);  

% if size(data,2)>100;
%     disp(['are you sure the feature dimension is greater than 100  pause;']);
%     %pause;
% end
if Y==1;
fid1=fopen(file,'wb');
fwrite(fid1,N,'int32');
for j=1:size(data,1);
     fwrite(fid1,data(j,:),'float');
end
fclose(fid1);
else
    
fid1=fopen(file,'r+b');
fseek(fid1,0,-1);
fwrite(fid1,N,'int32');
fseek(fid1,0,1);
for j=1:size(data,1);
     fwrite(fid1,data(j,:),'float');
end
fclose(fid1);
  
end


       

