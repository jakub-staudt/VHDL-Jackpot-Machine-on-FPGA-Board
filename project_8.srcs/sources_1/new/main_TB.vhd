----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/02/2025 08:41:13 PM
-- Design Name: 
-- Module Name: main_TB - Behavioral
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

entity main_TB is
--  Port ( );
end main_TB;

architecture Behavioral of main_TB is

component main is
    Port (  CLK : in std_logic;
            RGBin: in std_logic_vector (1 downto 0);
            JackBTN : in std_logic_vector (2 downto 0);
            Jack_Clear_BTN : in std_logic;
            RGBout: out std_logic_vector (2 downto 0);
            RGBout2: out std_logic_vector (2 downto 0);
            R : in std_logic;
            CLK_OUT : out std_logic;
            --Ybcd : out std_logic_vector( 4 downto 0);             
            Yout: out std_logic_vector (2 downto 0); -- LEDs next to the buttons showing the 4-bit counter output in binary
                   
            --Yout1, Yout2 : out std_logic_vector (3 downto 0); 
                   
            Yseg7: out  std_logic_vector (7 downto 0); 
            Yan7: out  std_logic_vector (7 downto 0));  -- The anodes, selects which digits should be filled with the Yseg7 inidividual lights      
end component;


signal CLK : std_logic := '0';
signal RGBin : std_logic_vector (1 downto 0) := (others => '1');
signal RGBout : std_logic_vector (2 downto 0);
signal RGBout2 : std_logic_vector (2 downto 0);
signal R : std_logic := '0';
signal CLK_OUT : std_logic;
--signal Ybcd : std_logic_vector( 4 downto 0);             
signal Yout : std_logic_vector (3 downto 0); -- LEDs next to the buttons showing the 4-bit counter output in binary
signal Yout1, Yout2 : std_logic_vector (3 downto 0); 
signal Yseg7 : std_logic_vector (7 downto 0); 
signal Yan7 : std_logic_vector (7 downto 0);  -- The anodes, selects which digits should be filled with the Yseg7 inidividual lights 
signal JackBTN : std_logic_vector (2 downto 0);
signal Jack_Clear_BTN : std_logic;

begin


--uut1 : component main port map(CLK => CLK, RGBin => RGBin, RGBout => RGBout, RGBout2 => RGBout2, R => R, CLK_OUT => CLK_OUT, Yout => Yout, Yout1 => Yout1, Yout2 => Yout2, Yseg7 => Yseg7, Yan7 => Yan7);
uut1 : component main port map(CLK => CLK, RGBin => RGBin, RGBout => RGBout, RGBout2 => RGBout2,JackBTN => JackBTN, Jack_Clear_BTN => Jack_Clear_BTN, R => R, CLK_OUT => CLK_OUT, Yout => Yout, Yseg7 => Yseg7, Yan7 => Yan7);

process
begin
wait for 10ns;
CLK <= not CLK;
end process;


process
begin
wait for 30ms;
JackBTN(0) <= '1';
end process;

process
begin
wait for 40ms;
JackBTN(1) <= '1';
end process;

process
begin
wait for 50ms;
JackBTN(2) <= '1';
end process;

process
begin
wait for 200ms;
--R <= '1';
R <= not R;
--wait;
end process;



end Behavioral;
