library(caret)
library(doMC)
training <- read.csv("/Users/kange2014/Coursera/Machine_Learning/pml-training.csv")
testing <- read.csv("/Users/kange2014/Coursera/Machine_Learning/pml-testing.csv")

### 10 fold cross validation
#k <- 10

#folds <- createFolds(y=training$classe,k=10,list=TRUE,returnTrain=TRUE)

#modelFit <- train(classe ~.,data=training,method="glm")
### args(train) args(trainControl), for the setting of cross validation

### basic processing of variables
### standardizing: Imputing
#preobj <- preProcess(training[,-160],method="knnImpute")
### for example
#pitch_belt <- predict(preobj,training[,-160])$pitch_belt

### Features selected for model building,
### referring to Velloso, E.; Bulling, A.; Gellersen, H.; Ugulino, W.; Fuks, H. 
### Qualitative Activity Recognition of Weight Lifting Exercises. Proceedings 
### of 4th International Conference in Cooperation with SIGCHI (Augmented Human '13) . 
### Stuttgart, Germany: ACM SIGCHI, 2013.

### 17 features were selected: in the belt, were selected the mean and variance of the roll, 
### maximum, range and variance of the accelerometer vector, variance of the gyro and variance
### of the magnetometer. In the arm, the variance of the accelerometer vector and the maximum
### and minimum of the magnetometer were selected. In the dumbbell, the selected features were 
### the maximum of the acceleration, variance of the gyro and maximum and minimum of the 
### magnetometer, while in the glove, the sum of the pitch and the maximum and minimum of the 
### gyro were selected.

# "avg_roll_belt" "var_roll_belt" 
# "var_accel_arm" 
# 
# "pitch_forearm" 

tmp <- c()
length <- ncol(training)

for(i in 1:length){
  if(anyNA(training[,i])){ tmp <- c(tmp,i)}
  else if(anyNA(testing[,i])){tmp <- c(tmp,i)}
}

training <- training[,-c(1:7,tmp)]

testing <- testing[,-c(1:7,tmp)]

set.seed(32323)
registerDoMC(cores=2)

fitControl <- trainControl(
  ## 10-fold CV
  method = "repeatedcv",
  number = 10,
  ## repeated 3 times
  repeats = 3,
  allowParallel=TRUE
)

modFit <- train(classe~., method="rf",data=training,ntree=100,trControl=fitControl)

fitControl <- trainControl(
  ## oob for random forest
  method = "oob",allowParallel=TRUE)

modFit2 <- train(classe~., method="rf",data=training,ntree=100,trControl=fitControl)

pred <- predict(modFit,testing)
