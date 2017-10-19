#!/bin/bash

CUR_DIR=`pwd`
SCRIPT_DIR=PB+TM
GE_DIR=ge
XGE_DIR=xge
CROSS=cross_card
SELF=self_card
ODD=odd
EVEN=even


mkdir -p $SCRIPT_DIR

cd $CUR_DIR/$SCRIPT_DIR
mkdir -p $GE_DIR
mkdir -p $XGE_DIR


# create GE directory
cd $CUR_DIR/$SCRIPT_DIR/$GE_DIR
mkdir -p $CROSS
mkdir -p $SELF
cd $CUR_DIR/$SCRIPT_DIR/$GE_DIR/$CROSS
mkdir -p $ODD
mkdir -p $EVEN
cd $CUR_DIR/$SCRIPT_DIR/$GE_DIR/$SELF
mkdir -p $ODD
mkdir -p $EVEN


# create XGE directory
cd $CUR_DIR/$SCRIPT_DIR/$XGE_DIR
mkdir -p $CROSS
mkdir -p $SELF


# ge: cross, odd
cd $CUR_DIR/$SCRIPT_DIR/$GE_DIR/$CROSS/$ODD
pb_flows_pair.sh -t 10ge -s 1 -d 13 -j 1 -k 1 -f tst_ge_1_13.txt
pb_flows_pair.sh -t 10ge -s 3 -d 15 -j 11 -k 11 -f tst_ge_3_15.txt    
pb_flows_pair.sh -t 10ge -s 5 -d 17 -j 21 -k 21 -f tst_ge_5_17.txt      
pb_flows_pair.sh -t 10ge -s 7 -d 19 -j 31 -k 31 -f tst_ge_7_19.txt      
pb_flows_pair.sh -t 10ge -s 9 -d 21 -j 41 -k 41 -f tst_ge_9_21.txt        
pb_flows_pair.sh -t 10ge -s 11 -d 23 -j 51 -k 51 -f tst_ge_11_23.txt 
 

# ge: cross, even
cd $CUR_DIR/$SCRIPT_DIR/$GE_DIR/$CROSS/$EVEN
pb_flows_pair.sh -t 10ge -s 2 -d 14 -j 1 -k 1 -f tst_ge_2_14.txt            
pb_flows_pair.sh -t 10ge -s 4 -d 16 -j 11 -k 11 -f tst_ge_4_16.txt    
pb_flows_pair.sh -t 10ge -s 6 -d 18 -j 21 -k 21 -f tst_ge_6_18.txt      
pb_flows_pair.sh -t 10ge -s 8 -d 20 -j 31 -k 31 -f tst_ge_8_20.txt      
pb_flows_pair.sh -t 10ge -s 10 -d 22 -j 41 -k 41 -f tst_ge_10_22.txt        
pb_flows_pair.sh -t 10ge -s 12 -d 24 -j 51 -k 51 -f tst_ge_12_24.txt


# ge: self, odd
cd $CUR_DIR/$SCRIPT_DIR/$GE_DIR/$SELF/$ODD
pb_flows_self.sh -t 10ge -s 1 -j 1 -f tst_ge_1.txt
pb_flows_self.sh -t 10ge -s 3 -j 11 -f tst_ge_3.txt    
pb_flows_self.sh -t 10ge -s 5 -j 21 -f tst_ge_5.txt      
pb_flows_self.sh -t 10ge -s 7 -j 31 -f tst_ge_7.txt      
pb_flows_self.sh -t 10ge -s 9 -j 41 -f tst_ge_9.txt        
pb_flows_self.sh -t 10ge -s 11 -j 51 -f tst_ge_11.txt 
pb_flows_self.sh -t 10ge -s 13 -j 1 -f tst_ge_13.txt
pb_flows_self.sh -t 10ge -s 15 -j 11 -f tst_ge_15.txt    
pb_flows_self.sh -t 10ge -s 17 -j 21 -f tst_ge_17.txt      
pb_flows_self.sh -t 10ge -s 19 -j 31 -f tst_ge_19.txt      
pb_flows_self.sh -t 10ge -s 21 -j 41 -f tst_ge_21.txt        
pb_flows_self.sh -t 10ge -s 23 -j 51 -f tst_ge_23.txt 
 

