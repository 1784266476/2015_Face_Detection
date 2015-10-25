clear;
p = './your_image_dir/';
subdir = dir(p);
count = 1;%pic_count
incount = 1;%in_count
correct = 0;
wrong = 0;
discrete = 0;
global net12;
global net12_c;
global net24;
global net24_c;
global net48;
global net48_c;
net12 = load('12net-newborn/f12net.mat') ;
net12_c = load('12net-cc-v1/f12net_c.mat') ;
net24 = load('24net-newborn/f24net-cpu.mat') ;
net24_c = load('24net-cc-v1-no256/f24netc.mat') ;
net48 = load('48net-newborn/f48net-cpu.mat') ;
net48_c = load('48net-cc-cifar-v2-submean/f48netc.mat') ;
for i=1:length(subdir)
    if( isequal( subdir( i ).name, '.' ) || ...
        isequal( subdir( i ).name, '..' ) )   
        continue;
    end
    if( isempty(strfind(subdir( i ).name,'jpg')))   
        continue;
    end
       tline = strcat(p,subdir(i).name);
       img = imread(tline);
       [~,~,c]=size(img);
       if c==1
           img=repmat(img,[1,1,3]);
       end
       boxes = [];
       imshow(img);
       tic;
       for tt=1:1
          I = img;
          tform = affine2d([tt 0 0; 0 1 0; 0 0 1]);
          J = imwarp(I,tform);
          boxes_temp = scanpic_fast_only12_24_48_newmodel_submean(J,tt);   %%
          boxes = [boxes;boxes_temp];
       end
       toc;
       if ~isempty(boxes)
         pick = nms(boxes,0.2);
         boxes = boxes(pick,:);
         x1 = boxes(:,1);
         y1 = boxes(:,2);
         x2 = boxes(:,3);
         y2 = boxes(:,4);
         boxes_size = size(boxes);
         for xx = 1:boxes_size(1)
           rectangle('Position',[y1(xx),x1(xx),(y2(xx)-y1(xx)),x2(xx)-x1(xx)],'LineWidth',2,'EdgeColor','b');
         end
       end 
end
