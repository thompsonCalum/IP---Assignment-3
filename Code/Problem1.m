% im = imread('Fig1108(a)(mapleleaf).tif');

% im = imread('Fig1116(leg_bone).tif');

% Load, filter, and binarize the noisy image
se = strel('square', 10);
im = imread('Fig1105(a)(noisy_stroke).tif');
im = imopen(im,se);
im = imbinarize(im);

[ROW,COL] = size(im);

% Create a vector to store the p values
p = zeros(1,9);

im2 = im;

% Set the condition flags to false
flagA = false;
flagB = false;
flagC = false;
flagD = false;

% Set step 2 flag to false.
step2Flag = false;

% Set flag indicating there are still points to delete
it = true;
iterationCount = 0;

%% While there are still points to delete - apply two steps
while(it == true)
    
    % Track the number of iterations
    iterationCount = iterationCount + 1;
    
    % Initial flag to indicate start of step 1
    step2Flag = false;
    
    % Loop through steps 1 and 2
    for step = 1 : 2
        
        % Matrix to flag points for deletion
        flaggedPoint = zeros(ROW,COL);

        %% Step - Flag points for deletion based on iteration step
        for i = 2 : ROW -1
            for j = 2 : COL -1

                % Apply filter to each index point in image
                p(1) = im(i,j);
                p(2) = im(i,j-1);
                p(3) = im(i+1,j-1);
                p(4) = im(i+1,j);
                p(5) = im(i+1,j+1);
                p(6) = im(i,j+1);
                p(7) = im(i-1,j+1);
                p(8) = im(i-1,j);
                p(9) = im(i-1,j-1);
                
                % If the point is a bourder point - Apply the four
                % conditional checks
                if(p(1) == 1 && (p(2) == 0|| p(3)==0||p(4)==0||p(5)==0||p(6)==0||p(7)==0||p(8)==0||p(9)==0))
                   
                    % Condition A - Count the number of non-zero neighbours of p1
                    aCount = 0;
                    for x = 2 : numel(p)
                        if(p(x))
                            aCount = aCount + 1;
                        end
                    end
                    
                    % 2<= N(p(1)) <=6
                    if( aCount >= 2 && aCount <= 6)
                        flagA = true;
                    end
                    
                  
                    % Condition B - Count the number of 0-1 transitions
                    bCount = 0; 
                    for x = 2 : numel(p)
                        y = x+1;
                        
                        % Check between p(9) - p(2)
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
                    
                    % Condition C - dependant on which step is being appled
                    if((p(2)*p(4)*p(6)) == 0 && (step2Flag == false))
                        flagC = true;
                    elseif(p(2)*p(4)*p(8) == 0 && (step2Flag == true))
                        flagC = true;
                    end
                    
                    % Condition D - dependant on which step is being appled
                    if((p(4)*p(6)*p(8) == 0) && (step2Flag == false))
                        flagD = true;
                    elseif( (p(2)*p(6)*p(8) == 0) && (step2Flag == true))
                        flagD = true;
                    end
                                        
                    % If all conditions pass, flag that point for deletion
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
        
        % Variable to track whether points have been flagged in current
        % step.
        c = 0;
        
        % At the end of each step - delete flagged points
        for i = 1 : ROW
            for j = 1 : COL
                if(flaggedPoint(i,j) == 1)
                    im(i,j) = 0;
                    it = true;
                    c = c+1;
                end
            end
        end
        
        % If no points have been flagged - stop.
        if(c == 0)
           it = false; 
        end
        
        % Start step 2 flags
        step2Flag = true;
    end
end

% Show skeleton image
imshow(im);
