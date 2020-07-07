function [qMetric_rel] = QualityChestXray(currImage,toPlot)


[rows,cols,levs]               = size(currImage);

if levs>1
    currImage = currImage(:,:,1);
end
rr                          = 1:rows;
cc                          = 1:cols;

if ~exist('toPlot','var')
    toPlot = 0;
end


medianProjHorz              = median(currImage(:,:,1),1);
meanProjHorz                = mean(currImage(:,:,1),1);
minProjHorz                 = min(currImage(:,:,1),[],1);
maxProjHorz                 = max(currImage(:,:,1),[],1);

lineToAssess                = imfilter(double(medianProjHorz),ones(1,9)/9,'replicate');
[x1,y1,~,p1]                = findpeaks(lineToAssess,'minpeakdistance',cols/10,'minpeakprominence',5);

% discard peaks next to the edges
distToEdgeL                 = 40+ find(maxProjHorz,1,'first');
distToEdgeR                 = -25+find(maxProjHorz>1,1,'last');
x1(y1<distToEdgeL)          =[];
p1(y1<distToEdgeL)          =[];
y1(y1<distToEdgeL)          =[];
x1(y1>distToEdgeR)          =[];
p1(y1>distToEdgeR)          =[];
y1(y1>distToEdgeR)          =[];


%
% Select the three most central
distFromCentre              = round(abs(y1-cols/2));
numRemainingPeaks           = numel(y1);
    
if numRemainingPeaks>3
    %     [q1,q2]=sort(distFromCentre);
    %     x11 = x1(q2(1:3));
    %     y11 = y1(q2(1:3));
    % Select by distance from Centre, not always right
    %[~,q2]=min(distFromCentre);
    %x11 = x1(q2-1:q2+1);
    %y11 = y1(q2-1:q2+1);
    % Select by prominence
    [~,q2]                  = sort(p1,'descend');
    x11                     = x1 (sort(q2(1:3)));
    y11                     = y1 (sort(q2(1:3)));   
elseif numRemainingPeaks==3
    % This assumes there are 3 points
    x11                     = x1;
    y11                     = y1;     
elseif numRemainingPeaks==2
    % only 2 points
    % Add a point left or right
    if distFromCentre(2)>distFromCentre(1)
        y11                 = [max(1,y1(1)-distFromCentre(2))  y1];
        x11                 = [lineToAssess(y11(1))  x1];
    else
        y11                 = [y1 min(cols,y1(2)+distFromCentre(1)) ];
        x11                 = [x1 lineToAssess(y11(end))];
    end
elseif numRemainingPeaks ==1
    % Only one peak, this may be due to discarding the peaks near the edges
    % Try the valleys here
    [x2,y2,~,p2]                     = findpeaks(-lineToAssess,'minpeakdistance',cols/10,'minpeakprominence',5,'minpeakheight',-min(x1));
    if numel(x2)<2
        qMetric_rel = nan;
        return;
    else
        [~,q2]                  = sort(p2,'descend');
        y2                     = y2 (sort(q2(1:2)));
        % Location of two valleys, set the peaks either side of the valleys
        y11 = [ max(y2(1)-(y1-y2(1)),distToEdgeL)   y1   min(y2(2)+(-y1+y2(2)),distToEdgeR) ];
        x11 = lineToAssess(y11);
    end
else
    % This assumes there are no peaks detected
    qMetric_rel = nan;
    return;
end
% Calculate mid points
leftMidPoint                = 0.5*y11(1)+0.5*y11(2);
leftMidValue                = 0.5*x11(1)+0.5*x11(2);
rightMidPoint               = 0.5*y11(3)+0.5*y11(2);
rightMidValue               = 0.5*x11(3)+0.5*x11(2);
maxValue                    = double(max(currImage(:)));


% find valleys
[x2,y2,~,p2]                     = findpeaks(-lineToAssess,'minpeakdistance',cols/10,'minpeakprominence',5,'minpeakheight',-min(x11));
% discard if they are outside the previous peaks or very close to them
x2                          = -x2;
distToPeak                  = 26;
x2(y2>(max(y11)-distToPeak ))= [];
p2(y2>(max(y11)-distToPeak ))= [];
y2(y2>(max(y11)-distToPeak ))= [];

x2(y2<(min(y11)+distToPeak ))= [];
p2(y2<(min(y11)+distToPeak ))= [];
y2(y2<(min(y11)+distToPeak ))= [];


%
if numel(x2)==0
    % no cases detected, use half points
    %temp = round(cumsum(y11)/2);
    %y2 = temp(2:3);
    y2                      = round([y11(1)+y11(2) y11(2)+y11(3)]/2);
    x2                      = lineToAssess(y2);
elseif numel(x2)==1
    % only one peak, complete the other one
    %temp = round(cumsum(y11)/2);
    if y2>y11(2)
        % add to the left
        y2                  = [round((y11(1)+y11(2))/2)  y2];
        x2                  = lineToAssess(y2);
    else
        % add to the right
        y2                  = [y2 round((y11(3)+y11(2))/2) ];
        x2                  = lineToAssess(y2);
    end
