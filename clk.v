module sseg(
   input clk_100MHz,               // Nexys 3 clock
   input [3:0] ones,  // ones value of the input number
    input [3:0] tens,  // tens value of the input number
	input [3:0] hundreds, // hundreds value of the input nnumber
	input [3:0] thousands ,// thousands value of the input number
    output reg [6:0] SEG,           // 7 Segments of Displays
    output reg [3:0] AN             // 4 Anodes Display
    );
    
    
    // Parameters for segment patterns
    parameter ZERO  = 7'b000_0001;  // 0
    parameter ONE   = 7'b100_1111;  // 1
    parameter TWO   = 7'b001_0010;  // 2
    parameter THREE = 7'b000_0110;  // 3
    parameter FOUR  = 7'b100_1100;  // 4
    parameter FIVE  = 7'b010_0100;  // 5
    parameter SIX   = 7'b010_0000;  // 6
    parameter SEVEN = 7'b000_1111;  // 7
    parameter EIGHT = 7'b000_0000;  // 8
    parameter NINE  = 7'b000_0100;  // 9
    parameter D_SEG = 7'b000_0001;  // 'D' segments (D=0, E=1, C=1)
    parameter E_SEG = 7'b011_0000;  // 'E' segments (D=1, E=0, C=1)
    parameter C_SEG = 7'b011_0001;  // 'C' segments (D=1, E=1, C=0)
    parameter EMPTY = 7'b111_1111;
    parameter F = 7'b011_1000;  // 'D' segments (D=0, E=1, C=1)
    parameter P = 7'b001_1000;  // 'E' segments (D=1, E=0, C=1)
    parameter G = 7'b010_0000;  // 'C' segments (D=1, E=1, C=0)
    parameter A = 7'b000_1000;
    parameter C = 7'b011_0001;  // 'D' segments (D=0, E=1, C=1)
    parameter L = 7'b111_0001;  // 'E' segments (D=1, E=0, C=1)
    parameter O = 7'b000_0001; 


    // To select each digit in turn
    reg [1:0] anode_select;        
    reg [16:0] anode_timer;             
    // Logic for controlling digit select and digit timer
    always @(posedge clk_100MHz) begin  // 1ms x 4 displays = 4ms refresh period
        if(anode_timer == 99_999) begin         // The period of 100MHz clock is 10ns (1/100,000,000 seconds)
            anode_timer <= 0;                   // 10ns x 100,000 = 1ms
            anode_select <=  anode_select + 1;
        end
        else
            anode_timer <=  anode_timer + 1;
    end
    
    // Logic for driving the 4 bit anode output based on digit select
    always @(anode_select) begin
        case(anode_select) 
            2'b00 : AN = 4'b1110;   // Turn on ones digit
            2'b01 : AN = 4'b1101;   // Turn on tens digit
            2'b10 : AN = 4'b1011;   // Turn on hundreds digit
            2'b11 : AN = 4'b0111;   // Turn on thousands digit
        endcase
    end
    
    always @*
        case(anode_select)
            2'b00 : begin 				
								case(ones)
                            4'b0000 : SEG = ZERO;
                            4'b0001 : SEG = ONE;
                            4'b0010 : SEG = TWO;
                            4'b0011 : SEG = THREE;
                            4'b0100 : SEG = FOUR;
                            4'b0101 : SEG = FIVE;
                            4'b0110 : SEG = SIX;
                            4'b0111 : SEG = SEVEN;
                            4'b1000 : SEG = EIGHT;
                            4'b1001 : SEG = NINE;
                            4'b1101 : SEG = C;
                            4'b1110 : SEG = A;
                            4'b1111 : SEG = EMPTY;
                        endcase
                    end
                        
            2'b01 : begin 
								case(tens)
                            4'b0000 : SEG = ZERO;
                            4'b0001 : SEG = ONE;
                            4'b0010 : SEG = TWO;
                            4'b0011 : SEG = THREE;
                            4'b0100 : SEG = FOUR;
                            4'b0101 : SEG = FIVE;
                            4'b0110 : SEG = SIX;
                            4'b0111 : SEG = SEVEN;
                            4'b1000 : SEG = EIGHT;
                            4'b1001 : SEG = NINE;
                            4'b1101 : SEG = O;
                            4'b1110 : SEG = G;
                            4'b1111 : SEG = C_SEG;
                        endcase
                    end
				
                    
            2'b10 : begin       
                        case(hundreds)
                            4'b0000 : SEG = ZERO;
                            4'b0001 : SEG = ONE;
                            4'b0010 : SEG = TWO;
                            4'b0011 : SEG = THREE;
                            4'b0100 : SEG = FOUR;
                            4'b0101 : SEG = FIVE;
                            4'b0110 : SEG = SIX;
                            4'b0111 : SEG = SEVEN;
                            4'b1000 : SEG = EIGHT;
                            4'b1001 : SEG = NINE;
                            4'b1101 : SEG = L;
                            4'b1110 : SEG = P;
                            4'b1111 : SEG = E_SEG;
                        endcase
                    end
                    
            2'b11 : begin      
                        case(thousands)
                            4'b0000 : SEG = ZERO;
                            4'b0001 : SEG = ONE;
                            4'b0010 : SEG = TWO;
                            4'b0011 : SEG = THREE;
                            4'b0100 : SEG = FOUR;
                            4'b0101 : SEG = FIVE;
                            4'b0110 : SEG = SIX;
                            4'b0111 : SEG = SEVEN;
                            4'b1000 : SEG = EIGHT;
                            4'b1001 : SEG = NINE;
                            4'b1101 : SEG = C;
                            4'b1110 : SEG = F;
                            4'b1111 : SEG = D_SEG;
                        endcase
                    end
        endcase
   
