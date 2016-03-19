clc
clear all
close all
[file path]=uigetfile('Regha.jpg','Pilih Gambar');
gbr=imread([path file]);
imshow(gbr)
gbrycbcr=rgb2ycbcr(gbr); %step 1
cr=gbrycbcr(:,:,3); %step 2
figure;
imshow(cr)
mask=zeros(size(cr));
ix=cr > 140 & cr < 150;
mask(ix)=1;
figure;
imshow(mask)
mask2=bwareaopen(mask,10000);
figure;
imshow(mask2)
s=regionprops(mask2,'BoundingBox');
bbox=round(cat(1,s.BoundingBox));
box=[];
for k=1:size(bbox,1)
    h=bbox(k,4);
    w=bbox(k,3);
    r=h/w;
    if r>1 && r<2
       box=[box;bbox(k,:)];
    end
end
box(:,4)=0.9*box(:,4);
figure;
imshow(gbr);
for b=1:size(box,1);
    rectangle('Position',box(b,:),'edgecolor','r')
end

   