else
    % more than 2 peaks, keep to 2, one left, one right of centre
    % Selection by distance
%     distFromLeft            = abs(y2-leftMidPoint);
%     distFromRight           = abs(y2-rightMidPoint);
%     [~,q2]                  = min(distFromLeft);
%     [~,q4]                  = min(distFromRight);    
%     y2                      = y2([q2,q4]);
%     x2                      = x2([q2,q4]);
    % Selection by Prominence
    [~,q2]                  = sort(p2,'descend');
    x2                     = x2 ([sort(q2(1:2))]);
    y2                     = y2 (sort(q2(1:2)));  
end

%% Assessment of max and min, 
% do not use max and min as these can be biased due to labels or margins, 
% better sort and take 5% and 99% 
numPix                      = numel(currImage);
intensityDistribution       = sort(currImage(:));
minEstimation               = double(intensityDistribution(round(numPix*0.06)));
maxEstimation               = double(intensityDistribution(round(numPix*0.99)));
% Calculate the metric
% Average of both valleys
%qMetric_abs = 0.5*abs(0.5*x11(1)+0.5*x11(2)-x2(1)) +0.5*abs(0.5*x11(2)+0.5*x11(3)-x2(2));
% minimum of both valleys
qMetric_abs = min(abs(0.5*x11(1)+0.5*x11(2)-x2(1)), abs(0.5*x11(2)+0.5*x11(3)-x2(2)));


qMetric_rel = qMetric_abs/(maxEstimation - minEstimation);


%% Projection over every row
% Can be for all the window, or cropped between the peaks
% medianProjVert              = median(currImage(:,:,1),2);
% meanProjVert                = mean(currImage(:,:,1),2);
% minProjVert                 = min(currImage(:,:,1),[],2);
% maxProjVert                 = max(currImage(:,:,1),[],2);
medianProjVert              = imfilter(double(median(currImage(:,y11(1):y11(2),1),2)),ones(9,1)/9,'replicate');
meanProjVert                = imfilter(double(mean(currImage(:,y11(1):y11(2),1),2)),ones(9,1)/9,'replicate');
minProjVert                 = imfilter(double(min(currImage(:,y11(1):y11(2),1),[],2)),ones(9,1)/9,'replicate');
maxProjVert                 = imfilter(double(max(currImage(:,y11(1):y11(2),1),[],2)),ones(9,1)/9,'replicate');




if toPlot==1
    figure
    set(gcf,'Position', [702   286   753   680]);
    % First plot, the Chest X ray
    h1 = subplot(221);
    imagesc(currImage)
    title(strcat(num2str(qMetric_abs,4),'/ (',num2str(maxEstimation),'-', num2str(minEstimation),')','=',num2str(qMetric_rel,2)))
    colorbar
    
    % Second plot, the projections over the rows
    h2= subplot(222) ;  
    %plot(medianProjVert,rr,meanProjVert,rr,minProjVert,rr,maxProjVert,rr,'linewidth',2)
    
    plot(medianProjVert,rr,'r-',minProjVert,rr,'m-',maxProjVert,rr,'k-','linewidth',2)
    
    axis tight
    grid on
    axis ij
    
    h3 = subplot(223);
    hold off
    % display the profile lines
    %plot(cc,medianProjHorz,cc,meanProjHorz,cc,minProjHorz,cc,maxProjHorz,'linewidth',2)
    plot(cc,medianProjHorz,'r-',cc,minProjHorz,'-m',cc,maxProjHorz,'k-','linewidth',2)
    
    hold on
    % display the landmarks peaks and valleys
    plot(cc,lineToAssess,'r-',y11,x11,'bo','markersize',10,'linewidth',2)
    plot(y2,x2,'color',[0 0.6 0],'marker','*','linestyle','none','markersize',10,'linewidth',2)
    % display lines for the metrics
    plot(y11,x11,'b--')
    plot([leftMidPoint leftMidPoint],[leftMidValue x2(1)],'-','color',[0 0.6 0],'marker','.','markersize',9)
    plot([rightMidPoint rightMidPoint],[rightMidValue x2(2)],'-','color',[0 0.6 0],'marker','.','markersize',9)

    plot([1 cols],[minEstimation minEstimation],'m--d')
    plot([1 cols],[maxEstimation maxEstimation],'k--d')
    grid on
    axis tight

    h4=subplot(224);
    imagesc(currImage)
    colorbar
    caxis([minEstimation maxEstimation])
    %
    h1.Position = [ 0.1300    0.3483    0.56      0.5767];
    h2.Position = [ 0.79      0.3483    0.12      0.5767];
    h3.Position = [ 0.1300    0.1100    0.56      0.1888];
    h4.Position = [ 0.7900    0.1100    0.12      0.1888];
    colormap gray
    
end
%%





