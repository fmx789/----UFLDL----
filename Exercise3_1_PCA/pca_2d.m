close all

%%================================================================
%% Step 0: Load data
%  We have provided the code to load data from pcaData.txt into x.
%  x is a 2 * 45 matrix, where the kth column x(:,k) corresponds to
%  the kth data point.Here we provide the code to load natural image data into x.
%  You do not need to change the code below.

x = load('pcaData.txt','-ascii');
figure(1);
scatter(x(1, :), x(2, :));
title('Raw data');


%%================================================================
%% Step 1a: Implement PCA to obtain U 
%  Implement PCA to obtain the rotation matrix U, which is the eigenbasis
%  sigma. 

% -------------------- YOUR CODE HERE -------------------- 
u = zeros(size(x, 1)); % You need to compute this
[n m] = size(x);
j = mean(x,2);
z = x-repmat(j,1,m);%Ԥ������ֵΪ0
sigma = (1.0/m)*z*z';
[u s v] = svd(sigma);


% -------------------------------------------------------- 
hold on
plot([0 u(1,1)], [0 u(2,1)]);%����һ����
plot([0 u(1,2)], [0 u(2,2)]);%�ڶ�����
scatter(z(1, :), z(2, :));
hold off

%%================================================================
%% Step 1b: Compute xRot, the projection on to the eigenbasis
%  Now, compute xRot by projecting the data on to the basis defined
%  by U. Visualize the points by performing a scatter plot.

% -------------------- YOUR CODE HERE -------------------- 
xRot = zeros(size(z)); % You need to compute this
xRot = u'*z;%��ת�������


% -------------------------------------------------------- 

% Visualise the covariance matrix. You should see a line across the
% diagonal against a blue background.
figure(2);
scatter(xRot(1, :), xRot(2, :));
title('xRot');


%%================================================================
%% Step 2: Reduce the number of dimensions from 2 to 1. 
%  Compute xRot again (this time projecting to 1 dimension).
%  Then, compute xHat by projecting the xRot back onto the original axes 
%  to see the effect of dimension reduction

% -------------------- YOUR CODE HERE -------------------- 
k = 1; % Use k = 1 and project the data onto the first eigenbasis
xHat = zeros(size(x)); % You need to compute this

%����1:����ת��������kά�Ժ��������Ϊ0
% xRot(2,:) = 0;
% % figure(3);���Ի���������
% % scatter(xRat(1, :), xRat(2, :));
% % title('xRat_del');
% xHat = u* xRot;
%����2,ͶӰʱȷ�������ͶӰ����
xHat = u*([u(:,1),zeros(n,1)]'*z);
% -------------------------------------------------------- 
figure(3);
scatter(xHat(1, :), xHat(2, :));
title('xHat');


%%================================================================
%% Step 3: PCA Whitening
%  Complute xPCAWhite and plot the results.

epsilon = 1e-5;
% -------------------- YOUR CODE HERE -------------------- 
xPCAWhite = zeros(size(x)); % You need to compute this
%����PCA�׻������а׻�Ҫ��������������ԵͲ������������ķ�����ͬ��
%PCA�Ѿ�û���������䲻��أ�ֻҪ����������ͬ�ķ���ɡ�
%����Э���ʽΪCov(X,Y)=E(XY)-E(X)E(Y)������ֻҪ֪����Э���Ҳ���Ƿ�����ɣ���ʱ��һ�����۾������Э�������ĶԽ���ǡ��������ֵs���ǶԽ���Ԫ��Ϊ0

xPCAWhite = diag(1./sqrt(diag(s)+epsilon))*xRot;%����������s��Ϊ�Խ������һ����ƫ�÷�����ܻᵼ�����磬��ȡ���Խ�Ԫ�أ���������
%��дΪ(1./sqrt(diag(S) + epsilon)) * u' * z;

% -------------------------------------------------------- 
figure(4);
scatter(xPCAWhite(1, :), xPCAWhite(2, :));
title('xPCAWhite');

%%================================================================
%% Step 3: ZCA Whitening
%  Complute xZCAWhite and plot the results.
% ZCA�׻���������PCA����������ת���ǲ�����ά��Ȼ���PCA���а׻������׻����������ת��ԭʼ���꣬�͵õ���ZCA�׻�
% -------------------- YOUR CODE HERE -------------------- 
xZCAWhite = zeros(size(x)); % You need to compute this
xZCAWhite = u*xPCAWhite;%����дΪu*(1./sqrt(diag(S) + epsilon)) * u' * z;

% -------------------------------------------------------- 
figure(5);
scatter(xZCAWhite(1, :), xZCAWhite(2, :));
title('xZCAWhite');

%% Congratulations! When you have reached this point, you are done!
%  You can now move onto the next PCA exercise. :)
