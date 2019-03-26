clc;
clear all;
imaqreset;
z=imaqhwinfo
y=imaqhwinfo('winvideo')
dev_info = imaqhwinfo('winvideo',2)
celldisp(dev_info.SupportedFormats)
