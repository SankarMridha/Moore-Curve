function MoCurve(recursion)
    Recursion = recursion;                                                       % Number of recursion
    Grid_length = 4^(Recursion + 1);                                             % Maximum grid length
    Grid_point = 2^Recursion + 1;                                                % Number of Grid point
    Point = Grid_length;                                                         % Number of point
    Max_x_co = Grid_length;                                                      % Maximum x coordinate
    Max_y_co = Grid_length;                                                      % Maximum y coordinate
    Small_block_step = Grid_length / sqrt(Point);                                % Block Radius
    Point_x = 0;                                                                 %Initial Point for x coordinate
    Point_y = 0;                                                                 %Initial Point for y coordinate
   
    %% Prepare DataSet 
    % Estimate grid coordinate
    Coordinate_set(1,1) = Point_x;
    Coordinate_set(2,1) = Point_x;
    for i = 2 : Grid_point
        Coordinate_set(1,i) = Coordinate_set(1,i-1) + 2*Small_block_step;
        Coordinate_set(2,i) = Coordinate_set(2,i-1) + 2*Small_block_step;
    end
    Coordinate_set;                                                              % Grid coordinate set                   

    k = 1;
    for i = Small_block_step : 2*Small_block_step : Max_x_co
        for j = Small_block_step : 2*Small_block_step : Max_y_co
            All_Point(1,k) = j;
            All_Point(2,k) = i;
            All_Point(3,k) = k;
            k = k + 1;
        end
    end
    All_Point;
    Initial_Co = 2^(Recursion - 1) + 1;                                           % Select the begining point of draw line
    if Initial_Co < 1                                                             % If line starting point less than 1 or not  
        Initial_Co = 1;                                                           % Set the line point = 1
    end
 
    % place the point into plot
    [row col] = size(All_Point);
    for i = 1 : col
        plot(All_Point(1,i),All_Point(2,i),'r');
        hold on;
        % Select the coordinate of starting point
        if All_Point(3,i) == Initial_Co
            plot(All_Point(1,i),All_Point(2,i),'g');
            SourceNode_x = All_Point(1,i);
            SourceNode_y = All_Point(2,i);
            hold on;
        end
    end
    
    
    %% Draw the plot
    Axiom = 'LFL+F+LFL';                                                          % Input String
    L = '-RF+LFL+FR-';                                                            % Production rules
    R = '+LF-RFR-FL+';
    % Prepare the string data set from Axiom
    if Recursion == 0
        Axiom = '';
    else
        for i = 1 : Recursion - 1                                                 % Number of  recursion 
            Axiom_temp = '';                                                      % Variable store new dataset
            for j = 1 : length(Axiom) 
                if Axiom(j) == 'L'
                    Axiom_temp = strcat(Axiom_temp,L);                            % Relace 'L' by  rule L
                elseif Axiom(j) == 'R'
                    Axiom_temp = strcat(Axiom_temp,R);                            % Relace 'L' by  rule L
                else
                    Axiom_temp = strcat(Axiom_temp,Axiom(j));                      
                end
            end
            Axiom = Axiom_temp;                                                   % New dataset is now the original string
        end
    end
    % Replace all 'L' & 'R' from final string
    Axiom = strrep(Axiom,'R','');
    Axiom = strrep(Axiom,'L','');
    % Final string
    Axiom_size = length(Axiom);
    % We assuse 4 direction, 1 for Up, 2 for Left, 3 for down, & 4 for right 
    Direction = 1;
    for i = 1: Axiom_size                                                          
        if Axiom(i) == '-'                                                       % '-' means 90 degree right so add 1 to change direction
            Direction = Direction + 1;
        elseif Axiom(i) == '+'
            Direction = Direction - 1;                                           % '+' means 90 degree left so minus 1 to change direction
        else
            if Direction > 4                                                     % tune the direction between 1 to 4
                Direction = Direction - 4;
            elseif Direction < 1
                Direction = 4;
            end
            if Direction == 1                                                    % Direction 1 means draw towards Up direction so only y axis  update
                SinkNode_x = SourceNode_x; 
                SinkNode_y = SourceNode_y + 2*Small_block_step;
            elseif Direction == 2                                                % Direction 2 means draw towards Left direction so only x axis update
                SinkNode_x = SourceNode_x + 2*Small_block_step;   
                SinkNode_y = SourceNode_y;             
            elseif Direction == 3                                                % Direction 3 means draw towards Down direction so only y axis update
                SinkNode_x = SourceNode_x; 
                SinkNode_y = SourceNode_y - 2*Small_block_step;   
            else
                SinkNode_x = SourceNode_x - 2*Small_block_step;                  % Direction 4 means draw towards right direction so only x axis update
                SinkNode_y = SourceNode_y;
            end
            
            % Color code
            a(1) = round(rand());
            a(2) = round(rand());
            a(3) = round(rand());
            if (a(1) == 0 && a(2) == 0 && a(3) == 0)
                Index = round(2* rand() + 1);
                a(Index) = 1;
            elseif (a(1) == 1 && a(2) == 1 && a(3) == 1)
                Index = round(2* rand() + 1);
                a(Index) = 0;
            end
            plot([SourceNode_x SinkNode_x], [SourceNode_y SinkNode_y],'Color',[a(1) a(2) a(3)]);
            hold on;
            % Sink coordinates now treat as a source coordinates  
            SourceNode_x = SinkNode_x;
            SourceNode_y = SinkNode_y;
        end
     end
end