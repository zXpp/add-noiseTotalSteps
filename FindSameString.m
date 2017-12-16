function FindSameString()
%
%
fid1=fopen('C:\SRE04\SRE04M_LI_new_temp.txt');
str = {};
i = 1;
while 1
    tline = fgetl(fid1);
    if ~ischar(tline), break, end
    str{i} = tline;         
    i = i + 1;
end

for i = 1 : length(str)
    for j = i+1 : length(str)
        str1 = str{i};
        str2 = str{j};
        if ~isempty(strfind(str1, str2)) || ~isempty(strfind(str1, str2))
            sprintf('str1 is: %s, str2 is: %s', str1, str2)
        end
    end
end
fclose(fid1);
