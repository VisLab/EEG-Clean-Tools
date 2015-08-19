function str = num2IncStr(num)
        str = num2str(num(1));
        incrementStart = true;
        for a = 2:length(num)
            if num(a) - num(a-1) == 1
                if incrementStart
                    str = [str ':']; %#ok<AGROW>
                    incrementStart = false;
                end
            else
                str = [str ',' num2str(num(a))];   %#ok<AGROW>
                incrementStart = true;
            end
        end
        if ~incrementStart
           str = [str num2str(num(length(num)))]; 
        end
        

end

