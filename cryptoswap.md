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

As with the first paper, we endeavour to cover important details of implementation (both financial logic and code) underlying the array of live contracts already deployed across multiple chains, highlighting changes from the whitepaper, and emphasizing the ideas needed to understand the contract logic.  Throughout, we seek to give concise but straightforward explanations of any background concepts needed, although this is intended more as an aid than for completeness.


# Preliminaries (notation and conventions)

## Cryptoswap equation
Recall the stableswap equation:

$$ A \cdot n^n  \sum_i x_i + D = A \cdot n^n \cdot D + \frac{D^{n+1}}{n^n \prod_i x_i}$$

In the original derivation of the equation in the stableswap whitepaper, an intermediate equation was produced:


$$ \left(A \frac{n^n \prod_i x_i}{D^n}\right) D^{n-1} \sum_i x_i + \prod_i x_i = \left(A \frac{n^n \prod_i x_i}{D^n}\right) D^n + \left(\frac{D}{n}\right)^n$$

(The equations are easily seen to be equivalent, to get from the first to second, multiply each side by $\frac{\prod x_i }{ D}$ and introduce the canceling powers of $D$ as needed)

Setting $K_0 = \frac{n^n \prod_i x_i}{D}$, we obtain:


$$ A K_0 D^{n-1} \sum_i x_i + \prod_i x_i = A K_0 D^n + \left(\frac{D}{n}\right)^n $$

Note we haven't done anything new except reformulate the stableswap equation with the coefficient $K_0$.  

As the pool's coin balances tend toward equal ("balanced"), $K_0 \rightarrow 1$.  As the pool tends toward imbalance, $K_0 \rightarrow 0$


Readers already familiar with the stableswap will understand that $K_0$ doesn't change in a steady fashion.  As a pool starts getting imbalanced, $K_0$ changes moderately, waiting until a turning point, upon which it experiences greater and greater acceleration to $0$.

In order to provide concentrated liquidity as with stableswap but with a faster transition to a constant product AMM ($K_0 = 0$), it seems natural to introduce an auxiliary parameter $\gamma$:

$$ K = A K_0 \frac{\gamma^2}{(\gamma + 1 - K_0)^2} $$

When $K_0 = 1$, $K = AK_0$

When $K_0 = 0$, $K = A K_0 \frac{\gamma^2}{(\gamma + 1)^2} $

For a positive $\gamma$ much smaller than 1, this will push $K$ toward 0 much faster


So the cryptoswap equation is:


$$ K D^{n-1} \sum_i x_i + \prod_i x_i = K D^n + \left(\frac{D}{n}\right)^n $$
