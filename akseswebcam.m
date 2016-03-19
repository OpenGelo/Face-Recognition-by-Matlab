clc
clear all
close all
vid=videoinput('winvideo',1,'RGB24_640x480');
% preview(vid)
src=getselectedsource(vid);
src.FrameRate='10';
triggerconfig(vid, 'Manual');
set(vid,'TriggerRepeat',Inf);
set(vid,'FramesPerTrigger',1);
start(vid);
trigger(vid);
prevframe=getdata(vid,1);
hshow=imshow(prevframe);
set(hshow,'EraseMode','none')

for k=1:500
    trigger(vid);
    frame=getdata(vid,1);
%     diff=imabsdiff(prevframe,frame);
%     buf=[buf sum(sum(sum(diff)))];
%     
    set(hshow,'CData',frame)
    drawnow
%     prevframe=frame;
end
stop(vid)