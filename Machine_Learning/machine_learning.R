library(caret)
training <- read.csv("/Users/kange2014/Coursera/Machine_Learning/pml-training.csv")
testing <- read.csv("/Users/kange2014/Coursera/Machine_Learning/pml-testing.csv")

### 10 fold cross validation
#k <- 10

set.seed(32323)
#folds <- creatFolds(y=$training$classe,k=10,list=TRUE,returnTrain=TRUE)

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


#for(i in 1:ncol(training)){
#  if(any(training[,1]){ 
#    training <- training[,-i]
#    testing <- testing[,-i]
#  }
#}

fitControl <- trainControl(
  ## 10-fold CV
  method = "repeatedcv",
  number = 10,
  ## repeated ten times
  repeats = 10
)

modFit <- train(classe~., method="rf",data=training[,-c(1:7)],prox=TRUE,trControl=fitControl)

fitControl <- trainControl(
  ## oob for random forest
  method = "oob"
)
modFit2 <- train(classe~., method="rf",data=training[,-c(1:7)],prox=TRUE,trControl=fitControl)

pred <- predict(modFit,testing[,-c(1:7)])
