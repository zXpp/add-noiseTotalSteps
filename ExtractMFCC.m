% extract MFCC

%% Read WAV file and Extract CQCC
clear
addpath C:\SRE04\othercodes\voicebox
MFCC = {}; % MFCC feature
filename = {};
fid1=fopen('C:\SRE04\SRE04M_LI_new.txt'); % list of PCM files
samplenum = 0; % sample number
speakernum = 0; % speaker number
while 1
    tline = fgetl(fid1);
    if ~ischar(tline), break, end
    if ~isempty(strfind(tline,':')) % if ':' is contained in tline                 
        samplenum = samplenum + 1; % sample number increase by 1
        
if speakernum > 20 % only read 20 speakers' segments
    break;
end

% if speakernum > 60 % only read 60 speakers' segments
%     break;
% elseif speakernum <= 20
%     continue;
% end

        [x, fs, nbits] = wavread([tline '.wav']); % read wav file
        [validSegment,validSegmentPoint,voicedsignal] = lyxSingapore_endPointDetect(x,fs,nbits,0);% VAD
        clear validSegment validSegmentPoint x % clear temporary variables       
        Cep = lyx_melcepst(voicedsignal,fs,'0edD')'; % MFCC extraction
        
        MFCC{speakernum, samplenum} = (Cep - repmat(mean(Cep),size(Cep,1),1))./(repmat(std(Cep),size(Cep,1),1)); % normalization
        clear Cep;
        
        filename{speakernum, samplenum} = tline; % save the corresponding file name
        save MFCC MFCC; % save MFCC to hard disc
        save MFCCfilename filename               
    elseif ~isempty(strfind(tline, '_'))  % new speaker occurs      
        speakernum = speakernum + 1; % speaker number increase by 1
    end
    sprintf('speakernum is: %d, samplenum is: %d\n', speakernum, samplenum)
    sprintf('current file name is: %s\n', tline)    
end
fclose(fid1);
save MFCC MFCC; % save MFCC to hard disc
save MFCCfilename filename
