function x=FISTA(b,A,A_adj,lambda,iter_num)

Lip=1;
prox_iter_num=20;   % Max iterations of the sub loop
t=1;

[n1,n2]=size(b);


x=zeros(size(A_adj(b)),'gpuArray');
y=x;
res=zeros(1,iter_num);


for i=1:iter_num
x_prev=x;
t_prev=t;


x=proxTV2D(y-dF(y)/Lip,lambda/Lip,prox_iter_num);


t=(1+sqrt(1+4*t^2))/2;
y=x+(t_prev-1)/t*(x-x_prev);

res(i)=norm(A(x)-b);
fprintf(['iter= ' ,num2str(i), ' | residual= ' ,num2str(res(i)), '\n'])
end



function val = dF(x)
    val = A_adj(A(x)-b);
end

end
