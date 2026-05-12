----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2025 11:30:17 AM
-- Design Name: 
-- Module Name: main - Behavioral
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
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
    Port (  CLK : in std_logic;
            RGBin: in std_logic_vector (1 downto 0);
            JackBTN : in std_logic_vector (2 downto 0);
            Jack_Clear_BTN : in std_logic;
            RGBout: out std_logic_vector (2 downto 0);
            RGBout2: out std_logic_vector (2 downto 0);
            R : in std_logic;
            CLK_OUT : out std_logic;
            test : out std_logic_vector(1 downto 0);
            --Ybcd : out std_logic_vector( 4 downto 0);             
            Yout: out std_logic_vector (2 downto 0); -- LEDs next to the buttons showing the 4-bit counter output in binary
                   
            --Yout1, Yout2 : out std_logic_vector (3 downto 0); 
            
            tmpcnt_run_state: out std_logic_vector (2 downto 0);  
            DisplayPwr : out std_logic;     
            Yseg7: out  std_logic_vector (7 downto 0); 
            Yan7: out  std_logic_vector (7 downto 0));  -- The anodes, selects which digits should be filled with the Yseg7 inidividual lights      
end main;

architecture Behavioral of main is


component sync4bitupTff is
    Port ( CLK : in STD_LOGIC;
           R : in STD_LOGIC;
           Y : out STD_LOGIC_VECTOR (2 downto 0));
end component;

component clk_div is
    Port ( CLK_IN : in STD_LOGIC;            
           CLK_OUT1 : out STD_LOGIC; -- slow clock (standard)
           CLK_OUT2 : out STD_LOGIC; -- mid-speed clock
           CLK_OUT3 : out STD_LOGIC); -- fast clock  
end component;

component abcd_to_7seg is
    Port ( DisplayPwr : in STD_LOGIC;
           X : in STD_LOGIC_VECTOR (3 downto 0);
           Y : out STD_LOGIC_VECTOR (6 downto 0)); --segment output (a-g) of the display
end component;

component MUX is
    Port ( X0 : in STD_LOGIC_VECTOR (2 downto 0);
           X1 : in STD_LOGIC_VECTOR (2 downto 0);
           X2 : in STD_LOGIC_VECTOR (2 downto 0);
           Ymux : out STD_LOGIC_VECTOR (3 downto 0);
           S : in STD_LOGIC_VECTOR (1 downto 0));
end component;

component dec2to4 is
    Port ( Xdec : in STD_LOGIC_VECTOR (1 downto 0);
           Ydec : out STD_LOGIC_VECTOR (2 downto 0));
end component;

component bin4_to_bcd5 is
    Port ( X : in STD_LOGIC_VECTOR (3 downto 0);
           Y : out STD_LOGIC_VECTOR (4 downto 0));
end component;

component RBG_leds is
 Port     ( color_state : in STD_LOGIC_VECTOR (1 downto 0);
           RGBout : out STD_LOGIC_VECTOR (2 downto 0);
           clk : in STD_LOGIC;
           clk_slow : in STD_LOGIC);
           
end component;


component Tff is
    Port ( S : in STD_LOGIC;
           R : in STD_LOGIC;
           CLK : in STD_LOGIC;
           T : in STD_LOGIC;
           Q : out STD_LOGIC;
           NQ : out STD_LOGIC);
end component;

component JackpotMachine is
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
end component;


signal clk_slow, clk_med, clk_fast, clk_slow_temp, clk_jackpot : std_logic;
signal Sig_tmp : std_logic_vector (1 downto 0) :="00";
signal Yanode, clk_slow_ctr : std_logic_vector (2 downto 0);
--signal Ybcd_tmp : std_logic_vector ( 4 downto 0);
signal Yabcd_tmp : std_logic_vector ( 3 downto 0);
signal DIG0, DIG1, DIG2, Yctr_tmp0, Yctr_tmp1, Yctr_tmp2 : std_logic_vector ( 2 downto 0);
signal Yabcdseg : std_logic_vector ( 6 downto 0);
signal Jackpot : std_logic := '0';
signal sigDisplayPwr, R_CLR : std_logic;
signal sigRGB_LEFT_color_state, sigRGB_RIGHT_color_state : std_logic_vector(1 downto 0);

