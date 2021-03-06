function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

Y = zeros(m, num_labels);
for i=1:m
   Y(i, y(i)) = 1; 
end

X = [ones(m, 1) X];
z2 = X * (Theta1');
a2 = sigmoid(z2);        % 5000 * 25

hiden = [ones(m, 1) a2];
all_p = sigmoid(hiden * (Theta2'));    % 5000 * 10

sum = 0;
theta1_sum = 0;
theta2_sum = 0;

for i=1:m
    sum = sum + Y(i,:)*log(all_p(i,:)')+(1-Y(i,:))*log(1-all_p(i,:)');
end

for j=1:hidden_layer_size
    theta1_sum = theta1_sum + Theta1(j,2:end)*(Theta1(j,2:end)');
end

for k=1:num_labels
    theta2_sum = theta2_sum + Theta2(k,2:end)*(Theta2(k,2:end)');
end

J = (-1/m) * sum + (lambda/(2*m))*(theta1_sum+theta2_sum);



% -------------------------------------------------------------

delta2 = zeros(m, hidden_layer_size-1);
delta3 = all_p - Y;     %5000*10

for i=2:hidden_layer_size+1
    delta2(:,i-1) = delta3*Theta2(:,i) .* sigmoidGradient(z2(:,i-1));
end

Delta12 = zeros(hidden_layer_size,input_layer_size);
Delta23 = zeros(num_labels,hidden_layer_size);

for i=1:m
    Delta12 = Delta12 + delta2(i,:)'*X(i,2:end);
    Delta23 = Delta23 + delta3(i,:)'*a2(i,:);
end

Delta12 = [Theta1(:,1) Delta12];
Delta23 = [Theta2(:,1) Delta23];

Theta1_grad = (1/m) * Delta12;
Theta2_grad = (1/m) * Delta23;

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];

end