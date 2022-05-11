RGB = imread('img.jpg');
imshow(RGB)
I = rgb2gray(RGB);
bw = imbinarize(I);
imshow(bw)
bw = bwareaopen(bw,30);
imshow(bw)
se = strel('disk',2);
bw = imclose(bw,se);
imshow(bw)
bw = imfill(bw,'holes');
imshow(bw)
[B,L] = bwboundaries(bw,'noholes');
imshow(label2rgb(L,@jet,[.5 .5 .5]))
hold on
for k = 1:length(B)
  boundary = B{k};
  plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
end
stats = regionprops(L,'Area','Centroid');

threshold = 0.94;

% loop over the boundaries
for k = 1:length(B)

  % obtain (X,Y) boundary coordinates corresponding to label 'k'
  boundary = B{k};

  % compute a simple estimate of the object's perimeter
  delta_sq = diff(boundary).^2;    
  perimeter = sum(sqrt(sum(delta_sq,2)));
  
  % obtain the area calculation corresponding to label 'k'
  area = stats(k).Area;
  
  % compute the roundness metric
  metric = 4*pi*area/perimeter^2;
  
  % display the results
  metric_string = sprintf('%2.2f',metric);

  % mark objects above the threshold with a black circle
  if metric > threshold
    centroid = stats(k).Centroid;
    plot(centroid(1),centroid(2),'ko');
  end
  text(boundary(1,2)-35,boundary(1,1)+13,metric_string,'Color','y',...
       'FontSize',14,'FontWeight','bold')
end

title(['Metrics Closer to 1 Indicate that ',...
       'the Object is Approximately Round'])