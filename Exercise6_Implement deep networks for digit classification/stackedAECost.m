function [ cost, grad ] = stackedAECost(theta, inputSize, hiddenSize, ...
                                              numClasses, netconfig, ...
                                              lambda, data, labels)
%����������ڼ���ջʽ��ʧ���ݶȣ���ʵӦ�ý����ݶȼ��                                         
% stackedAECost: Takes a trained softmaxTheta and a training data set with labels,
% and returns cost and gradient using a stacked autoencoder model. Used for
% finetuning.
                                         
% theta: trained weights from the autoencoder
% visibleSize: the number of input units
% hiddenSize:  the number of hidden units *at the 2nd layer*
% numClasses:  the number of categories
% netconfig:   the network configuration of the stack
% lambda:      the weight regularization penalty
% data: Our matrix containing the training data as columns.  So, data(:,i)
% is the i-th training example. %���ݰ��б�ʾ
% labels: A vector containing labels, where labels(i) is the label for the
% i-th training example


%% Unroll softmaxTheta parameter

% We first extract the part which compute the softmax gradient
%������ȡsoftmax�Ĳ���
softmaxTheta = reshape(theta(1:hiddenSize*numClasses), numClasses, hiddenSize);%�����*�ڶ�����ڵ���

% Extract out the "stack"
%��ȡ����Ĳ���
stack = params2stack(theta(hiddenSize*numClasses+1:end), netconfig);

% You will need to compute the following gradients
softmaxThetaGrad = zeros(size(softmaxTheta));
stackgrad = cell(size(stack));
for d = 1:numel(stack)
    stackgrad{d}.w = zeros(size(stack{d}.w));
    stackgrad{d}.b = zeros(size(stack{d}.b));%������
end
cost = 0; % You need to compute this

% You might find these variables useful
m = size(data, 2);%������
groundTruth = full(sparse(labels, 1:m, 1));


%% --------------------------- YOUR CODE HERE -----------------------------
%  Instructions: Compute the cost function and gradient vector for 
%                the stacked autoencoder.
%
%                You are given a stack variable which is a cell-array of
%                the weights and biases for every layer. In particular, you
%                can refer to the weights of Layer d, using stack{d}.w and
%                the biases using stack{d}.b . To get the total number of
%                layers, you can use numel(stack).
%
%                The last layer of the network is connected to the softmax
%                classification layer, softmaxTheta.
%
%                You should compute the gradients for the softmaxTheta,
%                storing that in softmaxThetaGrad. Similarly, you should
%                compute the gradients for each layer in the stack, storing
%                the gradients in stackgrad{d}.w and stackgrad{d}.b
%                Note that the size of the matrices in stackgrad should
%                match exactly that of the size of the matrices in stack.
%
%1��ǰ����㼤���
depth = numel(stack);%����������Ĳ���
%��¼�����
a = cell(depth+1,1);
a{1} = data;
% for i=2:numel(a)
%    %ǰ����㼤���
%    %a{i} = sigmoid(stackgrad{i-1}.w*a{i-1}+repmat(stackgrad{i-1}.b,1,netconfig.layersizes(i)));
%    a{i} = sigmoid(stackgrad{i-1}.w*a{i-1}+repmat(stackgrad{i-1}.b,1,size(a{i-1}.w,2)));
% end
for i=2:numel(a)  
     a{i} = sigmoid(stack{i-1}.w*a{i-1}+repmat(stack{i-1}.b, [1 size(a{i-1}, 2)]));  
     %Jweight = Jweight + sum(sum(stack{i-1}.w).^2);  
end


%2������softmax�Ĵ��ۺ���
%���ȷ�ֹ���
M = bsxfun(@minus, softmaxTheta*a{depth+1}, max(softmaxTheta*a{depth+1}, [], 1));
M = exp(M);  
P = bsxfun(@rdivide, M, sum(M));  

%������ۺ���
cost = (-1/m).*groundTruth(:)' * log(P(:)) + (lambda/2) * sum(softmaxTheta(:).^2);
%�����ݶ�
softmaxThetaGrad = (-1/m) .* (groundTruth - P)*a{depth+1}' + lambda*softmaxTheta;

%3����������Ĵ��ۺ�����������ݶ�(���÷��򴫲�)
delta = cell(depth+1,1);
%���������Ĳв�  
delta{depth+1} = -softmaxTheta' * (groundTruth - P) .* a{depth+1} .* (1 - a{depth+1});
% %��������в�
for i= depth:-1:2  %��Ϊdelta{1}�����ò���
    delta{i} = stack{i}.w' * delta{i+1} .* a{i}.*(1-a{i});
end 


% ͨ��ǰ��õ������������ز�Ĳв�������ز�������ݶ�
for i=depth:-1:1
    stackgrad{i}.w = 1/m .* delta{i+1}*a{i}';
    stackgrad{i}.b = 1/m .* sum(delta{i+1}, 2);
end
% -------------------------------------------------------------------------
%% Roll gradient vector
grad = [softmaxThetaGrad(:) ; stack2params(stackgrad)];

end


% You might find this useful
function sigm = sigmoid(x)
    sigm = 1 ./ (1 + exp(-x));
end
