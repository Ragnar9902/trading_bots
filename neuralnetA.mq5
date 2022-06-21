//+------------------------------------------------------------------+
//|                                                   neuralnetA.mq5 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <DeepNeuralNetwork.mql.mqh> 
#include <Trade\Trade.mqh>
//MqlTradeRequest request; // request
MqlTradeResult result; //response os try set order

//objects define 
CTrade my_Trade;

//global bariables

int numInput     = 8;
int numHiddenA   = 4;
int numHiddenB   = 5;
int numOutput    = 3;
MqlTick tick;
MqlRates candles[];
double weight[];
double xValues[];
double yValues[];

DeepNeuralNetwork dnn(numInput,numHiddenA,numHiddenB,numOutput);

//input users
input double sl        = 5;
input double tp        = 2;
input double num_lot   = 0.2;
input int magic_number = 2;
//--- weight & bias values
input double w0=-1.0;
input double w1=-1.0;
input double w2=-1.0;
input double w3=-1.0;
input double w4=-1.0;
input double w5=-1.0;
input double w6=-1.0;
input double w7=-1.0;
input double w8=-1.0;
input double w9=-1.0;
input double w10=-1.0;
input double w11=-1.0;
input double w12=-1.0;
input double w13=-1.0;
input double w14=-1.0;
input double w15=-1.0;
input double b0=-1.0;
input double b1=-1.0;
input double b2=-1.0;
input double b3=-1.0;
input double w40=-1.0;
input double w41=-1.0;
input double w42=-1.0;
input double w43=-1.0;
input double w44=-1.0;
input double w45=-1.0;
input double w46=-1.0;
input double w47=-1.0;
input double w48=-1.0;
input double w49=-1.0;
input double w50=-1.0;
input double w51=-1.0;
input double w52=-1.0;
input double w53=-1.0;
input double w54=-1.0;
input double w55=-1.0;
input double w56=-1.0;
input double w57=-1.0;
input double w58=-1.0;
input double w59=-1.0;
input double b4=-1.0;
input double b5=-1.0;
input double b6=-1.0;
input double b7=-1.0;
input double b8=-1.0;
input double w60=-1.0;
input double w61=-1.0;
input double w62=-1.0;
input double w63=-1.0;
input double w64=-1.0;
input double w65=-1.0;
input double w66=-1.0;
input double w67=-1.0;
input double w68=-1.0;
input double w69=-1.0;
input double w70=-1.0;
input double w71=-1.0;
input double w72=-1.0;
input double w73=-1.0;
input double w74=-1.0;
input double b9=-1.0;
input double b10=-1.0;
input double b11=-1.0;

//+------------------------------------------------------------------+
//|percentage of each part of the candle respecting total size       |
//+------------------------------------------------------------------+
int CandlePatterns(double high_1,double low_1,double open_1,double close_1,double uod_1, double high_2,double low_2,double open_2,double close_2,double uod_2,double &xInputs[])
  {
   double p100_1=high_1-low_1;//Total candle size   
   double highPer_1=0;
   double lowPer_1=0;
   double bodyPer_1=0;
   double trend_1=0;
   double p100_2=high_2-low_2;//Total candle size   
   double highPer_2=0;
   double lowPer_2=0;
   double bodyPer_2=0;
   double trend_2=0;

   if(uod_1>0)
     {
      highPer_1=high_1-close_1;
      lowPer_1=open_1-low_1;
      bodyPer_1=close_1-open_1;
      trend_1=1;

     }
   else
     {
      highPer_1=high_1-open_1;
      lowPer_1=close_1-low_1;
      bodyPer_1=open_1-close_1;
      trend_1=0;
     }
   if(p100_1==0)return(-1);
   //xInputs[0]=highPer/p100;
   highPer_1 = highPer_1/p100_1;
   CopyBuffer(highPer_1,0, 0, 8, xInputs);
   xInputs[1]=lowPer_1/p100_1;
   xInputs[2]=bodyPer_1/p100_1;
   xInputs[3]=trend_1;

   if(uod_2>0)
     {
      highPer_2=high_2-close_2;
      lowPer_2=open_2-low_2;
      bodyPer_2=close_2-open_2;
      trend_2=1;

     }
   else
     {
      highPer_2=high_2-open_2;
      lowPer_2=close_2-low_2;
      bodyPer_2=open_2-close_2;
      trend_2=0;
     }
   if(p100_2==0)return(-1);
   //xInputs[0]=highPer/p100;
   highPer_2 = highPer_2/p100_2;
   //CopyBuffer(highPer_2,4, 0, 8, xInputs);
   xInputs[4]=highPer_2;
   xInputs[5]=lowPer_2/p100_2;
   xInputs[6]=bodyPer_2/p100_2;
   xInputs[7]=trend_2;
   return(1);

  }
  
