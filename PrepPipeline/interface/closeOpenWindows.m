function closeOpenWindows(windowName)
    openWindow = findobj('Type', 'Figure', '-and', 'Name', windowName);
    if ~(isempty(openWindow))
        close(openWindow);
    end
end