begin
div: component  clk_div port map (CLK_IN => CLK, CLK_OUT1 => clk_slow, CLK_OUT2 => clk_med, CLK_OUT3 => clk_fast);   
ctr0: component sync4bitupTff port map ( CLK=>CLK_slow_ctr(0), R=> R_CLR, Y=>Yctr_tmp0); 
ctr1: component sync4bitupTff port map ( CLK=>CLK_slow_ctr(1), R=> R_CLR, Y=>Yctr_tmp1); 
ctr2: component sync4bitupTff port map ( CLK=>CLK_slow_ctr(2), R=> R_CLR, Y=>Yctr_tmp2);

--bcd: component bin4_to_bcd5 port map (X =>Yctr_tmp0  , Y=>Ybcd_tmp);
swit: component MUX port map (S => Sig_tmp, X0 => DIG0, X1 => DIG1, X2 => DIG2, Ymux => Yabcd_tmp);
dec: component  dec2to4 port map (Xdec => Sig_tmp, Ydec => Yanode);
seg7: component  abcd_to_7seg port map (DisplayPwr => sigDisplayPwr, X => Yabcd_tmp, Y =>Yabcdseg);

rgbLeft: component RBG_leds port map (color_state => sigRGB_LEFT_color_state , RGBout => RGBout2, clk => clk, clk_slow => clk_slow);
rgbRight: component RBG_leds port map (color_state => sigRGB_RIGHT_color_state , RGBout => RGBout, clk => clk, clk_slow => clk_slow);


JackMach: component JackpotMachine port map(R => R, clk_slow => clk_slow, clk_med => clk_med, clk=> clk_fast, JackBTN =>JackBTN, Yctr0 => Yctr_tmp0, Yctr1 => Yctr_tmp1, Yctr2 => Yctr_tmp2, 
        RGB_LEFT_color_state => sigRGB_LEFT_color_state, RGB_RIGHT_color_state => sigRGB_RIGHT_color_state, CLK_slow_ctr => CLK_slow_ctr, DisplayPwr => sigDisplayPwr, 
        tmpcnt_run_state => tmpcnt_run_state, Jack_Clear_BTN => Jack_Clear_BTN, CLK_CLR => R_CLR, test => test);


-- 3 digits value for RHS display
DIG0 <= Yctr_tmp0;  --0s number => 
DIG1 <= Yctr_tmp1; --10s number
DIG2 <= Yctr_tmp2; --100s number

 

-- 2-bit signal counter, which acts as a selector for the multiplexer and the dec2to4
process(clk_fast)
begin
if rising_edge(clk_fast) then
    Sig_tmp <= Sig_tmp +1; 
end if;
end process;


--We get JACKPOT
--Jackpot <= JackBTN(0) and JackBTN(1) and JackBTN(2);
    

--CLK for counters only works if there is no Jackpot
--CLK_slow_ctr(0) <= clk_slow and not JackBTN(0);
--CLK_slow_ctr(0) <= clk_slow and not JackBTN(1);
--CLK_slow_ctr(0) <= clk_slow and not JackBTN(2);

--This one worked:
--CLK_slow_ctr(0) <= clk_slow and not cnt_run_state(0); 
--CLK_slow_ctr(1) <= clk_slow and not cnt_run_state(1);
--CLK_slow_ctr(2) <= clk_slow and not cnt_run_state(2); 

--CLK for Jackpot that's being used for the TFFs
 --clk_jackpot <= clk_slow and not Jack_BTN_R;

--resets the jackpot machine
--process(clk_fast)
--begin
--if rising_edge(Jack_BTN_R) then
--    Jackpot <= '0';              
--end if;
--end process; 




CLK_OUT <= clk_slow; -- LED (V11) flashes, used for debugging
Yout <= Yctr_tmp0; --LEDs
--Yout1 <= Yctr_tmp1; --LEDs
--Yout2 <= Yctr_tmp2; --LEDs
--Ybcd <= Ybcd_tmp; --LEDs


Yseg7(7) <= not '0';
Yseg7(6 downto 0) <= not Yabcdseg;

Yan7(2 downto 0) <= not Yanode; -- RHS display select
Yan7(7 downto 3) <= not "00000"; --LHS display select

DisplayPwr <= sigDisplayPwr;
--R_CLR <= R;

end Behavioral;
