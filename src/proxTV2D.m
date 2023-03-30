function [x] = proxTV2D(b,lambda,iter_num)
%PROXTV2D with FGP method

[n1,n2] = size(b);
pq = zeros(n1,n2,2,'gpuArray');
rs = zeros(n1,n2,2,'gpuArray');
t=1;

for i=1:iter_num
    t_prev=t;
    w_prev=pq;
    
    w_temp=1/8/lambda*grad(Proj_C(b-lambda*div(rs)));
    pq=Proj_P(rs+w_temp);
    
    t=(1+sqrt(1+4*t^2))/2;
    
    rs=pq+(t_prev-1)/t*(pq-w_prev);
end
x=Proj_C(b-lambda*div(pq));
end



function [g] = grad(u)
%gradient
    g(:, :, 1) = [-diff(u, 1, 1); u(end,:)];
    g(:, :, 2) = [-diff(u, 1, 2), u(:,end)];
end

function [d] = div(g)
%gradient adjoint
    d1=[-g(1, :, 1) ; diff(g(:, :, 1), 1, 1)];
    d2=[-g(:, 1, 2) , diff(g(:, :, 2), 1, 2)];
    d=d1+d2;
end

function [y] = Proj_C(x)
    y=min(max(x,0),1);
end

function [y] = Proj_P(x)
    y=min(max(x,-1),1);
end