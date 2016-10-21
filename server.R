# Developing Data Products - Course Project
# 10/12/2016

# setwd("./Course Project")

library(shiny)
library(ggplot2)
library(grid)
library(gridExtra)
library(caret)

shinyServer(function(input, output) {
    
    diamonds_subset<-diamonds[,c(1:4,7)]
    diamonds_subset$cut<-factor(diamonds_subset$cut,ordered=FALSE)
    diamonds_subset$color<-factor(diamonds_subset$color,ordered=FALSE)
    diamonds_subset$clarity<-factor(diamonds_subset$clarity,ordered=FALSE)

    fit1<-lm(price~carat+cut+color+clarity,data=diamonds_subset)
    pred1<-predict(fit1,diamonds_subset)
    
    fit2<-lm(price~carat*cut+carat*color+carat*clarity,data=diamonds_subset)
    pred2<-predict(fit2,diamonds_subset)

    fit3<-lm(price~carat*(cut+color+clarity)+I(carat^2)*(cut+color+clarity)+carat:cut:color:clarity+I(carat^2):cut:color:clarity,data=diamonds_subset)
    pred3<-predict(fit3,diamonds_subset)
    diamonds_out<-cbind(diamonds_subset,pred1,pred2,pred3)

    model1pred <- reactive({
    caratInput <- input$carat
    cutInput <- input$cut
    colorInput <- input$color
    clarityInput <- input$clarity
    predict(fit1, newdata = data.frame(carat=caratInput,cut=cutInput,color=colorInput,clarity=clarityInput))
    })
    
    model2pred <- reactive({
        caratInput <- input$carat
        cutInput <- input$cut
        colorInput <- input$color
        clarityInput <- input$clarity
        predict(fit2, newdata = data.frame(carat=caratInput,cut=cutInput,color=colorInput,clarity=clarityInput))
    })
 
    model3pred <- reactive({
        caratInput <- input$carat
        cutInput <- input$cut
        colorInput <- input$color
        clarityInput <- input$clarity
        predict(fit3, newdata = data.frame(carat=caratInput,cut=cutInput,color=colorInput,clarity=clarityInput))
    })  
     
   output$plot1 <- renderPlot({
       caratInput <- input$carat
       cutInput <- input$cut
       colorInput <- input$color
       clarityInput <- input$clarity
       a<-ggplot(data=diamonds_out[which(diamonds_out$cut==cutInput&diamonds_out$color==colorInput&diamonds_out$clarity==clarityInput),],aes(x=carat,y=price))+
           geom_point()+geom_line(aes(y=pred1),color=5,size=1.5)+geom_point(aes(x=caratInput,y=model1pred()),color="red",size=5)+
           ggtitle("Model 1")
       b<-ggplot(data=diamonds_out[which(diamonds_out$cut==cutInput&diamonds_out$color==colorInput&diamonds_out$clarity==clarityInput),],aes(x=carat,y=price))+
           geom_point()+geom_line(aes(y=pred2),color=6,size=1.5)+geom_point(aes(x=caratInput,y=model2pred()),color="red",size=5)+
           ggtitle("Model 2")
       c<-ggplot(data=diamonds_out[which(diamonds_out$cut==cutInput&diamonds_out$color==colorInput&diamonds_out$clarity==clarityInput),],aes(x=carat,y=price))+
           geom_point()+geom_line(aes(y=pred3),color=7,size=1.5)+geom_point(aes(x=caratInput,y=model3pred()),color="red",size=5)+
           ggtitle("Model 3")
       grid.arrange(a,b,c,ncol=3,top=textGrob(paste("Diamond Prices: Cut =",cutInput,", Color =",colorInput,", Clarity =",clarityInput),gp=gpar(fontsize=20,font=3)))
   })

  output$pred1 <- renderText({
    paste("Model 1 - Simple Linear Fit:",round(model1pred(),2))
  })
  
  output$pred2 <- renderText({
      paste("Model 2 - Linear Fit with Interactions:",round(model2pred(),2))
  })

  output$pred3 <- renderText({
      paste("Model 3 - Quadratic Fit with Interactions:",round(model3pred(),2))
  })
  
})
