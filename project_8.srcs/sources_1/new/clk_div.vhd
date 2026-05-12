----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2025 12:24:5456 PM
-- Design Name: 
-- Module Name: clk_div - Behavioral
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

entity clk_div is
    Port ( CLK_IN : in STD_LOGIC;            
           CLK_OUT1 : out STD_LOGIC; -- slow clock (standard)
           CLK_OUT2 : out STD_LOGIC; -- medium-speed clock
           CLK_OUT3 : out STD_LOGIC); -- fast clock  
           --CLK_OUT3 : out STD_LOGIC); -- faster clock than CLK_OUT (but way slower than main CLK)
end clk_div;

architecture Behavioral of clk_div is


--signal BUF : std_logic_vector(25 downto 0) := (others => '0');
signal BUF : std_logic_vector(20 downto 0) := (others => '0');

begin
process(CLK_IN)
begin
if(rising_edge(CLK_in))then

BUF <= BUF +1;
end if;

end process;

--CLK_OUT <= BUF(15); -- previous 25
--CLK_OUT2 <=BUF(4);  -- PREVIOUS 4
--CLK_OUT3 <=BUF(4);  -- PREVIOUS 4


CLK_OUT1 <= BUF(20); -- output '1' when we reach a '1' 24-bit (slower clock)
--CLK_OUT1 <= BUF(24); -- output '1' when we reach a '1' 24-bit (slower clock)
CLK_OUT2 <= BUF(18);  -- medium- clk
CLK_OUT3 <= BUF(12);  -- faster clock, outputs '1' eariler then the above clock
--CLK_OUT3 <= BUF(10);  -- new


end Behavioral;
