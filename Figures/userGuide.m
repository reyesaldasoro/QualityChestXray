%% Assessment of quality of PA Chest Radiographs
% This code derives a quality metric based on the contrast between the intensity of the regions of lungs
% (which should be dark) and the intensity of the chest and the edge of the ribs (which should be brighter).
% This contrast is measured by detecting the median intensity projection over each column of the radiograph.
% The projection should roughly resemble the shape of a "W" with three peaks and two valleys.

%% Peak detection
% This algorithm detects three peaks: it discards any peaks that are close to the edges of the radiograph. In
% case there are more than three, it selects the three with highest prominence. If there are only 2, it
% detects the central one and sets the third one at the opposite side, at the same distance as the existing
% one. 
%% Valley detection
% Once the peaks have been detected, valleys are detected. Any valley that is outside the peaks (left or
% right) is discarded. If there are no valleys detected (imagine a very low constrast radiograph), these are
% set at the midpoints between peaks and the same is done in case there is only one detected. If there are
% more than two, then the most prominent ones are selected.
%% Metric calculation
% An absolute metric is calculated as the minimum of the two intensity differences between the intensity of
% the valleys and the average intensities of the peaks at each side. In a normal case, these two intensities
% are similar, but if one lung is much brighter than the other, then the intensity is different. An
% alternative is to take the average instead of the minimum.
%%
% Then, to make this as a relative metric, the intensity is analysed with order statistics to determine a
% lower value (6%) and a higher value (99%). The higher value is closer to the maximum as it is only necessary
% to discard the maximum values which can be due to labels on a radiograph. However, the lower value should be
% higher than a 1% to cover for dark pixels which can be background.
%%
% Finally, the metric is the ratio of the absolute metric previously calculated divided by the difference
% between the high and low values of the order statistics.

%% Graphical display
% The function returns the actual metric (values between 0 and 1) and if requested a graphical display with a
% figure with 4 subplots: 1) the original radiographs, 2,3) intensity projections over the rows and columns,
% (maximum intensity projection, - black, minimum intensity projection - magenta, median intensity projection
% - red) 4) the radiograph with the contrast adjusted to the low and high values.
%%
% The intensity projection of each column shows the location of the peaks (blue circles), lines connecting the
% peaks (dashed blue lines), valleys (green stars), the intensity differences between the level of the valleys
% and the intermediate points of the peaks (thin vertical green lines), the lower and higher intensity values
% (magenta and black respectively).

%% Examples
% A few examples are shown below. The images are read from the Covid-Chest-dataset
%  compiled by Joseph Paul Cohen in the GitHub repository "ieee8023"
%  (https://github.com/ieee8023/covid-chestxray-dataset)

%% High Contrast (0.58)

currImage=imread('https://raw.githubusercontent.com/ieee8023/covid-chestxray-dataset/master/images/covid-19-pneumonia-30-PA.jpg');
quMetric = QualityChestXray(currImage,1);

%% Medium Contrast (0.40)

currImage=imread('https://raw.githubusercontent.com/ieee8023/covid-chestxray-dataset/master/images/pneumocystis-pneumonia-12.png');
quMetric = QualityChestXray(currImage,1);

%% Medium Contrast (0.32)
currImage=imread('https://raw.githubusercontent.com/ieee8023/covid-chestxray-dataset/master/images/covid-19-pneumonia-43-day0.jpeg');
quMetric = QualityChestXray(currImage,1);

%% Medium Contrast (0.25)
currImage=imread('https://raw.githubusercontent.com/ieee8023/covid-chestxray-dataset/master/images/covid-19-pneumonia-41-day-2.jpg');

quMetric = QualityChestXray(currImage,1);

%% Low contrast (0.09)
currImage=imread('https://raw.githubusercontent.com/ieee8023/covid-chestxray-dataset/master/images/all14238-fig-0002-m-d.jpg');
quMetric = QualityChestXray(currImage,1);
