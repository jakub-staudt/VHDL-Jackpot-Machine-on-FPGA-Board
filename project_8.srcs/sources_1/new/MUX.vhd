----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2025 11:54:47 AM
-- Design Name: 
-- Module Name: MUX - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX is
    Port ( X0 : in STD_LOGIC_VECTOR (2 downto 0);
           X1 : in STD_LOGIC_VECTOR (2 downto 0);
           X2 : in STD_LOGIC_VECTOR (2 downto 0);
           Ymux : out STD_LOGIC_VECTOR (3 downto 0);
           S : in STD_LOGIC_VECTOR (1 downto 0));
end MUX;

architecture Behavioral of MUX is

signal S1, S0 : std_logic_vector (2 downto 0); -- select


begin

S1 <= (others =>(S(1)));
S0 <= (others =>(S(0)));

Ymux(3) <= '0';
Ymux(2 downto 0) <= (not S1 and not S0 and X0) or (not S1 and S0  and X1) 
or (S1 and not S0 and X2);

end Behavioral;