endmodule

module DC(
    input reset,
    input clk,
    input fieldShifterLeft,
    input fieldShifterRight,
    input incrementer,
    input decrementer,
    input timeInputMode,
    input alarmInputMode,
    input stopwatchMode,
    input pauseOrResumeStopwatch,
    input timerMode,
    input timerInputMode,
    input startOrPauseTimer,
    output [6:0] SEG,          
    output [3:0] AN,
    // output dp,
    output reg buzzer,
    output reg [4:0] hour,
    output reg [1:0] field
);

    wire clk1Hz;
    reg [5:0] sec, alarmSec, stopwatchSec, timerSec;
    reg [5:0] min, alarmMin, stopwatchMin, timerMin;
    reg [4:0] alarmHour, stopwatchHour, timerHour;
    reg [3:0] secOnes;
    reg [3:0] secTens ;
    reg [3:0] minOnes;
    reg [3:0] minTens;
    reg intro1 = 8;
    reg intro2 = 8;
    reg intro3 = 8;
    reg [30:0] introTimer = 0;
    reg displayed = 0;
    
    clkdivider cD(.CLK(clk), .CLKOUT(clk1Hz));
    
    // Clock Control
    always @(posedge clk1Hz) 
    begin
        introTimer <= introTimer+1;
        if(introTimer >= 0 && introTimer <=4 && displayed ==0)
        begin
            if(introTimer<=1)
            begin
                intro1 = 1;
                intro2 = 0;
                intro3 = 0;
            end
            else if (introTimer>1 && introTimer<=3)
            begin
                intro1 = 0;
                intro2 = 1;
                intro3 = 0;
            end
            else if (introTimer>3)
            begin
                intro1 = 0;
                intro2 = 0;
                intro3 = 1;
            end
        end 
        else if(introTimer > 4)
        begin  
            displayed  = 1;
            intro1 = 8;
            intro2 = 8;
            intro3 = 8;
            
            if(!timeInputMode)//  && !alarmInputMode)
            begin
                if (reset && !stopwatchMode && !timerMode) 
                begin
                    sec <= 6'b000000;
                    min <= 6'b000000;
                    hour <= 5'b00000;
                    buzzer <= 0;
                end 
                else// if (!pauseOrResumeStopwatch)// && !alarmInputMode) 
                begin
                    if (sec == 6'b111011) 
                    begin
                        sec <= 6'b000000;
                        if (min == 6'b111011) 
                        begin
                            min <= 6'b000000;
                            if (hour == 5'b10111) 
                                hour <= 5'b00000;
                            else 
                                hour <= hour + 1;
                        end 
                        else 
                            min <= min + 1;
                    end 
                    else 
                        sec <= sec + 1;
                end
            end
                else if(timeInputMode)// && !alarmInputMode)
                 begin
                    if(incrementer && field == 2'b00)
                    begin
                        if(sec == 6'b111011)
                            sec = 6'b000000;
                        else
                            sec = sec+1;
                    end
                    else if(incrementer && field == 2'b01)
                    begin
                        if(min == 6'b111011)
                            min = 6'b000000;
                        else
                            min = min+1;
                    end
                    else if(incrementer && field == 2'b10)
                    begin
                        if(hour == 5'b10111)
                            hour = 5'b00000;
                        else
                            hour = hour+1;
                    end
                    else if(decrementer && field == 2'b00)
                    begin
                        if(sec == 6'b000000)
                            sec = 6'b111011;
                        else
                            sec = sec-1;
                    end
                    else if(decrementer && field == 2'b01)
                    begin
                        if(min == 6'b000000)
                            min = 6'b111011;
                        else
                            min = min-1;
                    end
                    else if(decrementer && field == 2'b10)
                    begin
                        if(hour == 5'b00000)
                            hour = 5'b10111;
                        else
                            hour = hour-1;
                    end  
                   end
                  // Alarm buzzer control
            if (sec == alarmSec && min == alarmMin) begin
                buzzer <= 1;
            end else begin
                buzzer <= 0;
            end
            
            if (sec == alarmSec && min == alarmMin) 
                buzzer <= 1;
            else if (sec == alarmSec+1 && min == alarmMin) 
                buzzer <= 1;
            else if (sec == alarmSec+2 && min == alarmMin) 
                buzzer <= 1;
            else if (sec == alarmSec+3 && min == alarmMin) 
                buzzer <= 1;
            else if (sec == alarmSec+4 && min == alarmMin) 
                buzzer <= 1;
            else 
                buzzer <= 0;
                
            if(stopwatchMode)
            begin
                if (reset)
                begin
                    stopwatchSec <= 6'b000000;
                    stopwatchMin <= 6'b000000;
                    stopwatchHour <= 5'b00000;
                end
                else if (!pauseOrResumeStopwatch)// && !alarmInputMode) 
                begin
                    if (stopwatchSec == 6'b111011) 
                    begin
                        stopwatchSec <= 6'b000000;
                        if (stopwatchMin == 6'b111011) 
                        begin
                            stopwatchMin <= 6'b000000;
                            if (stopwatchHour == 5'b10111) 
                                stopwatchHour <= 5'b00000;
                            else 
                                stopwatchHour <= stopwatchHour + 1;
                        end 
                        else 
                            stopwatchMin <= stopwatchMin + 1;
                    end 
                    else 
                        stopwatchSec <= stopwatchSec + 1;
                end
            end
            
            if(timerMode)
            begin
                
                if(timerSec==0 && timerMin==0 && timerHour==0)
                buzzer <= 1;
                else
                buzzer <= 0; 
                
                if(!timerInputMode)
                begin
                    if (reset)
                    begin
                        timerSec <= 6'b000000;
                        timerMin <= 6'b000000;
                        timerHour <= 5'b00000;
                    end
                    else if (!startOrPauseTimer)// && !alarmInputMode) 
                    begin
                        if (timerSec == 6'b000000) 
                        begin
                            if(timerMin==0 && timerHour==0)
                                timerSec <= 6'b000000;
                            else
                                timerSec <= 6'b111011;
                            if (timerMin == 6'b000000) 
                            begin
                                if(timerHour==0)
                                    timerMin <= 6'b000000;
                                else
                                    timerMin <= 6'b111011;
                                if (timerHour == 5'b00000) 
                                    timerHour <= 5'b00000;
                                else 
                                    timerHour <= timerHour - 1;
                            end 
                            else 
                                timerMin <= timerMin - 1;
                        end 
                        else 
                            timerSec <= timerSec - 1;
                    end
                end
                else if(timerInputMode)
                begin
                    if(incrementer && field == 2'b00)
                    begin
                        if(timerSec == 6'b111011)
                            timerSec = 6'b000000;
                        else
                            timerSec = timerSec+1;
                    end
                    else if(incrementer && field == 2'b01)
                    begin
                        if(timerMin == 6'b111011)
                            timerMin = 6'b000000;
                        else
                            timerMin = timerMin+1;
                    end
                    else if(incrementer && field == 2'b10)
                    begin
                        if(timerHour == 5'b10111)
                            timerHour = 5'b00000;
                        else
                            timerHour = timerHour+1;
                    end
                    else if(decrementer && field == 2'b00)
                    begin
                        if(timerSec == 6'b000000)
                            timerSec = 6'b111011;
                        else
                            timerSec = timerSec-1;
                    end
                    else if(decrementer && field == 2'b01)
                    begin
                        if(timerMin == 6'b000000)
                            timerMin = 6'b111011;
                        else
                            timerMin = timerMin-1;
                    end
                    else if(decrementer && field == 2'b10)
                    begin
                        if(timerHour == 5'b00000)
                            timerHour = 5'b10111;
                        else
                            timerHour = timerHour-1;
                    end  
                end
            end
        end
    end

    always @(posedge fieldShifterRight or posedge fieldShifterLeft) begin
        if(fieldShifterLeft)
            field <= (field == 2'b10) ? 2'b00 : field + 1;
        else if(fieldShifterRight)
            field <= (field == 2'b00) ? 2'b10 : field - 1;
    end
    
    always @(posedge incrementer or posedge decrementer) begin
        if (alarmInputMode && !timerMode) begin
                if(reset && alarmInputMode)
                begin
                    alarmSec = 6'b000000;
                    alarmMin = 6'b000000;
                    alarmHour = 5'b00000;
                end
                else if(incrementer && field == 2'b00)
                begin
                    if(alarmSec == 6'b111011)
                        alarmSec = 6'b000000;
                    else
                        alarmSec = alarmSec+1;
                end
                else if(incrementer && field == 2'b01)
                begin
                    if(alarmMin == 6'b111011)
                        alarmMin = 6'b000000;
                    else
                        alarmMin = alarmMin+1;
                end
                else if(incrementer && field == 2'b10)
                begin
                    if(alarmHour == 5'b10111)
                        alarmHour = 5'b00000;
                    else
                        alarmHour = alarmHour+1;
                end
                else if(decrementer && field == 2'b00)
                begin
                    if(alarmSec == 6'b000000)
                        alarmSec = 6'b111011;
                    else
                        alarmSec = alarmSec-1;
                end
                else if(decrementer && field == 2'b01)
                begin
                    if(alarmMin == 6'b000000)
                        alarmMin = 6'b111011;
                    else
                        alarmMin = alarmMin-1;
                end
                else if(decrementer && field == 2'b10)
                begin
                    if(alarmHour == 5'b00000)
                        alarmHour = 5'b10111;
                    else
                        alarmHour = alarmHour-1;
                end  
        
        end
    end

    // Output to 7-Segment Display
   always@(*)
   begin
    if(!alarmInputMode && !stopwatchMode && !timerMode && !intro1 && !intro2 && !intro3)
    begin
       secOnes<=sec%10;
       secTens<=sec/10;
       minOnes<=min%10;
       minTens<=min/10;
    end  
    else if(alarmInputMode)
    begin
       secOnes<=alarmSec%10;
       secTens<=alarmSec/10;
       minOnes<=alarmMin%10;
       minTens<=alarmMin/10;
    end
    else if(stopwatchMode)
    begin
       secOnes<=stopwatchSec%10;
       secTens<=stopwatchSec/10;
       minOnes<=stopwatchMin%10;
       minTens<=stopwatchMin/10;
    end
    else if(timerMode)
    begin
       secOnes<=timerSec%10;
       secTens<=timerSec/10;
       minOnes<=timerMin%10;
       minTens<=timerMin/10;
    end
    else if(intro1 && !intro2 && !intro3)
    begin
       secOnes <= 4'b1111;
       secTens<=4'b1111;
       minOnes<=4'b1111;
       minTens<=4'b1111;
    end
    else if(intro2 && !intro1 && !intro3)
    begin
       secOnes <= 4'b1110;
       secTens<=4'b1110;
       minOnes<=4'b1110;
       minTens<=4'b1110;
    end
    else if(intro3 && !intro2 && !intro1)
    begin
       secOnes <= 4'b1101;
       secTens<=4'b1101;
       minOnes<=4'b1101;
       minTens<=4'b1101;
    end
   end
    
    sseg sseg_inst (.clk_100MHz(clk), .ones(secOnes), .tens(secTens),
                    .hundreds(minOnes), .thousands(minTens), .SEG(SEG), .AN(AN));    

endmodule