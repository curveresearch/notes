---
title: "Curve Cryptoswap: From Whitepaper to Vyper"
author: Curve Research\footnote{Curve Research is a community organization funded through the Curve DAO grants program and is not affiliated with Curve Finance (Swiss Stake GmbH).  Neither Curve Research nor Curve DAO are responsible for any damages that result from use of the provided information or guarantee its accuracy.}
email: info@curveresearch.org
date: \today
header-includes: |
    \usepackage{draftwatermark}
    \SetWatermarkLightness{0.95}
---


# Introduction

This is a second paper in the "From Whitepaper to Vyper" series.  The first covered the Stableswap invariant and this will cover the extension of it to handle volatile pairs.

As with the first paper, we endeavour to cover important details of implementation, both financial logic and code, underlying the array of live contracts already deployed across multiple chains, highlighting changes from the whitepaper and emphasizing the ideas needed to understand the contract logic.  All the while, we seek to give straightforward explanations of any background concepts needed.


# Preliminaries (notation and conventions)

## Cryptoswap equation
Recall the stableswap equation:

$$ A \cdot n^n  \sum_i x_i + D = A \cdot n^n \cdot D + \frac{D^{n+1}}{n^n \prod_i x_i}$$



