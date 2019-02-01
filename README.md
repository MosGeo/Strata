# Strata - A Markov chain based stratigraphic simulator within a sequence stratigraphic framework

Cyclostratigraphy in the rock is prevelant. We often rely on it to make predictions. The puropse of this code is to simulate a 1D stratigrahic section that closely resembles what is observed in reality. I've decided to do this by incorporating a sequence stratigraphic framework into the model. This means that the simulation incorporates external forcing such as chaning in the sea level and the amount sediment sourcing. In addition erosion can also be incorporated as a Markov state with negative depostion.

<div align="center">
    <img width=800 src="https://github.com/MosGeo/Strata/blob/master/ReadmeFiles/Realizations.png" alt="Realizations" title="Multiple realizations"</img>
</div>

## How to use
See the example Matlab script folder for possible usage. Basically 1) define the transition matrices and depositional rates at different sea levels, 2) define sea level curve, 3) Run. Possible usage into projects include:
- Study the effect of changing cyclostratigraphic pattern on different outputs such as the seismic signal.
- Study the effect of upscaling on different outputs.
- Create a training dataset for machine learning.

An example of usage is below. Note that most of the code is setting up the input parameters.

```
% Parameters
age = (0:200)';
seaLevelAge = 0:.01:200;
seaLevelHeight = sin(seaLevelAge/20) +  .25*sin(seaLevelAge/5);
markovMatrices{1} = [.1 .4 .5; .1 .5 .4; 0 .3 .7];   % Shallow
markovMatrices{2} = [.7 .2 .1; .4 .5 .1; .4 .4 .2];  % Deep
depositionalRates = [1, 1, 1];

% Simulate and plot stratigraphy
strata = simulateStrata(markovMatrices, age, seaLevelAge, seaLevelHeight, depositionalRates);
plotStrata(strata);
```

## Upscaling
Upscaling functions are included. Mean and Mode moving window upscaling are implemented. See the example file on how for further details. General usage:

```
smoothingInterval = 3;
strata = upscaleStrata(strata, smoothingInterval, 'mode');
strata = upscaleStrata(strata, smoothingInterval, 'mean');
```

<div align="center">
    <img width=800 src="https://github.com/MosGeo/Strata/blob/master/ReadmeFiles/MeanModeUpscaling.png" alt="MeanMode" title="Upscaling"</img>
</div>


## Referencing
Al Ibrahim, M. A., Strata: A Markov chain based stratigraphic simulator within a sequence stratigraphic framework: Website, https://github.com/MosGeo/Strata/.
