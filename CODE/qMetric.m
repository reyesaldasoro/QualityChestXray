
% A Code to analyse the x-rays that have been collected by Cohen in Github: 
%    https://github.com/ieee8023/covid-chestxray-dataset

clear all
close all

%%
% The data has been downloaded to a local drive, the folder below contains the images as well as the metadata
%cd('C:\Users\sbbk034\Desktop\test_images')
%cd('C:\Users\sbbk034\Desktop\train_images')
% Read folder
cd('D:\OneDrive - City, University of London\Acad\Research\COVID\CityMachineLearningGroup\test_images')


dir0 = dir('*.*g');
numImages                   = size(dir0,1);
%%
for k=16%:15  %:numImages
    disp(k)
    currImage                   = (imread(strcat('',dir0(k).name)));
    [quMetricTest(k),coord(k,:)] = QualityChestXray(currImage,1); 
end
%%
clear quM* coor*
%cd('D:\OneDrive - City, University of London\Acad\Research\COVID\CityMachineLearningGroup\train_images')
cd('D:\OneDrive - City, University of London\Acad\Research\COVID\CityMachineLearningGroup\test_images')
% Read folder
dir0 = dir('*.*g');
numImages                   = size(dir0,1);
quMetricTrain(numImages,1)    = 0;
coord(numImages,3)          = 0;
for k=1:numImages
    disp(k)
    currImage                   = (imread(strcat('',dir0(k).name)));
    [quMetricTrain(k),coord(k,:)] = QualityChestXray(currImage,0); 
end
%%
cd('C:\Users\sbbk034\Desktop\test_images')
dirTest = dir('*.*g');
cd('C:\Users\sbbk034\Desktop\train_images')
dirTrain = dir('*.*g');


%%
 k=4;%: TEST  16 42 44 47 60 61
        % TRAIN 3 9 10 21 32 39 40 1123
currImage                   = (imread(strcat('',dir0(k).name)));