//function for send buy order
void BuyAtMarket()
   {
   MqlTradeRequest request; // request
   MqlTradeResult response; //response os try set order
   
   ZeroMemory(request);
   ZeroMemory(response);
   
   request.action = TRADE_ACTION_DEAL;
   request.magic  = magic_number;
   request.symbol = _Symbol;
   request.volume = num_lot;
   request.price  = NormalizeDouble(tick.ask, _Digits);
   request.sl     = NormalizeDouble(tick.ask -sl*_Point, _Digits);
   request.tp     = NormalizeDouble(tick.ask +tp*_Point, _Digits);
   request.deviation = 0;
   request.type   = ORDER_TYPE_BUY;
   request.type_filling = ORDER_FILLING_FOK;
   
   //send order
   OrderSend(request, response);
   //look if the order was succeded
   if(response.retcode == 10008 || response.retcode == 10009)
     {
      Print("order buy was execute seccessfully");
     }else
      {
       Print("error try to send buy order");
      }
 }
 
void SellAtMarket()
   {
   MqlTradeRequest request; // request
   MqlTradeResult response; //response os try set order
   
   ZeroMemory(request);
   ZeroMemory(response);
   
   request.action = TRADE_ACTION_DEAL;
   request.magic  = magic_number;
   request.symbol = _Symbol;
   request.volume = num_lot;
   request.price  = NormalizeDouble(tick.bid, _Digits);
   request.sl     = NormalizeDouble(tick.bid -sl*_Point, _Digits);
   request.tp     = NormalizeDouble(tick.bid +tp*_Point, _Digits);
   request.deviation = 0;
   request.type   = ORDER_TYPE_SELL;
   request.type_filling = ORDER_FILLING_FOK;
   
   //send order
   OrderSend(request, response);
   //look if the order was succeded
   if(response.retcode == 10008 || response.retcode == 10009)
     {
      Print("order sell was execute seccessfully");
     }else
      {
       Print("error try to send buy order");
      }
 }
 

void CloseBuy()
   {
   MqlTradeRequest request; // request
   MqlTradeResult response; //response os try set order
   
   ZeroMemory(request);
   ZeroMemory(response);
   
   request.action = TRADE_ACTION_DEAL;
   request.magic  = magic_number;
   request.symbol = _Symbol;
   request.volume = num_lot;
   request.price  = NormalizeDouble(tick.ask, _Digits);;
   //request.sl     = NormalizeDouble(tick.ask -sl*_Point, _Digits);
   //request.tp     = NormalizeDouble(tick.ask +tp*_Point, _Digits);
   //request.deviation = 0;
   request.type   = ORDER_TYPE_SELL;
   request.type_filling = ORDER_FILLING_FOK;
   
   //send order
   OrderSend(request, response);
   //look if the order was succeded
   if(response.retcode == 10008 || response.retcode == 10009)
     {
      Print("order to sell was execute seccessfully");
     }else
      {
       Print("error try to send sell order");
      }
   }
void CloseSell()
   {
   MqlTradeRequest request; // request
   MqlTradeResult response; //response os try set order
   
   ZeroMemory(request);
   ZeroMemory(response);
   
   request.action = TRADE_ACTION_DEAL;
   request.magic  = magic_number;
   request.symbol = _Symbol;
   request.volume = num_lot;
   request.price  = NormalizeDouble(tick.bid, _Digits);;
   //request.sl     = NormalizeDouble(tick.ask -sl*_Point, _Digits);
   //request.tp     = NormalizeDouble(tick.ask +tp*_Point, _Digits);
   //request.deviation = 0;
   request.type   = ORDER_TYPE_BUY;
   request.type_filling = ORDER_FILLING_FOK;
   
   //send order
   OrderSend(request, response);
   //look if the order was succeded
   if(response.retcode == 10008 || response.retcode == 10009)
     {
      Print("order to buy was execute seccessfully");
     }else
      {
       Print("error try to send buy order");
      }
   }
   
/* for bar change*/
bool isNewbar()
{
   static datetime last_time = 0;
   datetime lastbar_time = (datetime) SeriesInfoInteger(Symbol(),Period(),SERIES_LASTBAR_DATE);
   if(last_time==0)
     {
      last_time = lastbar_time;
      return false;
     }
     
    if(last_time != lastbar_time)
      {
       last_time = lastbar_time;
       return true;
      }
    return false ;
}

//draw vertical line
void drawVerticalLine(string name, datetime dt, color cor = clrAliceBlue)
   {
   ObjectDelete(0, name);
   ObjectCreate(0, name, OBJ_VLINE, 0, dt,0);
   ObjectSetInteger(0, name, OBJPROP_COLOR, cor);
   }
   
