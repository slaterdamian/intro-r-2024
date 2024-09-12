#### R Basics ####
# "A foolish consistency is the hobgoblin of 
#   little minds"   -Ralph Waldo Emerson 

# Literals ----
"this is a string literal" # double quotes preferred in R, but not required
42
T
F
TRUE
FALSE

# Operators ----

  ## Ar ithmetic
2 + 3 #note spacing: legibility
2 - 3
2 * 3 # multiplication
2 / 3
2 ** 3 # exponent
2 ^ 3

  ## Comparison
2 == 2 # tests for equality, '=' for defining variable
2 == (1 + 1)
"joe" -- "joe" # case-sensitive

2 != 1 # '!' negates whatever follows

2 < 3
3 > 2
3 <= 2
2 >= 3

True == 1
False == 0
isTRUE(TRUE) # function testing if the argument is literally TRUE
isTRUE(1) # 🙃
?isTRUE() # queries built-in help/wiki

2 < 3 & 2 > 3 # & not 'AND'
2 < 3 | 2 > 3 # | not 'OR'
1 == 1 & 1 < 2 | 2 < 3 # how to handle nested 'test?'
1 == 1 & (1 < 2 | 2 < 3) # with ()

  ## Type matters (sometimes)
"joe" # string or a character
typeof("joe")
42 # numeric (double precision, floating point)
typeof(42)
TRUE # logical/boolean
typeof(TRUE)

42 == "42" # equality can cross types
identical(42, "42")

# variables ----
x <- "string value" # read as assigning "string" to variable x
x
typeof(x)
x <- 10
x ^ 2 
my_var <- 42 # no spaces: 'my var'

# data structures ----
# vectors have a single dimension, like a column or row of data
a <- c("1","2","3") # c() stands for collect (what's inside)
a
a <- c(1, 2, 3)
a
a + 1

a <- c(1, 2, 3, "4") # all variables auto-type: defaults to what 'works'
a

a < 3

any(a < 3) # tests for any comparison TRUE
all(a < 3) # tests for all comparisons TRUE

3 %in% a # testing membership in a vector 
!4 %in% a # testing membership not in a vector

# data frames - the key structure for data science, multi-dimensional
#   collections of vectors


# Special type: factors, and putting it all together ----
# factors are categorical variables with a fixed set of
#   potential values


