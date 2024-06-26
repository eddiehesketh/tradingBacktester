% Define historic analysis function, with an input parameter of iD used.
function [startingDates, startingPrices] = historicAnalysis(idUsed)

% Defining the api link to the historic data of each cryptocurrencey.
urlHistoricalQuotes = 'https://pro-api.coinmarketcap.com/v3/cryptocurrency/quotes/historical';

% Gaining the time interval for which the historic data will be extracted
% from.
[timeStart, timeEnd] = timeInterval();

% Obtaining the historical quotes, using the previously defined parameters.
[dataHistoricalQuotes] = connectorAPI(timeStart, timeEnd, urlHistoricalQuotes, idUsed);

% Initialising the daily prices and dates variable for appendation.
dailyPrices = [];
dates = [];

% Identified the pattern within the API data where the crypto ID is after
% the x in the data path, hence the ID appended to x in the variable.
dataQuotes = dataHistoricalQuotes.data.(['x' num2str(idUsed)]).quotes;

% For loop to formulate two matricies, one which contains the prices per
% day, and once which contains the corresponding dates/ times.
for i = 1:length(dataQuotes)
    dailyPrices = [dailyPrices; 1.55*dataQuotes(i).quote.USD.price]; % Appending prices to daily prices matricie, which are multiplied by 1.55 to convert from USD to AUD.
    dateBeingChanged = dataQuotes(i).quote.USD.timestamp; % Identifying the date being changed within the API data.
    formattedDate = dateFormatting(dateBeingChanged); % Formatting the date in a more appropriate layout using date being changed function.
    dates = [dates; formattedDate]; % Appending dates to the date 2D array.
end

index = 1; % Initialising index variable.
startingDay = false; % Identifying start day as false.

% While loop which runs while startingDay is false, to identify the point
% where data beings for the crypto withn the past 2 years, as it might be
% new.
while ~startingDay
    if dailyPrices(index, 1)>0
        startingDay = true;
    else
        index = index + 1; % If there is no data, index is increased by one.
    end
end

% Initialising starting dates and prices array.
startingDates = [];
startingPrices = [];

% Gaining the number of rows as a variable to be used in later loops.
[row, ~] = size(dates);

% Checking if index is greater than one, which would occur if the selected
% crypto doesn't have a full two years worth of data.
if index > 1
for j = index:row
    % Appends the dates which have data to the 2d arrays which will be
    % used.
    startingDates = [startingDates; dates(j, 1)]; 
    startingPrices = [startingPrices; dailyPrices(j, 1)];
end
else % If index is not greater than one, then the variables which will be used are equal to those previously identified .
    startingDates = dates;
    startingPrices = dailyPrices;
end 


end % End function.


    






  