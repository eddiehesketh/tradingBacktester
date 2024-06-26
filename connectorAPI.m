% Function takes in the time start, time end and the url to the hisotric data and selected cypto ID
% to get the historical prices over the identified time interval.
function [dataHistoricalQuotes] = connectorAPI(timeStart, timeEnd, urlHistoricalQuotes, idUsed)

% Defining the API Key as it is required to gain acess to the API on the
% website.
apiKey = '9b25157d-8c54-4071-ade0-c0d38b02b8ad';  

% Using weboptions function, and 'HeaderFields' to provide the HTTP request
% header with the required inputs. 'X-CMC_PRO_API_KEY' is used to pass the
% API key for authentication, and 'Accept' specifies that the response
% should be in JSON format, identified through API documentation.
options = weboptions('HeaderFields', {'X-CMC_PRO_API_KEY', apiKey; 'Accept', 'application/json'});
options.Timeout = 30;  % Increase timeout to wait for the response.

% Construct the full URL with the required paramters parameters which are
% the ID, start time and end time.
params = sprintf('id=%.0f&time_start=%s&time_end=%s&interval=24h', idUsed, timeStart, timeEnd);

% Combine the url and the parameters to form the final url which will be
% used.
urlHistoricalQuotesFull = sprintf('%s?%s', urlHistoricalQuotes, params);

% Using webread function to gain the historical quotes within the specified
% time intervals, using the options.
dataHistoricalQuotes = webread(urlHistoricalQuotesFull, options);

end % End function.
