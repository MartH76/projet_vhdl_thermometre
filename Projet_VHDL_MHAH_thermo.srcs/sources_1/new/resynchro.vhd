----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.02.2022 09:06:25
-- Design Name: 
-- Module Name: resynchro - Behavioral
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

entity resynchro is
Port ( 
    clk : in std_logic;
    oneW_in : in std_logic;
    oneW_synchro : out std_logic);
end resynchro;

architecture Behavioral of resynchro is
signal s_resynchro_interne1 : std_logic;
signal s_resynchro_interne2 : std_logic;

begin
process(clk)
begin
if rising_edge(clk) then 
    oneW_synchro <= s_resynchro_interne2;    
    s_resynchro_interne1 <= oneW_in;
    s_resynchro_interne2 <= s_resynchro_interne1;
end if;
end process;
end Behavioral;
