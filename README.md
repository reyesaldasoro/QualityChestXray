# QualityChestXray
Obtain a metric of quality of a Chest Xray based on the contrast between lungs and surrounding structures.

<body><div class="content">
<h1>Assessment of quality of PA Chest Radiographs</h1><!--introduction-->

<p>

The COVID-19 pandemic has created the need to analyse a huge number of chest radiographs. However, not all  radiographs are acquired with the same parameters or conditions and many radiographs that are available present  various levels of quality. One way to assess the quality of a radiograph is to measure the contrast. In the  particular case of chest x-rays, the contrast of interest is not a general contrast measurement, but rather it is between the darker regions of the lungs and the brighter surrounding regions; the edges of the ribcage and the sternum. Due to the position of the bright and dark regions, a profile projection resembles a letter "W" with three peaks and two valleys. This work describes a simple, yet effective, algorithm to assess  the quality of the chest radiographs based on the intensity projections of images. The quality is a derived metric of contrast between peaks and valleys. The algorithm is freely available through GitHub.

</p><!--/introduction-->

<p>
This work describes the assessment of the quality of a chest radiograph based on the contrast X-ray. The algorithm used to assess this quality
  derives a metric based on the contrast between the intensity of the regions of lungs
  (which should be dark) and the intensity of the chest and the edge of the ribs (which should be brighter) in order to assess the quality of a Chest Radiograph in a Posterior-Anterior (PA) orientation.
  This contrast is measured by detecting the median intensity projection over each column of the radiograph.

 The projection should roughly resemble the shape of a "W" with three peaks corresponding to the brighter regions and two valleys corresponding to the darker regions.
 <img vspace="1" hspace="1" src="Figures/html/userGuide_00.png" alt="" width="500">

 In an idealised situation, the three peaks would have the same intensity as well as the two valleys. However, in real radiographs this is not the case. Thus the metric is calculated by measuring the depth of the two valleys separately and selecting {\it the smallest of both metrics.}
</p>


<h2>Contents</h2><div>
<ul><li><a href="#1">Peak detection</a></li>
<li><a href="#2">Valley detection</a></li>
<li><a href="#3">Metric calculation</a></li>
<li><a href="#6">Graphical display</a></li>
<li><a href="#8">Examples</a></li>
<li><a href="#10">High Contrast (0.58)</a></li>
<li><a href="#11">Medium Contrast (0.40)</a></li>
<li><a href="#12">Medium Contrast (0.32)</a></li>
<li><a href="#13">Medium Contrast (0.25)</a></li>
<li><a href="#14">Low contrast (0.09)</a></li></ul>

</div>

<h2 id="1">Peak detection</h2><p>This algorithm detects three peaks: it discards any peaks that are close to the edges of the radiograph. In case there are more than three, it selects the three with highest prominence. If there are only 2, it detects the central one and sets the third one at the opposite side, at the same distance as the existing one.</p>

<h2 id="2">Valley detection</h2><p>Once the peaks have been detected, valleys are detected. Any valley that is outside the peaks (left or right) is discarded. If there are no valleys detected (imagine a very low constrast radiograph), these are set at the midpoints between peaks and the same is done in case there is only one detected. If there are more than two, then the most prominent ones are selected.</p>

<h2 id="3">Metric calculation</h2><p>An absolute metric is calculated as the minimum of the two intensity differences between the intensity of the valleys and the average intensities of the peaks at each side. In a normal case, these two intensities are similar, but if one lung is much brighter than the other, then the intensity is different. An alternative is to take the average instead of the minimum.</p><p>Then, to make this as a relative metric, the intensity is analysed with order statistics to determine a lower value (6%) and a higher value (99%). The higher value is closer to the maximum as it is only necessary to discard the maximum values which can be due to labels on a radiograph. However, the lower value should be higher than a 1% to cover for dark pixels which can be background.</p><p>Finally, the metric is the ratio of the absolute metric previously calculated divided by the difference between the high and low values of the order statistics.</p>

<h2 id="6">Graphical display</h2><p>The function returns the actual metric (values between 0 and 1) and if requested a graphical display with a figure with 4 subplots: 1) the original radiographs, 2,3) intensity projections over the rows and columns, (maximum intensity projection, - black, minimum intensity projection - magenta, median intensity projection - red) 4) the radiograph with the contrast adjusted to the low and high values.</p><p>The intensity projection of each column shows the location of the peaks (blue circles), lines connecting the peaks (dashed blue lines), valleys (green stars), the intensity differences between the level of the valleys and the intermediate points of the peaks (thin vertical green lines), the lower and higher intensity values (magenta and black respectively).</p>

<h2 id="8">Examples</h2><p>A few examples are shown below. The images are read from the Covid-Chest-dataset  compiled by Joseph Paul Cohen in the GitHub repository "ieee8023"  (https://github.com/ieee8023/covid-chestxray-dataset)</p><p>The function is called with two parameters, the image itself, and an optional parameter to plot (1). The output is only the metric.</p>

<h2 id="10">High Contrast (0.58)</h2><pre class="codeinput">currImage=imread(<span class="string">'https://raw.githubusercontent.com/ieee8023/covid-chestxray-dataset/master/images/covid-19-pneumonia-30-PA.jpg'</span>);
quMetric = QualityChestXray(currImage,1);
</pre>
<img vspace="5" hspace="5" src="Figures/html/userGuide_01.png" alt="">

<h2 id="11">Medium Contrast (0.40)</h2><pre class="codeinput">currImage=imread(<span class="string">'https://raw.githubusercontent.com/ieee8023/covid-chestxray-dataset/master/images/pneumocystis-pneumonia-12.png'</span>);
quMetric = QualityChestXray(currImage,1);
</pre><img vspace="5" hspace="5" src="Figures/html/userGuide_02.png" alt="">

 <h2 id="12">Medium Contrast (0.32)</h2><pre class="codeinput">currImage=imread(<span class="string">'https://raw.githubusercontent.com/ieee8023/covid-chestxray-dataset/master/images/covid-19-pneumonia-43-day0.jpeg'</span>);
quMetric = QualityChestXray(currImage,1);
</pre><img vspace="5" hspace="5" src="Figures/html/userGuide_03.png" alt="">

<h2 id="13">Medium Contrast (0.25)</h2><pre class="codeinput">currImage=imread(<span class="string">'https://raw.githubusercontent.com/ieee8023/covid-chestxray-dataset/master/images/covid-19-pneumonia-41-day-2.jpg'</span>);

quMetric = QualityChestXray(currImage,1);
</pre><img vspace="5" hspace="5" src="Figures/html/userGuide_04.png" alt="">

 <h2 id="14">Low contrast (0.09)</h2><pre class="codeinput">currImage=imread(<span class="string">'https://raw.githubusercontent.com/ieee8023/covid-chestxray-dataset/master/images/all14238-fig-0002-m-d.jpg'</span>);
quMetric = QualityChestXray(currImage,1);
</pre><img vspace="5" hspace="5" src="Figures/html/userGuide_05.png" alt="">
