% Function converts the date data from the API back into the normal format
% so that it can be presented nicely and on a graph.
function [formattedDate] = dateFormatting(dateBeingChanged)

% Identifies the date beig changed through running it through the datetime
% function.
dateChanged = datetime(dateBeingChanged, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSS''Z''', 'TimeZone', 'UTC');
dateChanged.Format = 'dd-MM-yyyy HH:mm:ss'; % Specifies the new format of the date being changed.
formattedDate = dateChanged; % Assigns the formatted date variable to the date being changed and is the output of the function.\

end % End function.