# ge: self, even
cd $CUR_DIR/$SCRIPT_DIR/$GE_DIR/$SELF/$EVEN
pb_flows_self.sh -t 10ge -s 2 -j 1 -f tst_ge_2.txt
pb_flows_self.sh -t 10ge -s 4 -j 11 -f tst_ge_4.txt    
pb_flows_self.sh -t 10ge -s 6 -j 21 -f tst_ge_6.txt      
pb_flows_self.sh -t 10ge -s 8 -j 31 -f tst_ge_8.txt      
pb_flows_self.sh -t 10ge -s 10 -j 41 -f tst_ge_10.txt        
pb_flows_self.sh -t 10ge -s 12 -j 51 -f tst_ge_12.txt 
pb_flows_self.sh -t 10ge -s 14 -j 1 -f tst_ge_14.txt
pb_flows_self.sh -t 10ge -s 16 -j 11 -f tst_ge_16.txt    
pb_flows_self.sh -t 10ge -s 18 -j 21 -f tst_ge_18.txt      
pb_flows_self.sh -t 10ge -s 20 -j 31 -f tst_ge_20.txt      
pb_flows_self.sh -t 10ge -s 22 -j 41 -f tst_ge_22.txt        
pb_flows_self.sh -t 10ge -s 24 -j 51 -f tst_ge_24.txt 


# xge: cross
cd $CUR_DIR/$SCRIPT_DIR/$XGE_DIR/$CROSS
pb_flows_pair.sh -t xge -s 1 -d 13 -j 1 -k 1 -f tst_xge_1_13.txt
pb_flows_pair.sh -t xge -s 2 -d 14 -j 2 -k 2 -f tst_xge_2_14.txt      
pb_flows_pair.sh -t xge -s 3 -d 15 -j 11 -k 11 -f tst_xge_3_15.txt        
pb_flows_pair.sh -t xge -s 4 -d 16 -j 12 -k 12 -f tst_xge_4_16.txt      
pb_flows_pair.sh -t xge -s 5 -d 17 -j 21 -k 21 -f tst_xge_5_17.txt        
pb_flows_pair.sh -t xge -s 6 -d 18 -j 22 -k 22 -f tst_xge_6_18.txt      
pb_flows_pair.sh -t xge -s 7 -d 19 -j 31 -k 31 -f tst_xge_7_19.txt        
pb_flows_pair.sh -t xge -s 8 -d 20 -j 32 -k 32 -f tst_xge_8_20.txt        
pb_flows_pair.sh -t xge -s 9 -d 21 -j 41 -k 41 -f tst_xge_9_21.txt
pb_flows_pair.sh -t xge -s 10 -d 22 -j 42 -k 42 -f tst_xge_10_22.txt
pb_flows_pair.sh -t xge -s 11 -d 23 -j 51 -k 51 -f tst_xge_11_23.txt        
pb_flows_pair.sh -t xge -s 12 -d 24 -j 52 -k 52 -f tst_xge_12_24.txt

# xge: self
cd $CUR_DIR/$SCRIPT_DIR/$XGE_DIR/$SELF
pb_flows_self.sh -t xge -s 1 -j 1 -f tst_xge_1.txt
pb_flows_self.sh -t xge -s 2 -j 2 -f tst_xge_2.txt      
pb_flows_self.sh -t xge -s 3 -j 11 -f tst_xge_3.txt    
pb_flows_self.sh -t xge -s 4 -j 12 -f tst_xge_4.txt      
pb_flows_self.sh -t xge -s 5 -j 21 -f tst_xge_5.txt    
pb_flows_self.sh -t xge -s 6 -j 22 -f tst_xge_6.txt   
pb_flows_self.sh -t xge -s 7 -j 31 -f tst_xge_7.txt 
pb_flows_self.sh -t xge -s 8 -j 32 -f tst_xge_8.txt   
pb_flows_self.sh -t xge -s 9 -j 41 -f tst_xge_9.txt    
pb_flows_self.sh -t xge -s 10 -j 42 -f tst_xge_10.txt   
pb_flows_self.sh -t xge -s 11 -j 51 -f tst_xge_11.txt    
pb_flows_self.sh -t xge -s 12 -j 52 -f tst_xge_12.txt   

pb_flows_self.sh -t xge -s 13 -j 1 -f tst_xge_13.txt    
pb_flows_self.sh -t xge -s 14 -j 2 -f tst_xge_14.txt   
pb_flows_self.sh -t xge -s 15 -j 11 -f tst_xge_15.txt   
pb_flows_self.sh -t xge -s 16 -j 12 -f tst_xge_16.txt   
pb_flows_self.sh -t xge -s 17 -j 21 -f tst_xge_17.txt    
pb_flows_self.sh -t xge -s 18 -j 22 -f tst_xge_18.txt   
pb_flows_self.sh -t xge -s 19 -j 31 -f tst_xge_19.txt    
pb_flows_self.sh -t xge -s 20 -j 32 -f tst_xge_20.txt     
pb_flows_self.sh -t xge -s 21 -j 41 -f tst_xge_21.txt    
pb_flows_self.sh -t xge -s 22 -j 42 -f tst_xge_22.txt    
pb_flows_self.sh -t xge -s 23 -j 51 -f tst_xge_23.txt    
pb_flows_self.sh -t xge -s 24 -j 52 -f tst_xge_24.txt    
