function output = forward_model_2D(input,PSF_distribution,overlap_num,distance)
%FORWARD_MODEL_2D 此处显示有关此函数的摘要
%   distance (m)
[size_x,size_y]=size(input);

%The PSF distribution having 200 pixels is calibrated with original size_x=2056 pxiels, at 0.5m
shift_max=200*size_x/2056*(0.5/distance);  %The shift distance decreases linearly with the distance
magnify_max=1+0.023715*(0.5/distance);      %The magnify rate decreases linearly with the distance

shift_seq=round(linspace(0,shift_max,overlap_num));
magnify_seq=linspace(1,magnify_max,overlap_num);

PSF_distribution_resize=imresize(PSF_distribution,[size_x,overlap_num]);

PSF_distribution_resize=PSF_distribution_resize.*200./overlap_num; %Compensate the enengy loss casued by imresize by increasing intensity; 200 is the calibration size

output=zeros(size_x,size_y,'gpuArray');
for i=1:overlap_num
    magnified_image=image_magnify(input,magnify_seq(i));
    shifted_image=image_shift(magnified_image,shift_seq(i),0);
    masked_image=shifted_image.*(PSF_distribution_resize(:,i)*ones(1,size_y));
    output=output+masked_image;
end

end
