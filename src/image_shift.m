function output=image_shift(input,x,y)
    [sx,sy]=size(input);
    output=zeros(sx,sy,'gpuArray');
    if x>=0 && y>=0
        output(x+1:sx,y+1:sy)=input(1:sx-x,1:sy-y);
    elseif x<0 && y<0
        output(1:sx+x,1:sy+y)=input(-x+1:sx,-y+1:sy);
    elseif x>=0 && y<0
        output(x+1:sx,1:sy+y)=input(1:sx-x,-y+1:sy);
    elseif x<0 && y>=0
        output(1:sx+x,y+1:sy)=input(-x+1:sx,1:sy-y);
    end 
end