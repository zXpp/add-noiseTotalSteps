function GenerateTrueFalseMatrix()

load MFCC % load feature file
load NormScoreMFCC; % load scores matrix
TFmatrix = []; % save flag of True or False
filenum = zeros(1, size(MFCC, 1)); % file number of each speaker
for i = 1 : size(MFCC, 1)
    temp1 = 0;
    for j = 1 : size(MFCC, 2)
        if ~isempty(MFCC{i, j}) 
            temp1 = temp1 + 1;
        end
    end
    filenum(i) = temp1; % file number for the i-th speaker
end

TrueIndex = [];
temp2 = 0;
k = 0;
for i = 1 : length(filenum)
    if filenum(i) ~= 0
		k = k + 1; % number of non-empty element increases by 1
		if k == 1
			TrueIndex(k, 1) = 1;
			TrueIndex(k, 2) = filenum(i);
			temp2 = temp2 + filenum(i); % sum of file number until the i-th speaker
		else
			TrueIndex(k, 1) = TrueIndex(k-1, 2) + 1;
			TrueIndex(k, 2) = filenum(i) + temp2;
			temp2 = temp2 + filenum(i); % sum of file number until the i-th speaker
		end
	end
end
    
T = []; % true matrix
F = []; % false matrix
IndexMatrix = zeros(size(NormScoreMFCC)); % 0: false elements; 1: true elements
for i = 1 : length(TrueIndex)
    IndexMatrix(TrueIndex(i, 1): TrueIndex(i, 2), TrueIndex(i, 1): TrueIndex(i, 2)) = 1; % indexes of true elements
end

for i = 1 : size(NormScoreMFCC, 1)
    for j = 1 : size(NormScoreMFCC, 2)
        if IndexMatrix(i, j) == 1 && j ~= i % exclude the first socre (self-evaluated)
            T = [T NormScoreMFCC(i, j)];
        elseif IndexMatrix(i, j) == 0
            F = [F NormScoreMFCC(i, j)];
        end
    end
end
save MFCC_T T; % save True matrix
save MFCC_F F; % save False matrix
% disp(T);
% disp(F);