quMetric = QualityChestXray(currImage,1);
% 
% clear x* y*
% 
% [rows,cols,levs]            = size(currImage);
% rr                          = 1:rows;
% cc                          = 1:cols;
% 
% medianProjVert              = median(currImage(:,:,1),2);
% medianProjHorz              = median(currImage(:,:,1),1);
% meanProjVert                = mean(currImage(:,:,1),2);
% meanProjHorz                = mean(currImage(:,:,1),1);
% minProjVert                 = min(currImage(:,:,1),[],2);
% minProjHorz                 = min(currImage(:,:,1),[],1);
% maxProjVert                 = max(currImage(:,:,1),[],2);
% maxProjHorz                 = max(currImage(:,:,1),[],1);
% 
% lineToAssess                = imfilter(double(medianProjHorz),[ones(1,9)]/9,'replicate');
% [x1,y1,w1,p1]=findpeaks(lineToAssess,'minpeakdistance',cols/10,'minpeakprominence',5);
% 
% % discard peaks next to the edges
% distToEdgeL                 = 40+ find(maxProjHorz,1,'first');
% distToEdgeR                 = -25+find(maxProjHorz>1,1,'last');
% x1(y1<distToEdgeL)=[];
% w1(y1<distToEdgeL)=[];
% p1(y1<distToEdgeL)=[];
% y1(y1<distToEdgeL)=[];
% x1(y1>distToEdgeR)=[];
% w1(y1>distToEdgeR)=[];
% p1(y1>distToEdgeR)=[];
% y1(y1>distToEdgeR)=[];
% 
% 
% %
% % Select the three most central
% distFromCentre = abs(y1-cols/2);
% if numel(y1)>3
% %     [q1,q2]=sort(distFromCentre);
% %     x11 = x1(q2(1:3));
% %     y11 = y1(q2(1:3));
%     % Select by distance from Centre, not always right
%     [q1,q2]=min(distFromCentre);
%     x11 = x1(q2-1:q2+1);
%     y11 = y1(q2-1:q2+1); 
%     % Select by prominence
%     [q1,q2] =sort(p1,'descend');
%     x11 = x1 (sort(q2(1:3)));
%     y11 = y1(sort(q2(1:3)));
%     
% elseif numel(y1)==2
%     % only 2 points
%     % Add a point left or right
%     if distFromCentre(2)>distFromCentre(1)
%         y11 = [max(1,y1(1)-distFromCentre(2))  y1];
%         x11 = [lineToAssess(y11(1))  x1];
%     else
%         y11 = [y1 min(cols,y1(2)+distFromCentre(1)) ];
%         x11 = [x1 lineToAssess(y11(end))];
%     end    
% else
%     % This assumes there are 3 points
%     x11 = x1;
%     y11 = y1;
% end
% % Calculate mid points
% leftMidPoint        = 0.5*y11(1)+0.5*y11(2);
% leftMidValue        = 0.5*x11(1)+0.5*x11(2);
% rightMidPoint        = 0.5*y11(3)+0.5*y11(2);
% rightMidValue        = 0.5*x11(3)+0.5*x11(2);
% maxValue            = double(max(currImage(:)));
% 
% 
% % find valleys
% [x2,y2]=findpeaks(-lineToAssess,'minpeakdistance',cols/10,'minpeakprominence',5,'minpeakheight',-min(x11));
% % discard if they are outside the previous peaks or very close to them
% x2=-x2;
% distToPeak  = 26;
% x2(y2>(max(y11)-distToPeak ))=[];
% y2(y2>(max(y11)-distToPeak ))=[];
% x2(y2<(min(y11)+distToPeak ))=[];
% y2(y2<(min(y11)+distToPeak ))=[];
% %
% if numel(x2)==0
%     % no cases detected, use half points
%     temp = round(cumsum(y11)/2);
%     %y2 = temp(2:3);
%     y2 =round([y11(1)+y11(2) y11(2)+y11(3)]/2);
%     x2 = lineToAssess(y2);
% elseif numel(x2)==1
%     % only one peak, complete the other one
%     temp = round(cumsum(y11)/2);
%     if y2>y11(2)
%         % add to the left
%         y2 = [round((y11(1)+y11(2))/2)  y2];
%         x2 = lineToAssess(y2);
%     else
%         % add to the right
%         y2 = [y2 round((y11(3)+y11(2))/2) ];
%          x2 = lineToAssess(y2);
%     end
% else
%     % more than 2 peaks, keep to 2, one left, one right of centre 
%     distFromLeft    = abs(y2-leftMidPoint);
%     distFromRight   = abs(y2-rightMidPoint);
%     [q1,q2]         = min(distFromLeft);
%     [q3,q4]         = min(distFromRight);
%     
%     y2              = y2([q2,q4]);
%     x2              = x2([q2,q4]);
% end
% 
% 
% 
% % Calculate the metric
% % Average of both valleys
% qMetric_abs = 0.5*abs(0.5*x11(1)+0.5*x11(2)-x2(1)) +0.5*abs(0.5*x11(2)+0.5*x11(3)-x2(2));
% % minimum of both valleys
% qMetric_abs = min(abs(0.5*x11(1)+0.5*x11(2)-x2(1)), abs(0.5*x11(2)+0.5*x11(3)-x2(2)));
% 
% 
% qMetric_rel = qMetric_abs/maxValue;
% 
% figure(4)
% h1 = subplot(221);
% 
% imagesc(currImage)
% title(strcat(num2str(qMetric_abs,4),'/',num2str(maxValue),'=',num2str(qMetric_rel,2)))
% h2= subplot(222) ;
% 
% plot(medianProjVert,rr,meanProjVert,rr,minProjVert,rr,maxProjVert,rr,'linewidth',2)
% 
% axis tight
% grid on
% axis ij
% 
% h3 = subplot(223);
% hold off
% % display the profile lines
% plot(cc,medianProjHorz,cc,meanProjHorz,cc,minProjHorz,cc,maxProjHorz,'linewidth',2)
% hold on
% % display the landmarks peaks and valleys
% plot(cc,lineToAssess,'r-',y11,x11,'bo',y2,x2,'k*','markersize',10,'linewidth',2)
% % display lines for the metrics
% plot(y11,x11,'b--')
% plot([leftMidPoint leftMidPoint],[leftMidValue x2(1)],'k-','marker','.','markersize',9)
% plot([rightMidPoint rightMidPoint],[rightMidValue x2(2)],'k-','marker','.','markersize',9)
% grid on
% axis tight
% grid on
% 
% %
% h1.Position = [ 0.1300    0.3483    0.5271    0.5767];
% h2.Position = [ 0.7104    0.3483    0.1927    0.5767];
% h3.Position = [ 0.1300    0.1100    0.5258    0.1888];
% 
% colormap gray
% 
% 
% %%
% 
% centralColumns              = round(0.45*cols:0.55*cols);
% leftLungColumns             = round(0.15*cols:0.4*cols);
% rightLungColumns            = round(0.6*cols:0.85*cols);
% 
% 
% 
% %%
% 
% 
% 
% 
% 
