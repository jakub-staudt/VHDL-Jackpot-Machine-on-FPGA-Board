----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.04.2024 14:52:11
-- Design Name: 
-- Module Name: sync4bitupTff - Behavioral
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

entity sync4bitupTff is
    Port ( CLK : in STD_LOGIC;
           R : in STD_LOGIC;
           --S_set : in std_logic_vector(3 downto 0);
           Y : out STD_LOGIC_VECTOR (2 downto 0));
end sync4bitupTff;

architecture Behavioral of sync4bitupTff is

component TFF is
    Port ( S : in STD_LOGIC;
           R : in STD_LOGIC;
           CLK : in STD_LOGIC;
           T : in STD_LOGIC;
           Q : out STD_LOGIC;
           NQ : out STD_LOGIC);
end component;

signal T,Q,NQ : std_logic_vector(2 downto 0);
signal S : std_logic_vector(2 downto 0) :=  (others => '0'); -- This never changes in the code, it forces '0's always to the Reset (R) in the TFF.
--signal S : std_logic_vector(2 downto 0) :=  "001"; -- This never changes in the code, it forces '0's always to the Reset (R) in the TFF.
--signal S : std_logic_vector(2 downto 0) := S_set; 



begin
--S(0) := (others => '0');
--S(1) := (others => '0');
--S(2) := (others => '0');


ff0: component Tff port map (S=>S(0),R=>R,CLK=>CLK,T=>T(0),Q=>Q(0),NQ=>NQ(0));
ff1: component Tff port map (S=>S(1),R=>R,CLK=>CLK,T=>T(1),Q=>Q(1),NQ=>NQ(1));
ff2: component Tff port map (S=>S(2),R=>R,CLK=>CLK,T=>T(2),Q=>Q(2),NQ=>NQ(2));




--C0unter 0 -> 7
T(0)<= '1';
T(1)<= Q(0);
T(2)<= Q(1) and Q(0);



--Working counter 0 -> 9
--T(0)<= '1';
--T(1)<= not Q(3) and Q(0);
--T(2)<= not Q(3) and Q(1) and Q(0);
--T(3)<= (not Q(3) and Q(2) and Q(1) and Q(0)) OR (Q(3) and not Q(2) and not Q(1) and Q(0));


Y<=Q;


end Behavioral;
