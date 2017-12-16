function [p, CompDensities] = GMMdensity(x,M,V,W);
% function [p, CompDensities] = GMMdensity(x,M,V,W);
% Assuming diagonal covariance matrices, i.e. V contains variance vectors
% in its rows.

if (size(W,2)>size(W,1)) % row vec
    W = W';
end;

d = size(M,2);
MahDists = sum(((repmat(x,size(M,1),1) - M).^2)./V,2);

% for i=1:size(M,1)
%     if (isnan(MahDists(i)))
%         disp(i);
%         disp(M(i,:));
%         disp(V(i,:));
%         pause;
% %        Foo1 = sum(x - M(i,:)).^2;
% %        Foo2 = V(i,:);
% %        disp(Foo1);
% %       disp(Foo2);
%     end;
% end;

CompDensities = exp(-0.5 .* MahDists) ./ (((2*pi)^(d/2)) .* prod(sqrt(V),2));

p = sum(W .* CompDensities);