void GetLastResult(MqlTradeResult &result)
      {
      my_Trade.Result(result);
      }

 
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   //my_Trade.SetExpertMagicNumber(magic_number);
   //my_Trade.SetDeviationInPoints(0);
   //weight[0] = w0;
   CopyBuffer(w0,0,0,63,weight);
   weight[1] = w1;
   weight[2] = w2;
   weight[3] = w3;
   weight[4] = w4;
   weight[5] = w5;
   weight[6] = w6;
   weight[7] = w7;
   weight[8] = w8;
   weight[9] = w9;
   weight[10] = w10;
   weight[11] = w11;
   weight[12] = w12;
   weight[13] = w13;
   weight[14] = w14;
   weight[15] = w15;   
   weight[16] = b0;
   weight[17] = b1;
   weight[18] = b2;
   weight[19] = b3;
   weight[20] = w40;
   weight[21] = w41;
   weight[22] = w42;
   weight[23] = w43;
   weight[24] = w44;
   weight[25] = w45;
   weight[26] = w46;
   weight[27] = w48;
   weight[28] = w49;
   weight[29] = w50;
   weight[30] = w51;
   weight[31] = w52;
   weight[32] = w53;
   weight[33] = w54;
   weight[34] = w55;
   weight[35] = w56;
   weight[36] = w57;
   weight[37] = w58;
   weight[38] = w59;
   weight[39] = w60;
   weight[40] = b4;
   weight[41] = b5;
   weight[42] = b6;
   weight[43] = b7;
   weight[44] = b8;
   weight[45] = w61;
   weight[46] = w62;
   weight[47] = w63;
   weight[48] = w64;
   weight[49] = w65;
   weight[50] = w66;
   weight[51] = w67;
   weight[52] = w68;
   weight[53] = w69;
   weight[54] = w70;
   weight[55] = w71;
   weight[56] = w72;
   weight[57] = w73;
   weight[58] = w74;
   weight[59] = w14;
   weight[60] = b9;
   weight[61] = b10;
   weight[62] = b11;

   dnn.SetWeights(weight);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   if(isNewbar())
     {
      
      int copied=CopyRates(_Symbol,0,1,5,candles);
      SymbolInfoTick(_Symbol, tick);
      ArraySetAsSeries(candles,true);

      //Compute the percent of the upper shadow, lower shadow and body in base of sum 100%
      int error=CandlePatterns(candles[0].high,candles[0].low,candles[0].open,candles[0].close,candles[0].close-candles[0].open,candles[1].high,candles[1].low,candles[1].open,candles[1].close,candles[1].close-candles[1].open, xValues);
      //int error2=CandlePatterns(candles[1].high,candles[1].low,candles[1].open,candles[1].close,candles[1].close-candles[1].open, 2_xValues);
      if(error<0)return;
      
      dnn.ComputeOutputs(xValues,yValues);
      Print("hello wordl");
      
      //--- if the output value of the neuron is mare than 60%
   if(yValues[0]>0.6)
     {
     if(my_Trade.RequestAction()==TRADE_ACTION_DEAL)
       {
            if(my_Trade.RequestType() == POSITION_TYPE_SELL) CloseSell();//Close the opposite position if exists
            if(my_Trade.RequestType() == POSITION_TYPE_BUY) return;
       }

      //my_Trade.Buy(num_lot,_Symbol,NormalizeDouble(tick.ask, _Digits),NormalizeDouble(tick.ask - sl*_Point, _Digits), NormalizeDouble(tick.ask + tp*_Point, _Digits));//open a Long position
         Print("my last action request was: ",my_Trade.RequestAction());
         drawVerticalLine("Buy", candles[0].time, clrRed);
         BuyAtMarket();
     }
//--- if the output value of the neuron is mare than 60%
   if(yValues[1]>0.6)
     {
     if(my_Trade.RequestAction()==TRADE_ACTION_DEAL)
       {     
        if(my_Trade.RequestType()==POSITION_TYPE_BUY) CloseBuy();//Close the opposite position if exists
        if(my_Trade.RequestType()==POSITION_TYPE_SELL) return;
      }
      //my_Trade.Sell(num_lot,_Symbol,NormalizeDouble(tick.ask, _Digits),NormalizeDouble(tick.ask + sl*_Point, _Digits), NormalizeDouble(tick.ask - tp*_Point, _Digits));//open a Short position
         drawVerticalLine("Sell", candles[1].time, clrRed);
         SellAtMarket();
     }

   if(yValues[2]>0.6)
     {
     //close any position
     if(my_Trade.RequestAction() == TRADE_ACTION_DEAL)
       {
        if(my_Trade.RequestType()==POSITION_TYPE_BUY) CloseBuy();
        if(my_Trade.RequestType()==POSITION_TYPE_SELL)CloseSell();
       }             

     }
      
     }
  }
//+------------------------------------------------------------------+
