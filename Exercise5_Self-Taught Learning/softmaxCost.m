function [cost, grad] = softmaxCost(theta, numClasses, inputSize, lambda, data, labels)

% numClasses - the number of classes �����
% inputSize - the size N of the input vector�������ݵ�������
% lambda - weight decay parameter�ͷ�ϵ��
% data - the N x M input matrix, where each column data(:, i) corresponds to
%        a single test set
% labels - an M x 1 matrix containing the labels corresponding for the
% input data����label��һ��������
%

% Unroll the parameters from theta
theta = reshape(theta, numClasses, inputSize);

numCases = size(data, 2);%����������

%�����Ŀ���ǲ���һ��ϡ����󲢰�����ȫ����.����Ϊ����һ��lables*numCases��С�ľ���
%���ĵ�labels(i)�е�i�е�Ԫ��ֵΪ1������ȫΪ0������iΪ1��numCases
groundTruth = full(sparse(labels, 1:numCases, 1));
cost = 0;

thetagrad = zeros(numClasses, inputSize);%�����*data�����ľ��������groundTruth�ĳߴ�����ͬ��

%% ---------- YOUR CODE HERE --------------------------------------
%  Instructions: Compute the cost and gradient for softmax regression.
%                You need to compute thetagrad and cost.
%                The groundTruth matrix might come in handy.

%����Ϊ�˷�ֹexp(theta*x)��ֵ̫�����overflow������������Ǹ����е�theta*x��ȥ
%һ������ֵ�����ı���������ڿμ��ｲ���ˣ������ֵ������xi�����������theta*xi�����ֵ
%max(A,[],1)%ÿһ�е���ֵ���õ��������ȼ���max(A)
%max(A,[],2)%ÿһ�е���ֵ���õ����������ȼ���max(A(:,:))
%max(max(A))�ȼ���max(A(:))
%������theta*data��ȥ�����ֵ��������������bsxfun�������repmat��һ��
%Ŀ���Ƿ�ֹ���
M = bsxfun(@minus,theta*data,max(theta*data, [], 1));

M = exp(M);
P = bsxfun(@rdivide,M,sum(M));%sum(M)Ҳ�Ǹ�������
%������ۺ���
%����1
cost = (-1/numCases)*(groundTruth(:)'*log(P(:))) + lambda/2 * sum(theta(:).^2);
%����2
%cost = (-1/numCases).*sum(sum(groundTruth'*log(p))) + lambda/2 *sum(sum(theta.^2))
%���ż����ݶ�
thetagrad = (-1/numCases)*(groundTruth - P)*data' + lambda * theta;




% ------------------------------------------------------------------
% Unroll the gradient matrices into a vector for minFunc
grad = [thetagrad(:)];
end

