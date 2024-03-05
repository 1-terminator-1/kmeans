% read the input image
I = imread('123.jpg');
I_gray = rgb2gray(I);

% define the threshold range
min_threshold = 0;
max_threshold = 255;

% calculate the histogram of input image
[counts, edges] = histcounts(I_gray, max_threshold - min_threshold + 1);

% initialize variables for loop
total_pixels = numel(I_gray);
B = 0;
weight_B = 0;
weight_F = 0;
var_max = 0;
best_threshold = 0;

% loop through pixel values
for th = 1:max_threshold
    % update B and weight_B
    B = B + double(counts(th)) * (th-1);
    weight_B = weight_B + counts(th);

    % calculate weight_F
    weight_F = total_pixels - weight_B;

    % exit loop if weight_F = 0
    if weight_F == 0
        break
    end

    % calculate mean for both levels
    mean_B = B / weight_B;
    mean_F = (sum(double(counts(th+1:end)) .* ((th:max_threshold)-1)) / weight_F) ;

    % calculate variance between the classes
    var_between = weight_B * weight_F * (mean_B - mean_F).^2;

    % update maximum variance if necessary
    if var_between > var_max
        var_max = var_between;
        best_threshold = th-1; % subtract 1 to get the correct threshold value
    end
end

% apply threshold to input image
output_image = I_gray >= best_threshold;

% display the results
subplot(1,2,1);
imshow(I);
title('Input Image');

subplot(1,2,2);
imshow(output_image);
title('Balanced Thresholding Output');