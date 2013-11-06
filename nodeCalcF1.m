function f1 = nodeCalcF1( tree, gt, est, mod )
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
% disp(gt')
% disp(est')

tp = sum( and(gt, est) );
if mod == false
    fpfn = sum( xor(gt, est) );
else
    endi = length(gt);
    nGT = find(gt>0, 1, 'last')-1; % -1 because first node is 0
    nEst = find(est>0, 1, 'last')-1;
    if isParent(tree, nGT) && isChield(tree, nGT, nEst)
        endi = nGT;
    end
    
    fpfn = 0;
    for i = 1:endi
        if gt(i) ~= est(i), fpfn = fpfn+1; end
    end
end

f1 = 2*tp / (2*tp+fpfn);
% fprintf( 'tp=%d, fpfn=%d => f1=%.2f\n', tp, fpfn, f1)

%% helper functions
    function p = isParent(tree, n)
        % Is n a parent node?
        node = nodeAt( tree, n );
        p = ~isempty( node.children );
%         if p == true
%             fprintf('node %d is a parent\n', node.num)
%         end
    end

    function c = isChield(tree, n1, n2)
        c = false;
        % Is the n2 and chield of n1?
        node1 = nodeAt(tree, n1);
        node2 = nodeAt(tree, n2);
%         fprintf( 'is node %d child of node %d?\n', node2.num, node1.num )
        % go through all the child nodes of n1 and see if n2 is there
        cList = {};
        for i = 1:length(node1.children)
            cList{end+1} = node1.children{i};
        end
        while ~isempty(cList)
            if cList{1}.num == node2.num
%                 fprintf('\tYES!\n')
                c = true;
                break;
            end
%             fprintf( '\tNot node %d\n', cList{1}.num )
            
            % add child nodes and delete current node
            for i = 1:length(cList{1}.children)
                cList{end+1} = cList{1}.children{i};
            end
            cList = cList(2:end);
        end
    end
    
end
