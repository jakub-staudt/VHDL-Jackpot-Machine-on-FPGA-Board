----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/13/2025 05:10:26 PM
-- Design Name: 
-- Module Name: JackpotMachine - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity JackpotMachine is
    Port ( R : in STD_LOGIC;
           clk_slow : in std_logic;
           clk_med : std_logic;
           clk : in std_logic; --fast clock
           JackBTN : in STD_LOGIC_VECTOR (2 downto 0);
           Yctr0 : in STD_LOGIC_VECTOR (2 downto 0);
           Yctr1 : in STD_LOGIC_VECTOR (2 downto 0);
           Yctr2 : in STD_LOGIC_VECTOR (2 downto 0);
           --Cntr : in STD_LOGIC_VECTOR (2 downto 0);
           DisplayPwr : out STD_LOGIC;
           Jack_Clear_BTN : in std_logic;
           CLK_CLR : out STD_LOGIC;
           tmpcnt_run_state : out std_logic_vector(2 downto 0);
           test : out std_logic_vector(1 downto 0);
           RGB_LEFT_color_state : out STD_LOGIC_VECTOR (1 downto 0);
           RGB_RIGHT_color_state : out STD_LOGIC_VECTOR (1 downto 0);
           CLK_slow_ctr: out STD_LOGIC_VECTOR (2 downto 0));
end JackpotMachine;

architecture Behavioral of JackpotMachine is

type state_type is (Running, Stop0, Stop1, Stop2, Results, Clear, Reset);

signal current_state, next_state, last_state  : state_type;
signal JackBTNcnt, sigRGBout, sigRGBout2 : std_logic_vector(2 downto 0);
signal cnt_run_state : std_logic_vector(2 downto 0) := (others => '1');
signal EN_Flash7Seg, dispCLK : std_logic := '0';
signal tmpDisplayPwr : std_logic := '1';
signal disp_counter : std_logic_vector (15 downto 0) := (others => '0') ;
--signal RGB_LEFT_color_state,RGB_RIGHT_color_state : std_logic_vector(1 downto 0);

begin

--current_state <= next_state;

--Change before next CLK rising edge for the reset = prevent racing conditions
process(clk, R)
begin
    if R = '1' then
        current_state <= Reset;
        last_state <= Reset;
    elsif rising_edge(clk) then --Moves to next state
        -- BEGIN: if conditions for turning on the LEDS are met:
        if current_state = Stop0 and cnt_run_state(0) = '0' then
            if Yctr0 = Yctr1 and cnt_run_state(1) = '0' then
                RGB_LEFT_color_state <= "10";
            end if;
        end if;

        if current_state = Stop1 and cnt_run_state(1) = '0' then
            if Yctr0 = Yctr1 and cnt_run_state(0) = '0' then
                RGB_LEFT_color_state <= "10";
            end if;
            if Yctr1 = Yctr2 and cnt_run_state(2) = '0' then
                RGB_RIGHT_color_state <= "10";
            end if;
        end if;

        if current_state = Stop2 and cnt_run_state(2) = '0' then
            if Yctr1 = Yctr2 and cnt_run_state(1) = '0' then
                RGB_RIGHT_color_state <= "10";
            end if;
        end if;

        -- clear LEDs inside Clear state
        if current_state = Clear OR current_state = Reset then
            RGB_LEFT_color_state  <= "00";
            RGB_RIGHT_color_state <= "00";
        end if;
      -- END: if conditions for turning on the LEDS are met
    
        last_state <= current_state;
        current_state <= next_state;
    end if;
end process;





--process(R, clk, JackBTN)
process(current_state, JackBTN, Jack_Clear_BTN, R, clk)
begin

    -- default assignments (avoid latches)
    --test <= "00";
    --RGB_LEFT_color_state <= "00";
    --RGB_RIGHT_color_state <= "00";
    CLK_CLR <= '0';
    EN_Flash7Seg <= '0';

    next_state <= current_state;

    --if (R = '1') then
    --    next_state  <= Reset;

    --elsif (rising_edge(clk)) then
    case current_state is

        when Running =>
            --
            if (JackBTN(0) = '1') then
                next_state <= Stop0;
            end if;
            
            if (JackBTN(1) = '1') then
                next_state <= Stop1;
            end if;
            
            if (JackBTN(2) = '1') then
                next_state <= Stop2;
            end if; 
        
            
            --Go to results when all the counters stopped
            if cnt_run_state = "000" then 
                next_state <= Results;        
            end if; 
                
            -----------------------------------

        when Stop0 =>
            -- stop cnt only if it's still running
            --if cnt_run_state(0) = '1' then
            --    cnt_run_state(0) <= '0';
            --end if;
            
            if cnt_run_state(0) = '1' then
                next_state <= stop0; --stay for one more CLK cycle as the cnt_run_state needs to be toggled in the next process()-below this one   
            else
                --Left RGB blink function               
--                if (Yctr0 = Yctr1) and cnt_run_state(1) = '0' then -- the 'cnt_run_state()' is used to make sure both cnts are not running anymore
--                    RGB_LEFT_color_state <= "10";
--                end if;
                next_state <= Running;
            end if;
            -----------------------------------

        when Stop1 =>
            -- stop cnt
            --if cnt_run_state(1) = '1' then
            --    cnt_run_state(1) <= '0';
            --end if;
            
            if cnt_run_state(1) = '1' then
                next_state <= stop1; --stay for one more CLK cycle as the cnt_run_state needs to be toggled in the next process()-below this one
            else            
                --Left RGB blink function
