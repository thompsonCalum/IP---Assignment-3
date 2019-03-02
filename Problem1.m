im = imread('Fig1108(a)(mapleleaf).tif');
% im = imread('Fig1116(leg_bone).tif');
% im = imread('Fig1105(a)(noisy_stroke).tif');

[ROW,COL] = size(im);

im2 = im;

flaggedPoint = zeros(ROW,COL);

flagA = false;
flagB = false;
flagC = false;
flagD = false;

step2Flag = false;

p = zeros(1,9);
%% Step 2 - Reapply step 1 to new image
for it = 1 : 100
    step2Flag = false;
    for step = 1 : 2
        %% Step 1 - Flag points for deletion
        for i = 3 : ROW -1
            for j = 3 : COL -1
                
                % Apply filter to each index point in image
                p(1) = im(i,j);
                p(2) = im(i-1,j);
                p(3) = im(i-1,j+1);
                p(4) = im(i,j+1);
                p(5) = im(i+1,j+1);
                p(6) = im(i+1,j);
                p(7) = im(i+1,j-1);
                p(8) = im(i,j-1);
                p(9) = im(i-1,j-1);
                
                % Apply the four flags
                if(p(1) == 1 && (p(2) == 0|| p(3)==0||p(4)==0||p(5)==0||p(6)==0||p(7)==0||p(8)==0||p(9)==0))
                    % Flag A
                    aCount = 0;
                    
                    % Count the number of non-zero neighbours of p1
                    for x = 2 : numel(p)
                        if(p(x))
                            aCount = aCount + 1;
                        end
                    end
                    
                    if( aCount > 2 && aCount < 6)
                        flagA = true;
                    end
                    
                    % Flag B
                    bCount = 0;
                    
                    % COunt the number of 0-1 transitions
                    for x = 2 : numel(p)
                        y = x+1;
                        if(x == 9)
                            y = 2;
                        end
                        if((p(x) == 0 && p(y) == 1))
                            
                            bCount = bCount + 1;
                            
                        end
                    end
                    
                    % T(p1) = 1
                    if (bCount == 1)
                        flagB = true;
                    end
                    
                    % Flag C
                    if((p(2)*p(4)*p(6)) == 0 && (step2Flag == false))
                        flagC = true;
                    elseif(p(2)*p(4)*p(8) == 0 && (step2Flag == true))
                        flagC = true;
                    end
                    
                    % Flag D
                    if((p(4)*p(6)*p(8) == 0) && (step2Flag == false))
                        flagD = true;
                    elseif( (p(2)*p(6)*p(8) == 0) && (step2Flag == true))
                        flagD = true;
                    end
                                        
                    % If all flags pass, flag that point for deletion
                    if(flagA && flagB && flagC && flagD)
                        flaggedPoint(i,j) = 1;
                    end
                    
                    
                    % Reset flags                   
                    flagA = false;
                    flagB = false;
                    flagC = false;
                    flagD = false;
                end
            end
            
        end
        
        % Delete points based on step  results
        for i = 1 : ROW
            for j = 1 : COL
                if(flaggedPoint(i,j) == 1)
                    im(i,j) = 0;
                end
            end
        end
        
        % Start step 2 flags
        step2Flag = true;
    end
end

% warning('off', 'Images:initSize:adjustingMag');
% figure
imshow(im);
% figure
% imshow(im2)