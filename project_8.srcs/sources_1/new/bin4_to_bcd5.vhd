----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.04.2024 16:22:02
-- Design Name: 
-- Module Name: bin4bittobcd5bit - Behavioral
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

entity bin4_to_bcd5 is
    Port ( X : in STD_LOGIC_VECTOR (3 downto 0);
           Y : out STD_LOGIC_VECTOR (4 downto 0));
end bin4_to_bcd5;

architecture Behavioral of bin4_to_bcd5 is

begin

-- Divides the [3:0] to [4:0]   


Y(0)<=X(0);
Y(1)<=(X(3) and X(2) and not X(1)) or (not X(3) and X(1));
Y(2)<=(not X(3) and X(2)) or (X(1) and X(2));
Y(3)<=X(3) and not X(2) and not X(1);
Y(4)<=(X(3) and X(2)) or (X(3) and X(1));

end Behavioral;
