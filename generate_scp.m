function generate_scp()
%
%
fid1=fopen('C:\SRE04\SRE04M_LI.txt');
fid2=fopen('C:\SRE04\SRE04M_LI_new.txt','w');
filenum =0; % file number
NotExistFileNum = 0;
speakernum =0; % speaker number
while 1
    tline = fgetl(fid1);
    if ~ischar(tline), break, end
    if ~isempty(strfind(tline,':')) % if ':' is contained in tline
        fid3 = fopen([tline, '.pcm']); % open pcm file
        if fid3 ~= -1 % if file exists (can be opened)
            fprintf(fid2,'%s\n',[tline, '.pcm']); % write a line into fid2
            filenum = filenum + 1; % file number increase by 1
            disp(tline);
            fclose(fid3);
        else
            sprintf('This file does not exist:\n %s\n', tline)            
            NotExistFileNum = NotExistFileNum + 1; % number of not exist file increase by 1
        end        
    elseif ~isempty(strfind(tline, '_'))
        fprintf(fid2,'%s\n',tline); % write a line into fid2    
        speakernum = speakernum + 1; % speaker number increase by 1
        disp(tline);
    end         
end
fclose(fid1);
fclose(fid2);
sprintf('file number is: %d\n', filenum)
sprintf('speaker number is: %d\n', speakernum)
sprintf('umber of not exist file is: %d\n', NotExistFileNum)
disp('finished!')