--                if  (Yctr0 = Yctr1) and cnt_run_state(0) = '0' then
--                    RGB_LEFT_color_state <= "10";
--                end if;
                
                --Right RGB blink function 
--                if  (Yctr1 = Yctr2) and cnt_run_state(2) = '0' then
--                    RGB_RIGHT_color_state <= "10";                   
--                end if;
                
                next_state <= Running;
            end if;
            -----------------------------------
            
        when Stop2 =>
            -- stop cnt
            --if cnt_run_state(2) = '1' then
            --    cnt_run_state(2) <= '0';
            --end if; 
            
            if cnt_run_state(2) = '1' then
                next_state <= stop2; --stay for one more CLK cycle as the cnt_run_state needs to be toggled in the next process()-below this one   

            else
                --Right RGB blink function                                   
--                if (Yctr1 = Yctr2) and cnt_run_state(1) = '0' then
--                    RGB_RIGHT_color_state <= "10";
--                end if;
                
                next_state <= Running; 
            end if;               
            -----------------------------------

        when Results =>
            
            if (Yctr0 = Yctr1) and (Yctr1 = Yctr2) and R = '0' then
                --flash screen if JACKPOT 
                EN_Flash7Seg <= '1';   
            end if;   

            if Jack_Clear_BTN = '1' then
                next_state <= Clear;
            end if;
            -----------------------------------

        when Clear =>
            --clear the RGB LEDs and reset the 3 CLKs
            --test <= "10";
            CLK_CLR <= '0'; --prevent a reseted CLKs if it's currently reseted
                            
            
            --RGB_LEFT_color_state <= "00";
            --RGB_RIGHT_color_state <= "00";
            --clear CLKs
            --CLK_CLR <= '1';
            
            EN_Flash7Seg <= '0';
            --turn on running of CLKs
            --cnt_run_state <= (others => '1');
            
            if current_state = Clear and last_state = Clear then --the purpose is to make sure all the above conditions are finished and stabilse before the following state change on the CLK rising
                next_state <= Running;
            else
                next_state <= Clear;
            end if;
            -----------------------------------
            
         when Reset =>
            --test <= "01";
            CLK_CLR <= '1'; --reset CLKs
          
            --RGB_LEFT_color_state <= "00";
            --RGB_RIGHT_color_state <= "00";
            EN_Flash7Seg <= '1';
           
            if R = '0' then
                next_state <= Clear;
            else
                next_state <= Reset;
            end if;             
            
            -----------------------------------
         when others =>
            next_state <= Reset;                                                       
    end case;
    --end if;
end process;


--Process for the 'cnt_run_state' - becuase we can't use:             
--if cnt_run_state(2) = '1' then cnt_run_state(2) <= '0'; end if;
--It works like a latch then, which is unstable 
process(clk, R)
begin
    if R = '1' then
        cnt_run_state <= (others => '1');
    
    elsif rising_edge(clk) then
        if current_state = Stop0 then 
            cnt_run_state(0) <= '0'; 
        end if;
        if current_state = Stop1 then 
            cnt_run_state(1) <= '0'; 
        end if;
        if current_state = Stop2 then 
            cnt_run_state(2) <= '0'; 
        end if;
        if current_state = Clear then 
                cnt_run_state <= (others => '1'); 
        end if;
    end if;
end process;




CLK_slow_ctr(0) <= clk_slow and cnt_run_state(0); 
CLK_slow_ctr(1) <= clk_slow and cnt_run_state(1);
CLK_slow_ctr(2) <= clk_slow and cnt_run_state(2); 






--PWM flashing of 7SEG display
process(clk, EN_Flash7Seg)
begin
        if EN_Flash7Seg = '1' then
            --tmpDisplayPwr <= '0';
            --PWM dflashing of the display
            if (rising_edge(clk))then 
                disp_counter <= disp_counter + 1 ;
                
                if (disp_counter  = 10000) then
                    tmpDisplayPwr <= '1';
                    disp_counter   <= (others => '0') ;
                elsif (disp_counter  = 5000) then
                tmpDisplayPwr <= '0';
                end if;
            end if;
        else
            --Constantly turned on Display
            tmpDisplayPwr <= '1';
        --end if;
        end if;  
end process;


DisplayPwr<= tmpDisplayPwr;
tmpcnt_run_state  <= cnt_run_state;

--Used for the run state of the Counters to have them stop and not run when BTN press stopped
--cnt_state0 : component Tff port map (S=>'0',R=>R,CLK=>clk,T=> JackBTNcnt(0), Q => cnt_run_state(0));
--cnt_state1 : component Tff port map (S=>'0',R=>R,CLK=>clk,T=> JackBTNcnt(1), Q => cnt_run_state(1));
--cnt_state2 : component Tff port map (S=>'0',R=>R,CLK=>clk,T=> JackBTNcnt(2), Q => cnt_run_state(2));


--rgbLeft: component RBG_leds port map (color_state => RGB_LEFT_color_state, RGBout => sigRGBout, clk => clk, clk_slow => clk_slow);
--rgbRight: component RBG_leds port map (color_state => RGB_RIGHT_color_state, RGBout => sigRGBout2, clk => clk, clk_slow => clk_slow);

--RGBout <= sigRGBout;
--RGBout2 <= sigRGBout2;


end Behavioral;
