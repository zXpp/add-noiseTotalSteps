function [P, CompDensities] = GMMdensity2(X,M,V,W);
% function [p, CompDensities] = GMMdensity2(X,M,V,W);
% Assuming diagonal covariance matrices, i.e. V contains variance vectors
% in its rows.
if (size(W, 1) > size(W, 2))
    W = W';
end;

%d = size(M,2);
%CompDensities = zeros(size(X, 1), size(M, 1));
%for k = 1:size(M, 1)
%    M2 = sum(((X - repmat(M(k, :), size(X, 1), 1)).^2)./repmat(V(k, :), size(X, 1), 1), 2);
%    CompDensities(:, k) = exp(-0.5 * M2) ./ (((2*pi)^(d/2)) * prod(sqrt(V(k, :))));
%end;

CompDensities = CalcDensity(X,M,V);

P = sum(repmat(W, size(X, 1), 1) .* CompDensities, 2);