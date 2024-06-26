% Function is run by a timer to frequently update and display the live
% price of the selected crypto.
function updateLivePrice(url, apiKey, choice, cryptoName, significantDigits)

% See comment on line 9 in connectorAPI.m for description as it has the
% same purpose,
options = weboptions('HeaderFields', {'X-CMC_PRO_API_KEY', apiKey; 'Accept', 'application/json'});

% Using webread function to extract the API data for the
data = webread(url, options);

% Assigning timeUpdated variable (the live time) to the output of the date
% formatting function which takes in the live date data from the API.
timeUpdated = dateFormatting(data.data{choice, 1}.last_updated);

% Obtaining the live price through accessing the price data from where it
% is stored within the API data, using the users choice to find the
% exact price.
livePrice = 1.55*(data.data{choice, 1}.quote.USD.price);

% Printing the live price and when it was last updated.
fprintf('Date/ time updated: %s (UTC)    %s live price: $%.*g\n', timeUpdated, cryptoName, significantDigits, livePrice);

end % End function.
