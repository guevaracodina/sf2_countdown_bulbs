function ImOut = im2sf2bulbcountdown(ImIn)
% The im2sf2bulbcountdown function converts a binary image into an RGB
% image by replacing each pixel with predefined 16x16 pixel images based on
% specific surrounding pixel patterns, then saves and displays the
% resulting image.
%
% SYNTAX
% ImOut = im2sf2bulbcountdown(ImIn)
%
% INPUTS
% ImIn: file name of the binary image (B/W) to be converted
%
% OUTPUTS
% ImOut: RGB image composed of the bulbs of Street Fighter 2 countdown
%__________________________________________________________________________
% Copyright (C) 2024 Edgar Guevara, PhD
% CONAHCYT-Universidad Autónoma de San Luis Potosí
% Coordinación para la Innovación y Aplicación de la Ciencia y la Tecnología
%__________________________________________________________________________
% 
% 
% Extract the filename parts
[~,fName,~] = fileparts(ImIn);
% Read the input binary image
BW = imread(ImIn);
% Ensure the image is binary
if size(BW, 3) == 3
    BW = rgb2gray(BW);
end
BW = imbinarize(BW);

% Get the size of the input image
[rows, cols] = size(BW);

% Create a blank RGB image for the output
ImOut = zeros(rows * 16, cols * 16, 3, 'uint8');

% Load the replacement images
replacement_files = {'bulb_ON.png', 'bulb_OFF.png', 'bulb_OFF_D.png', ...
    'bulb_OFF_DL.png', 'bulb_OFF_DLR.png', 'bulb_OFF_DR.png', ...
    'bulb_OFF_L.png', 'bulb_OFF_LR.png', 'bulb_OFF_R.png', ...
    'bulb_OFF_U.png', 'bulb_OFF_UD.png', 'bulb_OFF_UDL.png', ...
    'bulb_OFF_UDLR.png', 'bulb_OFF_UDR.png', 'bulb_OFF_UL.png', ...
    'bulb_OFF_ULR.png', 'bulb_OFF_UR.png'};

% Initialize the replacement images
replacement_images = cell(1, 17);

for i = 1:17
    [img, map] = imread(replacement_files{i});
    % Convert indexed images to RGB
    if ~isempty(map)
        img = ind2rgb(img, map);
        img = uint8(255 * img);  % Scale to [0, 255] range for uint8 type
    elseif size(img, 3) == 1
        img = repmat(img, [1, 1, 3]);
    end
    replacement_images{i} = img;
end

% Map replacement images to logical rules
bulb_ON = replacement_images{1};
bulb_OFF = replacement_images{2};
bulb_OFF_D = replacement_images{3};
bulb_OFF_DL = replacement_images{4};
bulb_OFF_DLR = replacement_images{5};
bulb_OFF_DR = replacement_images{6};
bulb_OFF_L = replacement_images{7};
bulb_OFF_LR = replacement_images{8};
bulb_OFF_R = replacement_images{9};
bulb_OFF_U = replacement_images{10};
bulb_OFF_UD = replacement_images{11};
bulb_OFF_UDL = replacement_images{12};
bulb_OFF_UDLR = replacement_images{13};
bulb_OFF_UDR = replacement_images{14};
bulb_OFF_UL = replacement_images{15};
bulb_OFF_ULR = replacement_images{16};
bulb_OFF_UR = replacement_images{17};

% Iterate through each pixel in the binary image
for r = 1:rows
    for c = 1:cols
        if BW(r, c) == 1
            % White pixel
            tile = bulb_ON;
        else
            % Black pixel
            % Get the 4-connected neighbors (considering image boundary conditions)
            above = r > 1 && BW(r - 1, c);
            below = r < rows && BW(r + 1, c);
            left = c > 1 && BW(r, c - 1);
            right = c < cols && BW(r, c + 1);

            % Determine which replacement image to use
            if ~above && ~below && ~left && ~right
                tile = bulb_OFF;
            elseif ~above && below && ~left && ~right
                tile = bulb_OFF_D;
            elseif ~above && below && left && ~right
                tile = bulb_OFF_DL;
            elseif ~above && below && left && right
                tile = bulb_OFF_DLR;
            elseif ~above && below && ~left && right
                tile = bulb_OFF_DR;
            elseif ~above && ~below && left && ~right
                tile = bulb_OFF_L;
            elseif ~above && ~below && left && right
                tile = bulb_OFF_LR;
            elseif ~above && ~below && ~left && right
                tile = bulb_OFF_R;
            elseif above && ~below && ~left && ~right
                tile = bulb_OFF_U;
            elseif above && below && ~left && ~right
                tile = bulb_OFF_UD;
            elseif above && below && left && ~right
                tile = bulb_OFF_UDL;
            elseif above && below && left && right
                tile = bulb_OFF_UDLR;
            elseif above && below && ~left && right
                tile = bulb_OFF_UDR;
            elseif above && ~below && left && ~right
                tile = bulb_OFF_UL;
            elseif above && ~below && left && right
                tile = bulb_OFF_ULR;
            elseif above && ~below && ~left && right
                tile = bulb_OFF_UR;
            else
                tile = bulb_OFF; % Default to OFF if none of the conditions are met
            end
        end

        % Place the selected tile in the output image
        ImOut((r-1)*16+1:r*16, (c-1)*16+1:c*16, :) = tile;
    end
end

% Display the output image
figure; imshow(ImOut);

% Save the output image
imwrite(ImOut, [fName, '_ImOut.png']);
end
