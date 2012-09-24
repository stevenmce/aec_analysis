This is a special R script which can be used to generate a report. You can
write normal text in roxygen comments.

First we set up some options (you do not have to do this):




The report begins here.


```r
# boring examples as usual
set.seed(123)
x = rnorm(5)
mean(x)
```

```
## [1] 0.1936
```


Now we continue writing the report. We can draw plots as well.


```r
par(mar = c(4, 4, 0.1, 0.1))
plot(x)
```

![plot of chunk test-b](figure/silk-test-b.png) 


Actually you do not have to write chunk options, in which case knitr will use
default options. For example, the code below has no options attached:


```r
var(x)
```

```
## [1] 0.6578
```

```r
quantile(x)
```

```
##       0%      25%      50%      75%     100% 
## -0.56048 -0.23018  0.07051  0.12929  1.55871 
```


And you can also write two chunks successively like this:


```r
sum(x^2)  # chi-square distribution with df 5
```

```
## [1] 2.818
```

```r
sum((x - mean(x))^2)  # df is 4 now
```

```
## [1] 2.631
```


Done. Call spin('knitr-spin.R') to make silk from sow's ear now and knit a
lovely purse.
