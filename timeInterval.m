% Function identifies the timespan and format which will be used to extract
% the crypto data.
function [timeStart, timeEnd] = timeInterval()

% Get current datetime in UTC, as this is what the API uses.
currentTime = datetime('now', 'TimeZone', 'UTC');

% Subtract 2 years from the current time, as the API used to provide the
% info has a limit of 2 years worth of data.
timeStart = currentTime - years(2);

% Format both dates to the required string format, identified through the
% API documentation website
% https://coinmarketcap.com/api/documentation/v1/.
timeEnd = datestr(currentTime, 'yyyy-mm-ddTHH:MM:ss.FFFZ'); % Added to timeEnd variable which will contain the first crypto data point.
timeStart = datestr(timeStart, 'yyyy-mm-ddTHH:MM:ss.FFFZ'); % Added to timeStart variable which will have the newest crypto data point.
end % End function.

