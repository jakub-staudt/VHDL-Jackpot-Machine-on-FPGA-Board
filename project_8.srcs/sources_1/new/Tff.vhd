----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.04.2024 14:35:00
-- Design Name: 
-- Module Name: Tff - Behavioral
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

entity Tff is
    Port ( S : in STD_LOGIC;
           R : in STD_LOGIC;
           CLK : in STD_LOGIC;
           T : in STD_LOGIC;
           Q : out STD_LOGIC;
           NQ : out STD_LOGIC);
end Tff;

architecture Behavioral of Tff is


signal tmp : std_logic := '0';
--signal tmp : std_logic;

begin

process(R,CLK) -- Run the code inside, whenever there's a change on R or CLK
begin
    if (R='1') then
        tmp <= '0'; --  Q <- Set (S), immidiatetly when Reset (R). Set (S) is only when Reset (R) is active,otherwise normal toggling (happens below)
    elsif(rising_edge(CLK) and T='1') then
        tmp <= not tmp; --toggle
    end if;
end process;

Q<=tmp;
NQ<=not tmp;

end Behavioral;
