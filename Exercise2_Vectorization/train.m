%% CS294A/CS294W Programming Assignment Starter Code
% �����ǵڶ�����ҵ������д�ַ�����������ȡ
%��Ҫ�ı��ֻ�����ݶ�ȡ����ʼ�����仯��ȥ�����ݶȼ���
visibleSize = 28*28;   % number of input units 
hiddenSize = 196;     % number of hidden units 
sparsityParam = 0.1;   % desired average activation of the hidden units.
                     % (This was denoted by the Greek alphabet rho, which looks like a lower-case "p",
		     %  in the lecture notes). 
lambda = 3e-3;     % weight decay parameter       
beta = 3;            % weight of sparsity penalty term       

%  After implementing sampleIMAGES, the display_network command should
%  display a random sample of 200 patches from the dataset

% Change the filenames if you've saved the files under different names
% On some platforms, the files might be saved as 
% train-images.idx3-ubyte / train-labels.idx1-ubyte
%�����������ĳ����ȡͼ�����ݺͱ�ǩ����ǩ��ʱ����Ҫ��ȡ
images = loadMNISTImages('train-images.idx3-ubyte');
labels = loadMNISTLabels('train-labels.idx1-ubyte');
 
% We are using display_network from the autoencoder code
display_network(images(:,1:100)); % Show the first 100 images
disp(labels(1:10));
patches = images(:,1:10000);%��10000��ͼƬѵ��


theta = initializeParameters(hiddenSize, visibleSize);

%  Use minFunc to minimize the function
addpath minFunc/
options.Method = 'lbfgs'; % Here, we use L-BFGS to optimize our cost
                          % function. Generally, for minFunc to work, you
                          % need a function pointer with two outputs: the
                          % function value and the gradient. In our problem,
                          % sparseAutoencoderCost.m satisfies this.
options.maxIter = 400;	  % Maximum number of iterations of L-BFGS to run 
options.display = 'on';

%������ֱ�ӵ���minFunc������С��Ŀ�꺯��
[opttheta, cost] = minFunc( @(p) sparseAutoencoderCost(p, ...
                                   visibleSize, hiddenSize, ...
                                   lambda, sparsityParam, ...
                                   beta, patches), ...
                              theta, options);


%����ǿ��ӻ�ϡ���Ա�����ѵ�����������Ĵ��벻�Ǻ�����
W1 = reshape(opttheta(1:hiddenSize*visibleSize), hiddenSize, visibleSize);
display_network(W1', 12); 

print -djpeg weights.jpg   % save the visualization to a file 


