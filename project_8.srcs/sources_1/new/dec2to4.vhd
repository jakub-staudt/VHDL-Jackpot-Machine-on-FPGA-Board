----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.04.2024 16:22:10
-- Design Name: 
-- Module Name: dec2to4 - Behavioral
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

entity dec2to4 is
    Port ( Xdec : in STD_LOGIC_VECTOR (1 downto 0);
           Ydec : out STD_LOGIC_VECTOR (2 downto 0));
end dec2to4;

architecture Behavioral of dec2to4 is
    
begin
    --The individual digit select (currently there are 4  digits, and we choose for which one we will change the 7seg)
    Ydec(0)<=not Xdec(1) and not Xdec(0);
    Ydec(1)<=not Xdec(1) and Xdec(0);
    Ydec(2)<=Xdec(1) and not Xdec(0);
    --Ydec(3)<=Xdec(1) and Xdec(0);   


end Behavioral;
