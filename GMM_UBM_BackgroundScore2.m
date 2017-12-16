function [S,TopIndices] = GMM_UBM_BackgroundScore2(X,UBM,NTop);

% function [S,TopIndices] = GMM_UBM_BackgroundScore2(X,UBM,NTop);
% Scores a diagonal cov. Gaussian mixture model for an i.i.d.
% sample X = {x1,...,xT} as the average log likelihood, i.e.
%
%   S = (1/T) * sum_{t=1}^T log p(x_t|UBM).
%
% The NTop top scoring Gaussian component indices are also given
% for each test vector. These can be used in efficient background model
% scoring by scoring the NTop mixture components only from the target
% model. Notice: this makes sense only if the target models are adapted
% from the background model!

UBM_M = getfield(UBM,'MeanVecs');
UBM_V = getfield(UBM,'VarVecs');
UBM_W = getfield(UBM,'MixWeights');

[P,CompDensities] = GMMdensity2(X,UBM_M,UBM_V,UBM_W);
[FooVal,FooInd] = sort(CompDensities, 2);
FooInd = fliplr(FooInd);
TopIndices = FooInd(:, 1:NTop);

S = sum(log(P))/length(P);