----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/14/2025 11:30:23 AM
-- Design Name: 
-- Module Name: RBG_leds - Behavioral
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

entity RBG_leds is
    Port     ( color_state : in STD_LOGIC_VECTOR (1 downto 0);
           RGBout : out STD_LOGIC_VECTOR (2 downto 0);
           clk : in std_logic;
           clk_slow : in STD_LOGIC);
           
end RBG_leds;

architecture Behavioral of RBG_leds is

signal counter : std_logic_vector (15 downto 0) := (others => '0') ;
signal clk2 : std_logic ;
signal clk_vec : std_logic_vector (2 downto 0) := (others => '0') ;
signal RGB1 : std_logic_vector (2 downto 0);
--signal err, blink: std_logic ;
signal blink: std_logic ;
begin

--PWM of LED
process(clk)
begin
        if (rising_edge(clk))then 
            counter <= counter + 1 ;
            if (counter = 40000) then
            clk2 <= '1';
            counter  <= (others => '0') ;
            
            elsif (counter = 500) then
            clk2 <= '0';
         end if;
      end if;  
end process;

-- sets the array for the different LEDs to turn on based on the state
process (color_state)
begin
case color_state is
        --RGB
        when"00" =>
        RGB1<=   "000";
        --err <= '1';
        
        when"01" =>
        RGB1<= "010";
         --err <= '0';
        
         when"10" =>
        RGB1<= "001"; --red
         --err <= '0';
        
         when"11" =>
        RGB1<= "110"; --yellow
         --err <= '0';
         
         when others => --optional
         RGB1 <= "100";
         --err <= '1';
end case;
end process;

--blink <= err and clk_slow;
clk_vec <= (others => clk2);
--RGBout <= RGB1 and clk_vec;
RGBout <= RGB1 and clk_vec;


end Behavioral;
