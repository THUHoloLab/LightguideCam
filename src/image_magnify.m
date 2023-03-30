function output=image_magnify(input,rate_y)
    [s1,s2]=size(input);
    m=round([s1,s2].*[1,rate_y]./2).*2;
    if rate_y>=1
        output=imresize(input,m);
        output=output(m(1)/2-s1/2+1:s1/2+m(1)/2,m(2)/2-s2/2+1:s2/2+m(2)/2);
    else
        output=zeros(s1,s2,'gpuArray');
        output(s1/2-m(1)/2+1:s1/2+m(1)/2,s2/2-m(2)/2+1:s2/2+m(2)/2)=imresize(input,m);
    end
end