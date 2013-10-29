function f1 = nodeCalcF1( gt, est, mod )
% f1 = nodeCalcF1( gt, est )
% Calculates the hierarchical f1-score by comparing a grount truth sparse
% matrix label structure to an estimated sparse matrix
%
% Arguments:
%   gt      - Ground truth sparse matrix
%   est     - Estimated sparse matrix
%   mod     - Modified F1 (See Bewley 2013, CVPR workshop)
%
% Returns:
%   f1      - Hierarchical f1-score
%
% Author:   Navid Nourani-Vatani
% Version:  1.0 2013-08-02
%           1.1 2013-10-29 added the ability to calculate the modified F1
%           score. 

if nargin < 3
    mod = false;
end

tp = sum( and(gt, est) );

if mod == false
    fpfn = sum( xor(gt, est) );
else
    endi = find(gt>0, 1, 'last');
    fpfn = 0;
    for i = 1:endi
        if gt(i) ~= est(i), fpfn = fpfn+1; end
    end
end
f1 = 2*tp / (2*tp+fpfn);

end
