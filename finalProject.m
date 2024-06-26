% Project allows users to analyse different cryptocurrencies, and build and
% trial different investment stratergies to determine the optimal solution.

% Assigns continueAnalysis boolean variable to true for while loop.
continueAnalysis = true;

% Using weboptions function, and 'HeaderFields' to provide the HTTP request
% header with the required inputs. 'X-CMC_PRO_API_KEY' is used to pass the
% API key for authentication, and 'Accept' specifies that the response
% should be in JSON format, identified through API documentation.
url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest';
apiKey = '9b25157d-8c54-4071-ade0-c0d38b02b8ad';  % From API.
options = weboptions('HeaderFields', {'X-CMC_PRO_API_KEY', apiKey; 'Accept', 'application/json'});
options.Timeout = 30;  % Increase timeout to wait for the response


% Project utilises an outer while loop to allow users to repeatedly access
% different components of the project.
while continueAnalysis
    % Menu provides users with the option to continue with the software,
    % if they select no, the while loop will break.

    continuationMenu = menu('Do you wish to continue?', 'YES', 'NO');

    % If statement checking if the user selected yes, to proceed with the
    % code.
    if continuationMenu == 1

        % Fetchting crypto data from the API using the parameters
        % previously defined using the webread function.
        data = webread(url, options);


        % Intialising cryptonames, cryptoIds and cryptoCodes arrays.
        cryptoNames = [];
        cryptoIds = [];
        cryptoCodes = [];

        % Determining the number of rows in the data.data 2d array, to use
        % in the next for loop.
        [num, ~] = size(data.data);

        % For loop covering all different cryptocurrencies in the API's
        % data.data 2D array.
        for i = 1:num
            cryptoNames = [string(cryptoNames); string(data.data{i, 1}.name)]; % Appending the crypto names into the names matricie.
            cryptoIds = [cryptoIds; data.data{i, 1}.id]; % Appending the crypto ID's into the ID matricie.
            cryptoCodes = [cryptoCodes; string(data.data{i, 1}.symbol)]; % Appending the crypto code into the codes matricie.
        end

        % Assinging -1 to choice for the while loop.
        choice = -1;

        % Assinging index a value of 1.
        index = 1;

        % While loop when choice is less than zero, to ensure a
        % cryptocurrencey is selected from the menu option.
        while choice <= 0
            if index == 1
                choice = menu('Choose a cyptocurrencey for analysis: ', cryptoCodes); % Menu option displaying avaliable cryptos.
            else
                choice = menu('No selection was made, please select a cryptocurrencey! ', cryptoCodes); % If a selection was not made initially, this is the error proof to ensure it happens.
                index = index + 1; % This ensures the second menu is displayed for re selection, not the first.
            end
        end % End while loop.

        % Identifying the details of the selected crypto through accessing
        % where each individual piece of info is stored
        %  in the API data using the choice variable.
        idUsed = cryptoIds(choice, 1); % Crypto ID.
        cryptoName = cryptoNames{choice, 1}; % Crypto name.
        cryptoCode = cryptoCodes{choice, 1}; % Crpto code.
        maxSupply = data.data{choice, 1}.max_supply; % Maximum supply.
        circulatingSupply = data.data{choice, 1}.circulating_supply; % Circulating supply.
        totalSupply = data.data{choice, 1}.total_supply; % Total supply.
        dailyVolume = 1.55*data.data{choice, 1}.quote.USD.volume_24h; % 24h volume.
        hourChange = data.data{choice, 1}.quote.USD.percent_change_1h; % 1h change.
        dailyChange = data.data{choice, 1}.quote.USD.percent_change_24h; % 24h change.
        weeklyChange = data.data{choice, 1}.quote.USD.percent_change_7d; % 7d change.
        monthlyChange = data.data{choice, 1}.quote.USD.percent_change_30d; % 30d change.
        sixtyDayChange = data.data{choice, 1}.quote.USD.percent_change_60d; % 60d change.
        ninetyDayChange = data.data{choice, 1}.quote.USD.percent_change_90d; % 90d change.
        marketCap = data.data{choice, 1}.quote.USD.market_cap; % Coin market cap.
        significantDigits = 8;  % Number of significant digits

        % Printing the information of the chosen coin.
        fprintf('You have chosen to analyse %s! See below for some live information regarding %s\n', cryptoName, cryptoName);
        fprintf('\n');
        fprintf('Coin ID: %s\n', string(idUsed)); % Crypto ID.
        fprintf('\n');
        fprintf('Coin symbol: %s \n', cryptoCode); % Crpto code.
        fprintf('\n');
        fprintf('Maximum coin supply: %.0f\n', maxSupply); % Maximum supply.
        fprintf('\n');
        fprintf('Current circulating supply: %.2f\n', circulatingSupply); % Circulating supply.
        fprintf('\n');
        fprintf('Total supply: %d\n', totalSupply); % Total supply.
        fprintf('\n');
        fprintf('24 hour volume: %.2f\n', dailyVolume); % 24h volume.
        fprintf('\n');
        fprintf('Percentage change (1 hour): %%%.2f\n', hourChange); % 1h change.
        fprintf('\n');
        fprintf('Percentage change (24 hour): %%%.2f\n', dailyChange); % 24h change.
        fprintf('\n');
        fprintf('Percentage change (7 days): %%%.2f\n', weeklyChange); % 7d change.
        fprintf('\n');
        fprintf('Percentage change (30 days): %%%.2f\n', monthlyChange); % 30d change.
        fprintf('\n');
        fprintf('Percentage change (60 days): %%%.2f\n', sixtyDayChange); % 60d change.
        fprintf('\n');
        fprintf('Percentage change (90 days): %%%.2f\n', ninetyDayChange); % 90d change.
        fprintf('\n');
        fprintf('Market cap: $%.2f\n', marketCap); % Coin market cap.
        fprintf('\n');

        % Using a timer to consistently refresh the live price.
        livePriceTimer = timer;
        livePriceTimer.Period = 60; % Timer updates every 60 seconds.
        livePriceTimer.ExecutionMode = 'fixedRate'; % Updates at a fixed rate.

        % Uses timer function where the updateLivePrice function is called,
        % taking in the listed parameters to print the live price and when
        % it was last updated.
        livePriceTimer.TimerFcn = @(~,~) updateLivePrice(url, apiKey, choice, cryptoName, significantDigits);
        start(livePriceTimer); % Starts timer.

        % Provides a menu where the user can choose to continue analyse the
        % crypto or choose another.
        nextAction = menu('Choose an option: ', 'Continue with graphical analysis', 'Analyse a different cryptocurrency');

        % If they choose to analyse a different crypto, they will be taken
        % to the start, whereas otherwise the program will continue.
        if nextAction == 1
            % Timer is stopped and deleted to prevent it from continuously running.
            stop(livePriceTimer);
            delete(livePriceTimer);

            % Re printing users choice for clarity.
            fprintf('Continue with analysis: \n');
            fprintf('\n');

            % Print message to inform user of the upcoming graph.
            fprintf('See graph for the price of %s plotted against time. \n', cryptoName);

            % Identifies starting dates and prices using historicAnalysis
            % function.
            [startingDates, startingPrices] = historicAnalysis(idUsed);
            titleName = sprintf('Value of %s Over Time', cryptoName); % Defining graph title variable using sprintf to incorporate the cryptos name.

            % Plots starting dates and starting prices.
            figure;
            plot(startingDates, startingPrices);
            title(titleName); % Assigns graph title.
            xlabel ('Date'); % x-axis label of date.
            ylabel ('Price ($)'); % y-axis label of price.

            % Using sprintf to build the first menu option including the
            % crypto name.
            firstMenuOption = sprintf('Analyse %s investment stratergies', cryptoName);

            % Here is another menu where users can continue analysis or
            % choose a different cryptocurrencey under the same conditions
            % as before.
            nextStep = menu('Choose an option: ', firstMenuOption, 'Analyse a different cryptocurrency');

            % If they continue, the next section is where they can build
            % their trading stratergy and back test it against historic
            % data.
            if nextStep == 1

                % Prints instructions for this section for user to follow .
                fprintf('The most common trading stratergy utilises two moving averages.\n')
                fprintf('\n');
                fprintf('In the following sequences below, you will be asked how many moving averages you wish to input, and what those combinations are.\n');
                fprintf('\n')
                fprintf('Then, the algorithm will be run to determine which produces the most profit.\n')
                fprintf('\n')

                % Assigning user input variable to the amount the user is
                % willing to invest.
                userInput = input('Enter the amount you are willing to invest in each position ($): ', 's');

                % Converts the string input into double precision value.
                investmemtPerPosition = str2double(userInput);

                positiveInput = false; % Assigns positive input as false for while loop.

                % While loop which chekcs to see if the user input is
                % valud.
                while ~positiveInput
                    if ~isnan(investmemtPerPosition) && investmemtPerPosition > 0 % Chekcs to see if input was numerican using isNan function and if numerican input is greater than zero.
                        positiveInput = true;  % Correct value, exit loop
                    else
                        userInput =input('Please enter a valid investment: ','s');  % Request for input again for a valid input.
                        fprintf('\n');
                        investmemtPerPosition = str2double(userInput);
                    end
                end

                % Asks user for how many different MA combinations they
                % would like to try and assigns it to input variable.
                userInputTwo = input('How many moving average combinations do you want to compare? Please note, there is a limit of 15 combinations: ','s');
                fprintf('\n');

                % Converts the string input into double precision value.
                numCombinations = str2double(userInputTwo);
                validInput = false; % Assigns valid input as false for while loop.

                % while loop chekcs for valid input again.
                while ~validInput
                    if ~isnan(numCombinations) && numCombinations > 0 && mod(numCombinations, 1)==0 && numCombinations<=15 % Checks if input was numerical and is a whole number and less than 15.
                        validInput = true;  % Correct value, exit loop
                    else
                        userInputTwo =input('Please enter a valid number of combinations: ','s');  % Request for input again as string if input was invalid.
                        fprintf('\n');
                        numCombinations = str2double(userInputTwo);
                    end
                end

                % Building 2D array for MA combinations with zeros.
                maCombinations = zeros(numCombinations, 2);

                % Gains row and col variables which represent the size of
                % the prices variable for the selected crypto.
                [row, col] = size(startingPrices);

                % Tells user the conditions for the moving average inputs,
                % which cannot exceed the number of days which there is
                % data for.
                fprintf('Please note that the maximum moving average stragergy cannot exceed %.0f days, as this we do not posses data beyond that point.\n', row);
                fprintf('Also ensure the shorter moving average is above 0 days.\n') % Ensures user knows input must be greater than zero.
                fprintf('\n');

                % For loop getting user inputs for the different
                % combinations.
                for c = 1:numCombinations
                    fprintf('Combination %d: \n', c);
                    fprintf('\n');
                    userInputLead = input('Enter the shorter moving average window size: ', 's');
                    fprintf('\n');
                    userInputLag = input('Enter the larger moving average window size: ', 's');
                    fprintf('\n');

                    % Converts the string input into double precision value.
                    mainInputLead = str2double(userInputLead);
                    mainInputLag = str2double(userInputLag);

                    % Using same process as previously done to ensure the
                    % inputs are valid.
                    validInput = false;

                    while ~validInput
                        % If statements checs if input is numerican, above
                        % zero, whole numbers and if the larger window is
                        % greater than the smaller window.
                        if ~isnan(mainInputLead) && ~isnan(mainInputLag) && mainInputLead > 0 && mainInputLag > 0 &&  mod(mainInputLead, 1)==0 && mod(mainInputLag, 1)==0 && mainInputLag < row &&  mainInputLead < row && mainInputLag>mainInputLead
                            maCombinations(c, 1) = mainInputLead; % Assigns to correspondings maCombination position.
                            maCombinations(c, 2) = mainInputLag; % Assigns to correspondings maCombination position.
                            validInput = true; % Assigns true to exit while loop.
                        else % If the input was not valid.
                            fprintf('You did not enter a valid combination.\n'); % User informed of mistake.
                            fprintf('Please ensure you abide by the requirements.\n');
                            fprintf('Re enter the combination: \n');
                            userInputLead = input('Enter a valid shorter moving average window size: ', 's');
                            userInputLag = input('Enter a valid larger moving average window size: ', 's');% Request for input again as string.
                            mainInputLead = str2double(userInputLead);
                            mainInputLag = str2double(userInputLag);

                        end
                    end

                end

                % Building total return 2D array.
                totalReturn = zeros(numCombinations, 1);

                % For loop used to calculate the profits from using each
                % moving average combination.
                for f = 1:numCombinations
                    leadMa = movavg(startingPrices, 'exponential', maCombinations(f, 1));  % 5 day period exponential MA
                    lagMa = movavg(startingPrices, 'exponential', maCombinations(f, 2));  % 20 day period exponential MA

                    % Initialising short position.
                    short = [];

                    % For loop building short 2D array indicating buy and
                    % sell positions, where it is asssumed that the trade
                    % is completed seperatley at each opening position.
                    for j = 1:row
                        if leadMa(j, 1)<=lagMa(j, 1) % Occurs when the lagMA is greater than the leadMa, indicating short position.
                            short = [short; -1]; % Append to array.
                        elseif leadMa(j, 1)>lagMa(j, 1) % Occurs when leadMA is greater than leadMA indicating buy position.
                            short = [short; 1]; % Append to array.
                        end
                    end

                    % Initialising returns array.
                    returns = [];

                    % Assigning previous price to the first starting price.
                    prevPrice = startingPrices(1);

                    % For loop used to calcuate the profit/ returns
                    % starting from the second element as the first element
                    % is used as the initial previous price.
                    for q = 2:row
                        priceChange = startingPrices(q) - prevPrice; % Calculate price change between current price and previous price.
                        if short(q-1)>0 % Indicating buy position, money would have been invested, therefore profit needs to be calculated.
                            profit = (priceChange/prevPrice)*investmemtPerPosition; % Profit calcuated.
                            returns = [returns profit]; % Appended to returns vector.
                        end % No other condition is tested as if short(q-1)<0, then there is no trade signal.
                        prevPrice = startingPrices(q); % Assigns prevPrice to current loop iteration of starting price.
                    end

                    % Using sum function to calculate the total returns.
                    totalReturn(f) = sum(returns);
                end

                % Using sort function on total return so that it is sorted
                % in descending order, with the sortedMa's and the sorted
                % index assigned to the outputs as variables.
                [sortedMa, sortedIndex] = sort(totalReturn, "descend");

                % Displaying the rankings/ most effective combination using
                % for loop.
                fprintf('Ranking of Moving Average Combinations by Potential Profits:\n');
                for e = 1:numCombinations
                    runningIndex = sortedIndex(e, 1); % Assigns running index to the specific iteration of the sorted index array.
                    fprintf('Rank %d: MA(%d, %d) with a profit of $%.2f\n', e, maCombinations(runningIndex, 1), maCombinations(runningIndex, 2), sortedMa(e));
                end


            elseif nextStep == 2
                fprintf('Analyse a different cryptocurrency. \n'); % Displayed if user chose to not continue with analysis.
                fprintf('\n');
                continue % As continueAnalysis is still true, using continue will restart the program from the beginning, allowing the user to look at different cryptos.

            elseif nextAction ==2
                fprintf('Analyse a different cryptocurrency. \n'); % Displayed if user chose to not continue with analysis.
                fprintf('\n');
                continue % As continueAnalysis is still true, using continue will restart the program from the beginning, allowing the user to look at different cryptos.
            end
        else
            % Stops and deletes the timer if the user chose to look at
            % different cryptos in the first menu.
            stop(livePriceTimer);
            delete(livePriceTimer);
        end
    else
        % Occurs when the user selects "NO" in the continuation menu,
        % causing the while loop to be broken, stopping the program.
        break
    end

end % End original while loop.

