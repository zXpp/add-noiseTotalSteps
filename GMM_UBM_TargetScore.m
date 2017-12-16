function S = GMM_UBM_TargetScore(X,NTopIndices,TargetGMM);
% function S = GMM_UBM_TargetScore(X,NTopIndices,TargetGMM);
%
% Efficient background model scoring which takes advantage of the
% hierarchical structure between UBM and the adapted model. Ratio of
% average log likelihoods for the target and UBM is returned.
%
% X = {x1,...,xT} is the sequence of observation vectors, one per row.
% NTopIndices contains the indices which are to be scored in TargetGMM.
% TargetGMM is a GMM for the target speaker given in a struct.

if (size(X,1) ~= size(NTopIndices,1))
    error('X and NTopIndices must have equal number of rows.');
end;
VerySmallNumber = 1e-200;

M = getfield(TargetGMM,'MeanVecs');
V = getfield(TargetGMM,'VarVecs');
W = getfield(TargetGMM,'MixWeights');

LogSum = 0;
ProblemCount = 0;
for t=1:size(X,1)
    Mt = M(NTopIndices(t,:),:);
    Vt = V(NTopIndices(t,:),:);
    Wt  = W(NTopIndices(t,:),:);
    [Foo,CompDensities] = GMMdensity(X(t,:),Mt,Vt,Wt);
    ApproxDensity = sum(CompDensities .* Wt);
    if (~isnan(ApproxDensity))
        LogSum = LogSum + log(ApproxDensity);
    else
        disp(sprintf('Problem with vector %i',t));
        ProblemCount = ProblemCount + 1;
    end;
end;
if (ProblemCount > 0)
    warning(sprintf('%i frames yielded NaN density, they were skipped.',ProblemCount));
end;
S = LogSum/size(X,1);