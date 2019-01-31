# Strata - A Markov chain based stratigraphic simulator within a sequence stratigraphic framework

Cyclostratigraphy in the rock is prevelant. We often rely on it to make predictions. The puropse of this code is to simulate a 1D stratigrahic section that closely resembles what is observed in reality. I've decided to do this by incorporating a sequence stratigraphic framework into the model. This means that the simulation incorporates external forcing such as chaning in the sea level and the amount sediment sourcing. In addition erosion can also be incorporated as a Markov state with negative depostion.

<div align="center">
    <img width=800 src="https://github.com/MosGeo/Strata/blob/master/ReadmeFiles/Realizations.png" alt="TopImage" title="Image of particle pack"</img>
</div>

## Possible usage
- Study the effect of changing cyclostratigraphic pattern on different outputs such as the seismic signal.
- Study the effect of upscaling on different outputs.
- Create a training dataset for machine learning.

## How to use
See the example Matlab script folder for possible usage. Basically
- Define the transition matrices and depositional rates at different sea levels.
- Define sea level curve.
- Run.

## Other features
Upscaling functions are included. Mean and Mode moving window upscaling are implemented. See examples for how to use.

## Referencing
For now, you can reference this Github repository if you use the code.
